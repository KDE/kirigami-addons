// SPDX-FileCopyrightText: 2023 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "abstractkirigamiapplication.h"
#include "actionmenu.h"
#include "commandbarfiltermodel_p.h"
#include "actionsmodel_p.h"
#include "shortcutsmodel_p.h"
#include "private/declarativeapplication.h"
#include <KAboutData>
#include <KAuthorized>
#include <KConfigGroup>
#include <KLocalizedString>
#include <KSharedConfig>
#include <QGuiApplication>
#include <qqml.h>

using namespace std::chrono_literals;
using namespace Qt::StringLiterals;

namespace
{
[[maybe_unused]] const auto legacyApplicationType = qmlRegisterUncreatableType<AbstractKirigamiApplication>(
    "org.kde.kirigamiaddons.statefulapp", 1, 0, "AbstractKirigamiApplication", QStringLiteral("Use Application or a subclass"));
[[maybe_unused]] const auto actionsApplicationType = qmlRegisterUncreatableType<AbstractKirigamiApplication>(
    "org.kde.kirigamiaddons.actions", 1, 0, "AbstractKirigamiApplication", QStringLiteral("Use Application or a subclass"));
}

class AbstractKirigamiApplication::Private
{
public:
    KCommandBarModel *actionModel = nullptr;
    QSortFilterProxyModel *proxyModel = nullptr;
    KirigamiActionCollection *collection = nullptr;
    ShortcutsModel *shortcutsModel = nullptr;
    QObject *configurationView = nullptr;
    QAction *openConfigurationViewAction = nullptr;
    ActionMenu *settingsMenu = nullptr;
};

AbstractKirigamiApplication::AbstractKirigamiApplication(QObject *parent)
    : QObject(parent)
    , d(std::make_unique<Private>())
{
    d->collection = new KirigamiActionCollection(this);
    d->collection->setApplication(this);
    d->collection->setComponentName(u"main"_s);
}

AbstractKirigamiApplication::~AbstractKirigamiApplication()
{
    if (d->actionModel) {
        auto lastUsedActions = d->actionModel->lastUsedActions();
        auto cfg = KSharedConfig::openConfig();
        KConfigGroup cg(cfg, QStringLiteral("General"));
        cg.writeEntry("CommandBarLastUsedActions", lastUsedActions);
    }
}

/**
 * A helper function that takes a list of KActionCollection* and converts it
 * to KCommandBar::ActionGroup
 */
static QList<KCommandBarModel::ActionGroup> actionCollectionToActionGroup(const QList<KirigamiActionCollection *> &actionCollections)
{
    using ActionGroup = KCommandBarModel::ActionGroup;

    QList<ActionGroup> actionList;
    actionList.reserve(actionCollections.size());

    for (const auto collection : actionCollections) {
        const auto collectionActions = collection->actions();
        const auto componentName = collection->componentDisplayName();

        ActionGroup ag;
        ag.name = componentName;
        ag.actions.reserve(collection->count());
        for (const auto action : collectionActions) {
            if (action && !action->text().isEmpty()) {
                ag.actions.append(action);
            }
        }
        actionList.append(ag);
    }
    return actionList;
}

void AbstractKirigamiApplication::readSettings()
{
    const auto collections = actionCollections();
    for (const auto collection : collections) {
        collection->readSettings();
    }
}

QSortFilterProxyModel *AbstractKirigamiApplication::actionsModel()
{
    if (!d->proxyModel) {
        d->actionModel = new KCommandBarModel(this);
        d->proxyModel = new CommandBarFilterModel(this);
        d->proxyModel->setSortRole(KCommandBarModel::Score);
        d->proxyModel->setFilterRole(Qt::DisplayRole);
        d->proxyModel->setSourceModel(d->actionModel);
    }

    // setLastUsedActions
    auto cfg = KSharedConfig::openConfig();
    KConfigGroup cg(cfg, QStringLiteral("General"));

    const auto actionNames = cg.readEntry(QStringLiteral("CommandBarLastUsedActions"), QStringList());

    d->actionModel->setLastUsedActions(actionNames);
    d->actionModel->refresh(actionCollectionToActionGroup(actionCollections()));
    return d->proxyModel;
}

QAbstractListModel *AbstractKirigamiApplication::shortcutsModel()
{
    if (!d->shortcutsModel) {
        d->shortcutsModel = new ShortcutsModel(this);
    }

    d->shortcutsModel->refresh(actionCollections());
    return d->shortcutsModel;
}

QAction *AbstractKirigamiApplication::action(const QString &name)
{
    const auto collections = actionCollections();
    for (const auto collection : collections) {
        auto resultAction = collection->action(name);
        if (resultAction) {
            return resultAction;
        }
    }

    qWarning() << "Not found action for name" << name;

    return nullptr;
}

QList<KirigamiActionCollection *> AbstractKirigamiApplication::actionCollections() const
{
    QList<KirigamiActionCollection *> collections{d->collection};
    for (auto *collection : KirigamiActionCollection::allCollections()) {
        if (collection != d->collection && collection->application() == this) {
            collections.append(collection);
        }
    }
    return collections;
}

KirigamiActionCollection *AbstractKirigamiApplication::mainCollection() const
{
    return d->collection;
}

void AbstractKirigamiApplication::setupActions()
{
    auto actionName = QLatin1StringView("open_kcommand_bar");
    if (KAuthorized::authorizeAction(actionName)) {
        auto openKCommandBarAction = d->collection->addAction(actionName, this, &AbstractKirigamiApplication::openKCommandBarAction);
        openKCommandBarAction->setText(i18n("Open Command Bar"));
        openKCommandBarAction->setIcon(QIcon::fromTheme(QStringLiteral("new-command-alarm")));

        d->collection->addAction(openKCommandBarAction->objectName(), openKCommandBarAction);
        d->collection->setDefaultShortcut(openKCommandBarAction, QKeySequence(Qt::CTRL | Qt::ALT | Qt::Key_I));
    }

    actionName = QLatin1StringView("file_quit");
    if (KAuthorized::authorizeAction(actionName)) {
        auto action = KStandardActions::quit(this, &AbstractKirigamiApplication::quit, this);
        d->collection->addAction(action->objectName(), action);
    }

    actionName = QLatin1StringView("options_configure_keybinding");
    if (KAuthorized::authorizeAction(actionName)) {
        auto keyBindingsAction = KStandardActions::keyBindings(this, &AbstractKirigamiApplication::shortcutsEditorAction, this);
        d->collection->addAction(keyBindingsAction->objectName(), keyBindingsAction);
    }

    actionName = QLatin1StringView("open_about_page");
    if (KAuthorized::authorizeAction(actionName)) {
        auto action = d->collection->addAction(actionName, this, &AbstractKirigamiApplication::openAboutPage);
        action->setText(i18n("About %1", KAboutData::applicationData().displayName()));
        action->setIcon(QIcon::fromTheme(QStringLiteral("help-about")));
    }

    actionName = QLatin1StringView("open_about_kde_page");
    if (KAuthorized::authorizeAction(actionName)) {
        auto action = d->collection->addAction(actionName, this, &AbstractKirigamiApplication::openAboutKDEPage);
        action->setText(i18n("About KDE"));
        action->setIcon(QIcon::fromTheme(QStringLiteral("kde")));

        if (!KAboutData::applicationData().desktopFileName().startsWith(u"org.kde."_s)) {
            action->setVisible(false);
        }
    }

    auto fileMenu = new ActionMenu(d->collection);
    fileMenu->setName(u"file"_s);
    fileMenu->setText(i18nc("@title:menu", "File"));
    fileMenu->setActions({u"file_quit"_s});
    d->collection->insertQmlMenu(fileMenu);

    auto settingsMenu = new ActionMenu(d->collection);
    d->settingsMenu = settingsMenu;
    settingsMenu->setName(u"settings"_s);
    settingsMenu->setText(i18nc("@title:menu", "Settings"));
    QStringList settingsActions;
    if (d->collection->action(u"open_kcommand_bar"_s)) {
        settingsActions.append(u"open_kcommand_bar"_s);
    }
    if (d->collection->action(u"options_configure_keybinding"_s)) {
        settingsActions.append(u"options_configure_keybinding"_s);
    }
    settingsMenu->setActions(settingsActions);
    d->collection->insertQmlMenu(settingsMenu);

    auto helpMenu = new ActionMenu(d->collection);
    helpMenu->setName(u"help"_s);
    helpMenu->setText(i18nc("@title:menu", "Help"));
    QStringList helpActions{u"open_about_page"_s};
    if (KAboutData::applicationData().desktopFileName().startsWith(u"org.kde."_s)) {
        helpActions.append(u"open_about_kde_page"_s);
    }
    helpMenu->setActions(helpActions);
    d->collection->insertQmlMenu(helpMenu);
}

void AbstractKirigamiApplication::quit()
{
    qGuiApp->exit();
}

QObject *AbstractKirigamiApplication::configurationView() const
{
    return d->configurationView;
}

void AbstractKirigamiApplication::setConfigurationView(QObject *configurationView)
{
    if (d->configurationView == configurationView) {
        return;
    }

    if (d->configurationView) {
        d->openConfigurationViewAction->setVisible(false);
    }

    d->configurationView = configurationView;
    Q_EMIT configurationViewChanged();

    if (d->configurationView) {
        if (!d->openConfigurationViewAction) {
            // TODO also expose individual ConfigurationModule as action
            d->openConfigurationViewAction = KStandardActions::preferences(this, [this]() {
                QMetaObject::invokeMethod(d->configurationView, "open", Qt::QueuedConnection, QVariant());
            }, this);
            mainCollection()->addAction(d->openConfigurationViewAction->objectName(), d->openConfigurationViewAction);
        }
        d->openConfigurationViewAction->setVisible(true);

        if (d->settingsMenu) {
            auto settingsActions = d->settingsMenu->actions();
            if (!settingsActions.contains(u"options_configure"_s)) {
                settingsActions.append(u"options_configure"_s);
                d->settingsMenu->setActions(settingsActions);
            }
        }

        mainCollection()->readSettings();
    } else if (d->settingsMenu) {
        auto settingsActions = d->settingsMenu->actions();
        settingsActions.removeAll(u"options_configure"_s);
        d->settingsMenu->setActions(settingsActions);
    }
}

#include "moc_abstractkirigamiapplication.cpp"
