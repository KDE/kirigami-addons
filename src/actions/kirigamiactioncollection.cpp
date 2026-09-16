/*
    This file is part of the KDE libraries
    SPDX-FileCopyrightText: 1999 Reginald Stadlbauer <reggie@kde.org>
    SPDX-FileCopyrightText: 1999 Simon Hausmann <hausmann@kde.org>
    SPDX-FileCopyrightText: 2000 Nicolas Hadacek <haadcek@kde.org>
    SPDX-FileCopyrightText: 2000 Kurt Granroth <granroth@kde.org>
    SPDX-FileCopyrightText: 2000 Michael Koch <koch@kde.org>
    SPDX-FileCopyrightText: 2001 Holger Freyther <freyther@kde.org>
    SPDX-FileCopyrightText: 2002 Ellis Whitehead <ellis@kde.org>
    SPDX-FileCopyrightText: 2002 Joseph Wenninger <jowenn@kde.org>
    SPDX-FileCopyrightText: 2005-2007 Hamish Rodda <rodda@kde.org>

    SPDX-License-Identifier: LGPL-2.0-only
*/

#include "kirigamiactioncollection.h"
#include "abstractkirigamiapplication.h"
#include "actiondata.h"
#include "actionmenu.h"

#include <KAuthorized>
#include <KConfigGroup>
#include <KSharedConfig>
#include "debug.h"

#include <QGuiApplication>
#include <QList>
#include <QMap>
#include <QMetaMethod>
#include <QQmlProperty>
#include <QSet>

static QList<ActionCollectionAttached *> s_attachedProperties;

ActionCollectionAttached::ActionCollectionAttached(QObject *parent)
    : QObject(parent)
{
    s_attachedProperties.append(this);
    rebind();
}

ActionCollectionAttached::~ActionCollectionAttached()
{
    s_attachedProperties.removeAll(this);
}

QString ActionCollectionAttached::collection() const
{
    return m_collection;
}

void ActionCollectionAttached::setCollection(const QString &collection)
{
    if (m_collection == collection) {
        return;
    }
    m_collection = collection;
    rebind();
    Q_EMIT collectionChanged();
}

QVariant ActionCollectionAttached::action() const
{
    return m_actionName;
}

void ActionCollectionAttached::setAction(const QVariant &action)
{
    QString actionName;
    if (action.metaType().id() == QMetaType::QString) {
        actionName = action.toString();
    } else if (action.canConvert<int>()) {
        actionName = KStandardActions::name(static_cast<KStandardActions::StandardAction>(action.toInt()));
    }

    if (m_actionName == actionName) {
        return;
    }
    m_actionName = actionName;
    rebind();
    Q_EMIT actionChanged();
}

void ActionCollectionAttached::rebind()
{
    QObject::disconnect(m_collectionConnection);

    if (m_action) {
        m_action->removeActionInstance(parent());
        m_action.clear();
    }
    if (m_qAction) {
        QQmlProperty property(parent(), QStringLiteral("fromQAction"));
        if (property.isValid() && property.isWritable()) {
            property.write(QVariant());
        }
        m_qAction.clear();
    }

    if (m_collection.isEmpty() || m_actionName.isEmpty()) {
        return;
    }

    for (auto collection : KirigamiActionCollection::allCollections()) {
        if (collection->componentName() != m_collection) {
            continue;
        }
        m_collectionConnection = QObject::connect(collection, &KirigamiActionCollection::inserted, this, [this]() {
            rebind();
        });
        auto action = collection->action(m_actionName);
        m_action = qobject_cast<ActionData *>(action);
        if (m_action) {
            m_action->addActionInstance(parent());
            return;
        }
        if (action) {
            QQmlProperty property(parent(), QStringLiteral("fromQAction"));
            if (property.isValid() && property.isWritable()) {
                property.write(QVariant::fromValue(action));
                m_qAction = action;
            }
            return;
        }
    }
}

class KirigamiActionCollectionPrivate
{
public:
    KirigamiActionCollectionPrivate(KirigamiActionCollection *qq)
        : q(qq)
        , configIsGlobal(false)
        , connectTriggered(false)
        , connectHovered(false)

    {
    }

    static QList<KirigamiActionCollection *> s_allCollections;

    void _k_associatedWidgetDestroyed(QObject *obj);
    void _k_actionDestroyed(QObject *obj);

    QString m_componentName;
    QString m_componentDisplayName;

    //! Remove a action from our internal bookkeeping. Returns a nullptr if the
    //! action doesn't belong to us.
    QAction *unlistAction(QAction *);

    QMap<QString, QAction *> actionByName;
    QList<QAction *> actions;

    KirigamiActionCollection *q = nullptr;

    QString configGroup{QStringLiteral("Shortcuts")};
    bool configIsGlobal : 1;

    bool connectTriggered : 1;
    bool connectHovered : 1;
};

QList<KirigamiActionCollection *> KirigamiActionCollectionPrivate::s_allCollections;

KirigamiActionCollection::KirigamiActionCollection(QObject *parent, const QString &cName)
    : QObject(parent)
    , d(new KirigamiActionCollectionPrivate(this))
{
    connect(this, &KirigamiActionCollection::actionsChanged, this, &KirigamiActionCollection::menusChanged, Qt::UniqueConnection);
    setObjectName(cName);
    KirigamiActionCollectionPrivate::s_allCollections.append(this);
    for (auto attached : std::as_const(s_attachedProperties)) {
        attached->rebind();
    }
}

AbstractKirigamiApplication *KirigamiActionCollection::application() const
{
    return m_application;
}

QString KirigamiActionCollection::name() const
{
    return componentName();
}

void KirigamiActionCollection::setName(const QString &name)
{
    if (componentName() == name) {
        return;
    }
    setComponentName(name);
    for (auto attached : std::as_const(s_attachedProperties)) {
        attached->rebind();
    }
    Q_EMIT nameChanged();
}

void KirigamiActionCollection::setApplication(AbstractKirigamiApplication *application)
{
    if (m_application == application) {
        return;
    }
    auto *oldApplication = m_application.data();
    QObject::disconnect(m_applicationMenusConnection);
    m_application = application;
    if (m_application) {
        m_applicationMenusConnection = connect(this, &KirigamiActionCollection::menusChanged, m_application, [application]() {
            QMetaObject::invokeMethod(application, "actionCollectionsChanged", Qt::DirectConnection);
        });
    }
    if (m_qmlComplete) {
        for (auto action : std::as_const(m_qmlActions)) {
            insertQmlAction(action);
        }
    }
    Q_EMIT applicationChanged();
    if (oldApplication) {
        QMetaObject::invokeMethod(oldApplication, "actionCollectionsChanged", Qt::DirectConnection);
    }
    if (m_application) {
        QMetaObject::invokeMethod(m_application, "actionCollectionsChanged", Qt::DirectConnection);
    }
}

QString KirigamiActionCollection::text() const
{
    return m_qmlText.isEmpty() ? componentDisplayName() : m_qmlText;
}

bool KirigamiActionCollection::isQmlComplete() const
{
    return m_qmlComplete;
}

void KirigamiActionCollection::setText(const QString &text)
{
    if (m_qmlText == text) {
        return;
    }
    m_qmlText = text;
    setComponentDisplayName(text);
    Q_EMIT textChanged();
}

QQmlListProperty<ActionData> KirigamiActionCollection::qmlActions()
{
    return {this, nullptr, [](QQmlListProperty<ActionData> *property, ActionData *action) {
                static_cast<KirigamiActionCollection *>(property->object)->insertQmlAction(action);
            },
            [](QQmlListProperty<ActionData> *property) {
                return static_cast<KirigamiActionCollection *>(property->object)->m_qmlActions.size();
            },
            [](QQmlListProperty<ActionData> *property, qsizetype index) {
                const auto actions = static_cast<KirigamiActionCollection *>(property->object)->m_qmlActions;
                return index >= 0 && index < actions.size() ? actions.at(index) : nullptr;
            },
            nullptr};
}

QQmlListProperty<ActionMenu> KirigamiActionCollection::qmlMenus()
{
    return {this, nullptr, [](QQmlListProperty<ActionMenu> *property, ActionMenu *menu) {
        static_cast<KirigamiActionCollection *>(property->object)->insertQmlMenu(menu);
    }, [](QQmlListProperty<ActionMenu> *property) {
        return static_cast<KirigamiActionCollection *>(property->object)->m_qmlMenus.size();
    }, [](QQmlListProperty<ActionMenu> *property, qsizetype index) {
        const auto menus = static_cast<KirigamiActionCollection *>(property->object)->m_qmlMenus;
        return index >= 0 && index < menus.size() ? menus.at(index) : nullptr;
    }, [](QQmlListProperty<ActionMenu> *property) {
        auto collection = static_cast<KirigamiActionCollection *>(property->object);
        for (auto *menu : std::as_const(collection->m_qmlMenus)) {
            menu->setCollection(nullptr);
            menu->setParent(nullptr);
        }
        collection->m_qmlMenus.clear();
        Q_EMIT collection->menusChanged();
    }};
}

void KirigamiActionCollection::insertQmlMenu(ActionMenu *menu)
{
    if (!menu || m_qmlMenus.contains(menu)) {
        return;
    }
    m_qmlMenus.append(menu);
    menu->setCollection(this);
    menu->setParent(this);
    connect(menu, &ActionMenu::mergedActionsChanged, this, &KirigamiActionCollection::menusChanged, Qt::UniqueConnection);
    connect(menu, &ActionMenu::mergedItemsChanged, this, &KirigamiActionCollection::menusChanged, Qt::UniqueConnection);
    connect(menu, &ActionMenu::mergedMenusChanged, this, &KirigamiActionCollection::menusChanged, Qt::UniqueConnection);
    connect(menu, &ActionMenu::nameChanged, this, &KirigamiActionCollection::menusChanged, Qt::UniqueConnection);
    connect(menu, &ActionMenu::textChanged, this, &KirigamiActionCollection::menusChanged, Qt::UniqueConnection);
    connect(menu, &ActionMenu::iconNameChanged, this, &KirigamiActionCollection::menusChanged, Qt::UniqueConnection);
    Q_EMIT menusChanged();
}

const QList<ActionMenu *> &KirigamiActionCollection::registeredMenus() const
{
    return m_qmlMenus;
}

ActionCollectionAttached *KirigamiActionCollection::qmlAttachedProperties(QObject *object)
{
    return new ActionCollectionAttached(object);
}

void KirigamiActionCollection::insertQmlAction(ActionData *action)
{
    if (!action) {
        return;
    }

    if (!m_qmlActions.contains(action)) {
        m_qmlActions.append(action);
        action->setParent(this);
    }

    if (m_qmlComplete && m_application && this->action(action->name()) != action) {
        addAction(action->name(), action);
        setComponentDisplayName(text());
        readSettings();
    }
}

void KirigamiActionCollection::classBegin()
{
}

void KirigamiActionCollection::componentComplete()
{
    m_qmlComplete = true;
    if (m_application) {
        for (auto action : std::as_const(m_qmlActions)) {
            insertQmlAction(action);
        }
    }
}

KirigamiActionCollection::~KirigamiActionCollection()
{
    KirigamiActionCollectionPrivate::s_allCollections.removeAll(this);
    if (m_application) {
        QMetaObject::invokeMethod(m_application, "actionCollectionsChanged", Qt::DirectConnection);
    }
}

void KirigamiActionCollection::clear()
{
    d->actionByName.clear();
    qDeleteAll(d->actions);
    d->actions.clear();
    Q_EMIT actionsChanged();
}

QAction *KirigamiActionCollection::action(const QString &name) const
{
    QAction *action = nullptr;

    if (!name.isEmpty()) {
        action = d->actionByName.value(name);
    }

    return action;
}

QAction *KirigamiActionCollection::action(int index) const
{
    // ### investigate if any apps use this at all
    return actions().value(index);
}

int KirigamiActionCollection::count() const
{
    return d->actions.count();
}

bool KirigamiActionCollection::isEmpty() const
{
    return count() == 0;
}

void KirigamiActionCollection::setComponentName(const QString &cName)
{
    if (!cName.isEmpty()) {
        d->m_componentName = cName;
    } else {
        d->m_componentName = QCoreApplication::applicationName();
    }
}

QString KirigamiActionCollection::componentName() const
{
    return d->m_componentName;
}

void KirigamiActionCollection::setComponentDisplayName(const QString &displayName)
{
    d->m_componentDisplayName = displayName;
}

QString KirigamiActionCollection::componentDisplayName() const
{
    if (!d->m_componentDisplayName.isEmpty()) {
        return d->m_componentDisplayName;
    }
    if (!QGuiApplication::applicationDisplayName().isEmpty()) {
        return QGuiApplication::applicationDisplayName();
    }
    return QCoreApplication::applicationName();
}

QList<QAction *> KirigamiActionCollection::actions() const
{
    return d->actions;
}

const QList<QAction *> KirigamiActionCollection::actionsWithoutGroup() const
{
    QList<QAction *> ret;
    for (QAction *action : std::as_const(d->actions)) {
        if (!action->actionGroup()) {
            ret.append(action);
        }
    }
    return ret;
}

const QList<QActionGroup *> KirigamiActionCollection::actionGroups() const
{
    QSet<QActionGroup *> set;
    for (QAction *action : std::as_const(d->actions)) {
        if (action->actionGroup()) {
            set.insert(action->actionGroup());
        }
    }
    return set.values();
}

QAction *KirigamiActionCollection::addAction(const QString &name, QAction *action)
{
    if (!action) {
        return action;
    }

    const QString objectName = action->objectName();
    QString indexName = name;

    if (indexName.isEmpty()) {
        // No name provided. Use the objectName.
        indexName = objectName;

    } else {
        // A name was provided. Check against objectName.
        if ((!objectName.isEmpty()) && (objectName != indexName)) {
            // The user specified a new name and the action already has a
            // different one. The objectName is used for saving shortcut
            // settings to disk. Both for local and global shortcuts.
            qCDebug(BASEAPP_LOG) << "Registering action " << objectName << " under new name " << indexName;
            // If there is a global shortcuts it's a very bad idea.
        }

        // Set the new name
        action->setObjectName(indexName);
    }

    // No name provided and the action had no name. Make one up. This will not
    // work when trying to save shortcuts. Both local and global shortcuts.
    if (indexName.isEmpty()) {
        indexName = QString::asprintf("unnamed-%p", (void *)action);
        action->setObjectName(indexName);
    }

    // From now on the objectName has to have a value. Else we cannot safely
    // remove actions.
    Q_ASSERT(!action->objectName().isEmpty());

    // look if we already have THIS action under THIS name ;)
    if (d->actionByName.value(indexName, nullptr) == action) {
        // This is not a multi map!
        Q_ASSERT(d->actionByName.count(indexName) == 1);
        return action;
    }

    if (!KAuthorized::authorizeAction(indexName)) {
        // Disable this action
        action->setEnabled(false);
        action->setVisible(false);
        action->blockSignals(true);
    }

    // Check if we have another action under this name
    if (QAction *oldAction = d->actionByName.value(indexName)) {
        takeAction(oldAction);
    }

    // Check if we have this action under a different name.
    // Not using takeAction because we don't want to remove it from categories,
    // and because it has the new name already.
    const int oldIndex = d->actions.indexOf(action);
    if (oldIndex != -1) {
        d->actionByName.remove(d->actionByName.key(action));
        d->actions.removeAt(oldIndex);
    }

    // Add action to our lists.
    d->actionByName.insert(indexName, action);
    d->actions.append(action);

    connect(action, &QObject::destroyed, this, [this](QObject *obj) {
        d->_k_actionDestroyed(obj);
    });

    if (d->connectHovered) {
        connect(action, &QAction::hovered, this, &KirigamiActionCollection::slotActionHovered);
    }

    if (d->connectTriggered) {
        connect(action, &QAction::triggered, this, &KirigamiActionCollection::slotActionTriggered);
    }

    Q_EMIT inserted(action);
    Q_EMIT actionsChanged();
    Q_EMIT changed();
    return action;
}

void KirigamiActionCollection::addActions(const QList<QAction *> &actions)
{
    for (QAction *action : actions) {
        addAction(action->objectName(), action);
    }
}

void KirigamiActionCollection::removeAction(QAction *action)
{
    delete takeAction(action);
}

QAction *KirigamiActionCollection::takeAction(QAction *action)
{
    if (!d->unlistAction(action)) {
        return nullptr;
    }

    action->disconnect(this);

    Q_EMIT actionsChanged();
    Q_EMIT changed();
    return action;
}

QKeySequence KirigamiActionCollection::defaultShortcut(QAction *action)
{
    const QList<QKeySequence> shortcuts = defaultShortcuts(action);
    return shortcuts.isEmpty() ? QKeySequence() : shortcuts.first();
}

QList<QKeySequence> KirigamiActionCollection::defaultShortcuts(QAction *action)
{
    return action->property("defaultShortcuts").value<QList<QKeySequence>>();
}

void KirigamiActionCollection::setDefaultShortcut(QAction *action, const QKeySequence &shortcut)
{
    setDefaultShortcuts(action, QList<QKeySequence>() << shortcut);
}

void KirigamiActionCollection::setDefaultShortcuts(QAction *action, const QList<QKeySequence> &shortcuts)
{
    action->setShortcuts(shortcuts);
    action->setProperty("defaultShortcuts", QVariant::fromValue(shortcuts));
}

bool KirigamiActionCollection::isShortcutsConfigurable(QAction *action)
{
    // Considered as true by default
    const QVariant value = action->property("isShortcutConfigurable");
    return value.isValid() ? value.toBool() : true;
}

void KirigamiActionCollection::setShortcutsConfigurable(QAction *action, bool configurable)
{
    action->setProperty("isShortcutConfigurable", configurable);
}

QString KirigamiActionCollection::configGroup() const
{
    return d->configGroup;
}

void KirigamiActionCollection::setConfigGroup(const QString &group)
{
    d->configGroup = group;
}

bool KirigamiActionCollection::configIsGlobal() const
{
    return d->configIsGlobal;
}

void KirigamiActionCollection::setConfigGlobal(bool global)
{
    d->configIsGlobal = global;
}

void KirigamiActionCollection::readSettings(KConfigGroup *config)
{
    KConfigGroup cg(KSharedConfig::openConfig(), configGroup());
    if (!config) {
        config = &cg;
    }

    if (!config->exists()) {
        return;
    }

    for (auto it = d->actionByName.constBegin(); it != d->actionByName.constEnd(); ++it) {
        QAction *action = it.value();
        if (!action) {
            continue;
        }

        if (isShortcutsConfigurable(action)) {
            const QString &actionName = it.key();
            QString entry = config->readEntry(actionName, QString());
            if (!entry.isEmpty()) {
                action->setShortcuts(QKeySequence::listFromString(entry));
            } else {
                action->setShortcuts(defaultShortcuts(action));
            }
        }
    }

    // qCDebug(BASEAPP_LOG) << " done";
}

void KirigamiActionCollection::writeSettings(KConfigGroup *config, bool writeAll, QAction *oneAction) const
{
    KConfigGroup cg(KSharedConfig::openConfig(), configGroup());
    if (!config) {
        config = &cg;
    }

    QList<QAction *> writeActions;
    if (oneAction) {
        writeActions.append(oneAction);
    } else {
        writeActions = actions();
    }

    for (QMap<QString, QAction *>::ConstIterator it = d->actionByName.constBegin(); it != d->actionByName.constEnd(); ++it) {
        QAction *action = it.value();
        if (!action) {
            continue;
        }

        const QString &actionName = it.key();

        // If the action name starts with unnamed- spit out a warning and ignore
        // it. That name will change at will and will break loading writing
        if (actionName.startsWith(QLatin1String("unnamed-"))) {
            qCCritical(BASEAPP_LOG) << "Skipped saving Shortcut for action without name " << action->text() << "!";
            continue;
        }

        // Write the shortcut
        if (isShortcutsConfigurable(action)) {
            bool bConfigHasAction = !config->readEntry(actionName, QString()).isEmpty();
            bool bSameAsDefault = (action->shortcuts() == defaultShortcuts(action));
            // If we're using a global config or this setting
            //  differs from the default, then we want to write.
            KConfigGroup::WriteConfigFlags flags = KConfigGroup::Persistent;

            // Honor the configIsGlobal() setting
            if (configIsGlobal()) {
                flags |= KConfigGroup::Global;
            }

            if (writeAll || !bSameAsDefault) {
                // We are instructed to write all shortcuts or the shortcut is
                // not set to its default value. Write it
                QString s = QKeySequence::listToString(action->shortcuts());
                if (s.isEmpty()) {
                    s = QStringLiteral("none");
                }
                qCDebug(BASEAPP_LOG) << "\twriting " << actionName << " = " << s;
                config->writeEntry(actionName, s, flags);
            } else if (bConfigHasAction) {
                // Otherwise, this key is the same as default but exists in
                // config file. Remove it.
                qCDebug(BASEAPP_LOG) << "\tremoving " << actionName << " because == default";
                config->deleteEntry(actionName, flags);
            }
        }
    }

    config->sync();
}

void KirigamiActionCollection::slotActionTriggered()
{
    QAction *action = qobject_cast<QAction *>(sender());
    if (action) {
        Q_EMIT actionTriggered(action);
    }
}

void KirigamiActionCollection::slotActionHovered()
{
    QAction *action = qobject_cast<QAction *>(sender());
    if (action) {
        Q_EMIT actionHovered(action);
    }
}

// The downcast from a QObject to a QAction triggers UBSan
// but we're only comparing pointers, so UBSan shouldn't check vptrs
// Similar to https://github.com/itsBelinda/plog/pull/1/files
#if defined(__clang__) || __GNUC__ >= 8
__attribute__((no_sanitize("vptr")))
#endif
void KirigamiActionCollectionPrivate::_k_actionDestroyed(QObject *obj)
{
    // obj isn't really a QAction anymore. So make sure we don't do fancy stuff
    // with it.
    QAction *action = static_cast<QAction *>(obj);

    if (!unlistAction(action)) {
        return;
    }

    Q_EMIT q->actionsChanged();
    Q_EMIT q->changed();
}

void KirigamiActionCollection::connectNotify(const QMetaMethod &signal)
{
    if (d->connectHovered && d->connectTriggered) {
        return;
    }

    if (signal.methodSignature() == "actionHovered(QAction*)") {
        if (!d->connectHovered) {
            d->connectHovered = true;
            for (QAction *action : std::as_const(d->actions)) {
                connect(action, &QAction::hovered, this, &KirigamiActionCollection::slotActionHovered);
            }
        }

    } else if (signal.methodSignature() == "actionTriggered(QAction*)") {
        if (!d->connectTriggered) {
            d->connectTriggered = true;
            for (QAction *action : std::as_const(d->actions)) {
                connect(action, &QAction::triggered, this, &KirigamiActionCollection::slotActionTriggered);
            }
        }
    }

    QObject::connectNotify(signal);
}

const QList<KirigamiActionCollection *> &KirigamiActionCollection::allCollections()
{
    return KirigamiActionCollectionPrivate::s_allCollections;
}

QAction *KirigamiActionCollectionPrivate::unlistAction(QAction *action)
{
    // ATTENTION:
    //   This method is called with an QObject formerly known as a QAction
    //   during _k_actionDestroyed(). So don't do fancy stuff here that needs a
    //   real QAction!

    // Get the index for the action
    int index = actions.indexOf(action);

    // Action not found.
    if (index == -1) {
        return nullptr;
    }

    // An action collection can't have the same action twice.
    Q_ASSERT(actions.indexOf(action, index + 1) == -1);

    // Get the actions name
    const QString name = action->objectName();

    // Remove the action
    actionByName.remove(name);
    actions.removeAt(index);

    return action;
}

#include "moc_kirigamiactioncollection.cpp"
