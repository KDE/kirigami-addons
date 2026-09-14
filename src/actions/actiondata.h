// SPDX-FileCopyrightText: 2025 Marco Martin <notmart@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QAction>
#include <QActionGroup>
#include <QColor>
#include <QPointer>
#include <QQmlParserStatus>
#include <QtQml/qqml.h>
#include <qqmlregistration.h>

#include <memory>

class KirigamiActionCollection;
class ActionData;
class IconGroupPrivate;

/*!
 * \qmltype ActionDataGroup
 * \inqmlmodule org.kde.kirigamiaddons.actions
 * \brief A group of ActionData objects with automatic exclusivity.
 */
class ActionDataGroup : public QActionGroup
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit ActionDataGroup(QObject *parent = nullptr);
};

/*!
 * \qmltype IconGroup
 * \inqmlmodule org.kde.kirigamiaddons.actions
 * \brief Grouped icon properties for ActionData.
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
 * StatefulApp.StatefulWindow {
 *     id: root
 *     application: MyApplication {}
 *
 *     StatefulApp.ActionCollection {
 *         application: root.application
 *         name: "document"
 *         text: i18n("Document Actions")
 *
 *         StatefulApp.ActionData {
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
 */
class ActionData : public QAction, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    QML_ELEMENT
    /*! \qmlproperty string ActionData::name
     * The unique name of the action within its collection.
     * It should be set only once.
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
     */
    Q_PROPERTY(IconGroup *icon READ icon CONSTANT FINAL)
    /*! \qmlproperty ActionDataGroup ActionData::actionGroup
     * The optional group used to make related actions mutually exclusive.
     *
     * Set \c checkable to true on the grouped actions. The group can be
     * declared as a sibling of the actions in an ActionCollection.
     *
     * \qml
     * StatefulApp.ActionDataGroup {
     *     id: modes
     *     exclusive: true
     * }
     * StatefulApp.ActionData {
     *     name: "mode_one"
     *     checkable: true
     *     actionGroup: modes
     * }
     * \endqml
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
     * StatefulApp.ActionCollection {
     *     application: root.application
     *     StatefulApp.ActionData {
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
     * StatefulApp.ActionCollection {
     *     application: root.application
     *     name: "EditActions"
     *     StatefulApp.ActionData {
     *         name: "copy"
     *         icon.name: "edit-copy"
     *         text: i18n("Copy")
     *     }
     * }
     *
     * Kirigami.Action {
     *     StatefulApp.ActionCollection.collection: "EditActions"
     *     StatefulApp.ActionCollection.action: "copy"
     *     onTriggered: document.copy()
     * }
     * \endcode
     */
    Q_PROPERTY(QObject *action READ action WRITE setAction NOTIFY actionChanged FINAL)
    Q_PROPERTY(QVariant defaultAlternateShortcut READ defaultAlternateShortcut WRITE setDefaultAlternateShortcut NOTIFY defaultAlternateShortcutChanged FINAL)
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

private Q_SLOTS:
    void syncPrimaryAction();
    void forwardTriggered();

private:
    void syncAction();
    QString m_name;
    QVariant m_defaultShortcut;
    IconGroup *m_icon;
    QActionGroup *m_actionGroup = nullptr;
    QList<QPointer<QObject>> m_actionInstances;
    QPointer<QObject> m_primaryAction;
    QVariant m_defaultAlternateShortcut;
    bool m_forwardingTrigger = false;

    friend class IconGroup;
};
