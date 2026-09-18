// SPDX-FileCopyrightText: 2025 Marco Martin <notmart@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QAction>
#include <QActionGroup>
#include <QColor>
#include <QPointer>
#include <QQmlListProperty>
#include <QQmlParserStatus>
#include <QtQml/qqml.h>
#include <qqmlregistration.h>

#include <memory>

class KirigamiActionCollection;
class ActionData;
class ActionContext;
class IconGroupPrivate;

/*!
 * \qmltype ActionGroup
 * \inqmlmodule org.kde.kirigamiaddons.actions
 * \brief A group of actions with automatic exclusivity.
 *
 * \since 1.14.0
 */
/*!
 * \class ActionGroup
 * \inmodule KirigamiAddonsActions
 * \internal Not exposed to C++; use the ActionGroup QML type.
 */
class ActionGroup : public QActionGroup
{
    Q_OBJECT
    QML_ELEMENT
    /*! \qmlproperty bool ActionGroup::exclusive
     * Whether actions in this group are mutually exclusive, so that checking
     * one unchecks the others.
     */
    Q_PROPERTY(bool exclusive READ isExclusive WRITE setExclusive FINAL)
public:
    explicit ActionGroup(QObject *parent = nullptr);
};

/*!
 * \qmltype IconGroup
 * \inqmlmodule org.kde.kirigamiaddons.actions
 * \brief Grouped icon properties for ActionData.
 *
 * \since 1.14.0
 */
/*!
 * \class IconGroup
 * \inmodule KirigamiAddonsActions
 * \internal Backing type for ActionData's grouped icon properties.
 */
class IconGroup : public QObject
{
    Q_OBJECT
    QML_ANONYMOUS
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(qreal width READ width WRITE setWidth NOTIFY widthChanged)
    Q_PROPERTY(qreal height READ height WRITE setHeight NOTIFY heightChanged)
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(bool cache READ cache WRITE setCache NOTIFY cacheChanged)
public:
    explicit IconGroup(ActionData *parent = nullptr);
    ~IconGroup() override;
    QString name() const;
    void setName(const QString &name);
    QString source() const;
    void setSource(const QString &source);
    qreal width() const;
    void setWidth(qreal width);
    qreal height() const;
    void setHeight(qreal height);
    QColor color() const;
    void setColor(const QColor &color);
    bool cache() const;
    void setCache(bool cache);
Q_SIGNALS:
    void nameChanged();
    void sourceChanged();
    void widthChanged();
    void heightChanged();
    void colorChanged();
    void cacheChanged();
private:
    std::unique_ptr<IconGroupPrivate> d;
};

/*! 
 * \qmltype ActionData
 * \inqmlmodule org.kde.kirigamiaddons.actions
 * \nativetype QAction
 * \brief A declarative action with a configurable shortcut.
 *
 * This element needs to always be declared as a child of ActionCollection.
 * It is the declarative representation of a named action within the application
 * with a user-configurable shortcut.
 *
 * This element can be assigned to one or more ActionContext objects through
 * the \c contexts property. An inactive context disables and hides the action
 * by default. When multiple contexts are active, activeContext refers to the
 * active context with the highest priority.
 *
 * \qml
 * KirigamiActions.ActionContext {
 *     id: documentContext
 *     active: pageStack.currentItem === editorPage
 * }
 * KirigamiActions.ActionData {
 *     name: "save"
 *     contexts: documentContext
 * }
 * \endqml
 *
 * The regular QAction properties, such as text, toolTip, enabled, checkable and
 * checked, can be assigned directly in QML. Its name must be unique within
 * the containing collection.
 *
 * The action is registered with the AbstractKirigamiApplication when its
 * collection is complete. It is therefore available to the command bar and
 * its shortcut can be configured by the user in the standard shortcut editor.
 *
 * \code
 * import org.kde.kirigamiaddons.actions as KirigamiActions
 *
 * KirigamiActions.StatefulWindow {
 *     id: root
 *     application: MyApplication {}
 *
 *     KirigamiActions.ActionCollection {
 *         application: root.application
 *         name: "document"
 *         text: i18n("Document Actions")
 *
 *         KirigamiActions.ActionData {
 *             name: "document_save"
 *             text: i18n("Save")
 *             toolTip: i18n("Save the current document")
 *             icon.name: "document-save"
 *             defaultShortcut: "Ctrl+S"
 *             onTriggered: document.save()
 *         }
 *     }
 * }
 * \endcode
 *
 * \sa ActionCollection
 * \sa StandardActionData
 *
 * \since 1.14.0
 */
/*!
 * \class ActionData
 * \inmodule KirigamiAddonsActions
 * \internal Not exposed to C++; use the ActionData QML type.
 */
class ActionData : public QAction, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    QML_ELEMENT
    /*! \qmlproperty string ActionData::name
     * The unique name of the action within its collection.
     * It should be set only once.
     *
     * \since 1.14.0
     */
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged FINAL)
    /*! Description for the icon to use, which can be specified by name or path.
     *
     * \qmlproperty string ActionData::icon.name
     * \qmlproperty string ActionData::icon.source
     * \qmlproperty real ActionData::icon.width
     * \qmlproperty real ActionData::icon.height
     * \qmlproperty color ActionData::icon.color
     * \qmlproperty bool ActionData::icon.cache
     *
     * \since 1.14.0
     */
    Q_PROPERTY(IconGroup *icon READ icon CONSTANT FINAL)
    /*! \qmlproperty ActionGroup ActionData::actionGroup
     * The optional group used to make related actions mutually exclusive.
     *
     * Set \c checkable to true on the grouped actions. The group can be
     * declared as a sibling of the actions in an ActionCollection.
     *
     * \qml
     * KirigamiActions.ActionGroup {
     *     id: modes
     *     exclusive: true
     * }
     * KirigamiActions.ActionData {
     *     name: "mode_one"
     *     checkable: true
     *     actionGroup: modes
     * }
     * \endqml
     *
     * \since 1.14.0
     */
    Q_PROPERTY(QActionGroup *actionGroup READ actionGroup WRITE setActionGroup NOTIFY actionGroupChanged FINAL)
    /*! \qmlproperty QtQuick.Controls::Action ActionData::action
     * This property holds the QML Action this ActionData is associated to, if any.
     * Since ActionData is just a description of an action, in order to be an active
     * working action it has to be associated with a QML Action instance, preferably
     * a Kirigami.Action specialization.
     *
     * It can be associated either here by binding this property to the id of an
     * Action instance or from the Action instance using the ActionCollection attached
     * property.
     *
     * Direct example:
     *
     * \code
     * KirigamiActions.ActionCollection {
     *     application: root.application
     *     KirigamiActions.ActionData {
     *         name: "copy"
     *         icon.name: "edit-copy"
     *         text: i18n("Copy")
     *         action: copyAction
     *     }
     * }
     *
     * Kirigami.Action {
     *     id: copyAction
     *     onTriggered: document.copy()
     * }
     * \endcode
     *
     * Attached property example:
     *
     * \code
     * KirigamiActions.ActionCollection {
     *     application: root.application
     *     name: "EditActions"
     *     KirigamiActions.ActionData {
     *         name: "copy"
     *         icon.name: "edit-copy"
     *         text: i18n("Copy")
     *     }
     * }
     *
     * Kirigami.Action {
     *     KirigamiActions.ActionCollection.collection: "EditActions"
     *     KirigamiActions.ActionCollection.action: "copy"
     *     onTriggered: document.copy()
     * }
     * \endcode
     *
     * \since 1.14.0
     */
    Q_PROPERTY(QObject *action READ action WRITE setAction NOTIFY actionChanged FINAL)
    /*! \qmlproperty list<ActionContext> ActionData::contexts
     * The contexts that control this action.
     *
     * \since 1.14.0
     */
    Q_PROPERTY(QQmlListProperty<ActionContext> contexts READ contexts FINAL)
    /*! \qmlproperty bool ActionData::contextActive
     * Whether at least one of this action's contexts is active.
     *
     * \since 1.14.0
     */
    Q_PROPERTY(bool contextActive READ contextActive NOTIFY contextActiveChanged FINAL)
    /*! \qmlproperty ActionContext ActionData::activeContext
     * The highest-priority active context, or null when no context is active.
     *
     * \since 1.14.0
     */
    Q_PROPERTY(ActionContext *activeContext READ activeContext NOTIFY activeContextChanged FINAL)
    /*! \qmlproperty bool ActionData::contextEnabled
     * Whether an inactive context disables this action. Defaults to true.
     *
     * \since 1.14.0
     */
    Q_PROPERTY(bool contextEnabled READ contextEnabled WRITE setContextEnabled NOTIFY contextEnabledChanged FINAL)
    /*! \qmlproperty bool ActionData::contextVisible
     * Whether an inactive context hides this action. Defaults to true.
     *
     * \since 1.14.0
     */
    Q_PROPERTY(bool contextVisible READ contextVisible WRITE setContextVisible NOTIFY contextVisibleChanged FINAL)
    /*! \qmlproperty keysequence ActionData::defaultAlternateShortcut
     * The alternate shortcut assigned when no user-configured shortcut exists.
     *
     * \since 1.14.0
     */
    Q_PROPERTY(QVariant defaultAlternateShortcut READ defaultAlternateShortcut WRITE setDefaultAlternateShortcut NOTIFY defaultAlternateShortcutChanged FINAL)
    /*! \qmlproperty var ActionData::data
     * Additional data associated with the action.
     *
     * \since 1.14.0
     */
    Q_PROPERTY(QVariant data READ data WRITE setData NOTIFY changed FINAL)
    /*! \qmlproperty keysequence ActionData::defaultShortcut
     * The shortcut assigned when no user-configured shortcut exists.
     *
     * The value can be a string containing one or more key presses, such as
     * \c{"Ctrl+E,Ctrl+W"}, or a Qt standard key sequence. The user's
     * configured shortcut takes precedence over this value.
     *
     * \qml
     * ActionData {
     *     name: "close_document"
     *     defaultShortcut: "Ctrl+W"
     * }
     * \endqml
     *
     * \since 1.14.0
     */
    Q_PROPERTY(QVariant defaultShortcut READ defaultShortcut WRITE setDefaultShortcut NOTIFY defaultShortcutChanged FINAL)

public:
    explicit ActionData(QObject *parent = nullptr);
    QString name() const;
    void setName(const QString &name);
    IconGroup *icon() const;
    QActionGroup *actionGroup() const;
    void setActionGroup(QActionGroup *group);
    QObject *action() const;
    void setAction(QObject *action);
    QQmlListProperty<ActionContext> contexts();
    bool contextActive() const;
    ActionContext *activeContext() const;
    bool contextEnabled() const;
    void setContextEnabled(bool enabled);
    bool contextVisible() const;
    void setContextVisible(bool visible);
    void addActionInstance(QObject *action);
    void removeActionInstance(QObject *action);
    QVariant defaultShortcut() const;
    void setDefaultShortcut(const QVariant &shortcut);
    QVariant defaultAlternateShortcut() const;
    void setDefaultAlternateShortcut(const QVariant &shortcut);
    void classBegin() override;
    void componentComplete() override;

Q_SIGNALS:
    void nameChanged();
    void defaultShortcutChanged();
    void defaultAlternateShortcutChanged();
    void actionGroupChanged();
    void actionChanged();
    void contextActiveChanged();
    void activeContextChanged();
    void contextEnabledChanged();
    void contextVisibleChanged();

private Q_SLOTS:
    void syncPrimaryAction();
    void forwardTriggered();
    void updateContextState();

private:
    static void appendContext(QQmlListProperty<ActionContext> *property, ActionContext *context);
    static qsizetype contextCount(QQmlListProperty<ActionContext> *property);
    static ActionContext *contextAt(QQmlListProperty<ActionContext> *property, qsizetype index);
    static void clearContexts(QQmlListProperty<ActionContext> *property);
    void addContext(ActionContext *context);
    void clearContextList();
    void syncAction();
    QString m_name;
    QVariant m_defaultShortcut;
    IconGroup *m_icon;
    QActionGroup *m_actionGroup = nullptr;
    QList<QPointer<QObject>> m_actionInstances;
    QPointer<QObject> m_primaryAction;
    QList<QPointer<ActionContext>> m_contexts;
    QList<QMetaObject::Connection> m_contextConnections;
    QVariant m_defaultAlternateShortcut;
    bool m_forwardingTrigger = false;
    bool m_contextStateUpdating = false;
    bool m_baseEnabled = true;
    bool m_baseVisible = true;
    bool m_contextEnabled = true;
    bool m_contextVisible = true;
    bool m_effectiveContextActive = true;
    QPointer<ActionContext> m_effectiveActiveContext;

    friend class IconGroup;
};
