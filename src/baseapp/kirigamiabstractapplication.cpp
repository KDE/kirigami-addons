// SPDX-FileCopyrightText: 2023 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "kirigamiabstractapplication.h"
#include "commandbarfiltermodel_p.h"
#include "actionsmodel_p.h"
#include "shortcutsmodel_p.h"
#include <KAboutData>
#include <KAuthorized>
#include <KConfigGroup>
#include <KLocalizedString>
#include <KSharedConfig>
//#include <KShortcutsDialog>
#include <QDebug>
#include <QGuiApplication>

class KirigamiAbstractApplication::Private
{
public:
    KalCommandBarModel *actionModel = nullptr;
    QSortFilterProxyModel *proxyModel = nullptr;
    KirigamiActionCollection *collection = nullptr;
    ShortcutsModel *shortcutsModel = nullptr;
};

KirigamiAbstractApplication::KirigamiAbstractApplication(QObject *parent)
    : QObject(parent)
    , d(std::make_unique<Private>())
{
    d->collection = new KirigamiActionCollection(parent);
}

KirigamiAbstractApplication::~KirigamiAbstractApplication()
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
static QList<KalCommandBarModel::ActionGroup> actionCollectionToActionGroup(const QList<KirigamiActionCollection *> &actionCollections)
{
    using ActionGroup = KalCommandBarModel::ActionGroup;

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

QSortFilterProxyModel *KirigamiAbstractApplication::actionsModel()
{
    if (!d->proxyModel) {
        d->actionModel = new KalCommandBarModel(this);
        d->proxyModel = new CommandBarFilterModel(this);
        d->proxyModel->setSortRole(KalCommandBarModel::Score);
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

QAbstractListModel *KirigamiAbstractApplication::shortcutsModel()
{
    if (!d->shortcutsModel) {
        d->shortcutsModel = new ShortcutsModel(this);
    }

    d->shortcutsModel->refresh(actionCollectionToActionGroup(actionCollections()));
    return d->shortcutsModel;
}

QAction *KirigamiAbstractApplication::action(const QString &name)
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

QList<KirigamiActionCollection *> KirigamiAbstractApplication::actionCollections() const
{
    return QList{
        d->collection,
    };
}

KirigamiActionCollection *KirigamiAbstractApplication::mainCollection() const
{
    return d->collection;
}

void KirigamiAbstractApplication::setupActions()
{
    auto actionName = QLatin1StringView("open_kcommand_bar");
    if (KAuthorized::authorizeAction(actionName)) {
        auto openKCommandBarAction = d->collection->addAction(actionName, this, &KirigamiAbstractApplication::openKCommandBarAction);
        openKCommandBarAction->setText(i18n("Open Command Bar"));
        openKCommandBarAction->setIcon(QIcon::fromTheme(QStringLiteral("new-command-alarm")));

        d->collection->addAction(openKCommandBarAction->objectName(), openKCommandBarAction);
        d->collection->setDefaultShortcut(openKCommandBarAction, QKeySequence(Qt::CTRL | Qt::ALT | Qt::Key_I));
    }

    actionName = QLatin1StringView("file_quit");
    if (KAuthorized::authorizeAction(actionName)) {
        auto action = KStandardActions::quit(this, &KirigamiAbstractApplication::quit, this);
        d->collection->addAction(action->objectName(), action);
    }

    actionName = QLatin1StringView("options_configure_keybinding");
    if (KAuthorized::authorizeAction(actionName)) {
        auto keyBindingsAction = KStandardActions::keyBindings(this, &KirigamiAbstractApplication::shortcutsEditorAction, this);
        d->collection->addAction(keyBindingsAction->objectName(), keyBindingsAction);
    }

    actionName = QLatin1StringView("open_about_page");
    if (KAuthorized::authorizeAction(actionName)) {
        auto action = d->collection->addAction(actionName, this, &KirigamiAbstractApplication::openAboutPage);
        action->setText(i18n("About %1", KAboutData::applicationData().displayName()));
        action->setIcon(QIcon::fromTheme(QStringLiteral("help-about")));
    }

    actionName = QLatin1StringView("open_about_kde_page");
    if (KAuthorized::authorizeAction(actionName)) {
        auto action = d->collection->addAction(actionName, this, &KirigamiAbstractApplication::openAboutKDEPage);
        action->setText(i18n("About KDE"));
        action->setIcon(QIcon::fromTheme(QStringLiteral("kde")));
    }
}

void KirigamiAbstractApplication::quit()
{
    qGuiApp->exit();
}

QString KirigamiAbstractApplication::iconName(const QIcon &icon) const
{
    return icon.name();
}

#include "moc_kirigamiabstractapplication.cpp"
