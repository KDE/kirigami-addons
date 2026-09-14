// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QObject>
#include <QQmlListProperty>
#include <QQmlParserStatus>
#include <QStringList>
#include <QVariantList>
#include <qqmlregistration.h>
#include <memory>

#include "kirigamiaddonsstatefulapp_export.h"
#include "kirigamiactioncollection.h"


/**
 * \internal
 * \brief Internal backing type for the declarative ActionMenu QML component.
 * \inqmlmodule org.kde.kirigamiaddons.actions
 *
 * Action names are resolved by the containing ActionCollection. Menus with
 * the same name contribute to the same logical menu when used by a menu
 * presentation.
 */
class KIRIGAMIADDONSSTATEFULAPP_EXPORT ActionMenu : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    QML_NAMED_ELEMENT(ActionMenuData)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged FINAL)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged FINAL)
    Q_PROPERTY(QString iconName READ iconName WRITE setIconName NOTIFY iconNameChanged FINAL)
    Q_PROPERTY(bool menuBarVisible READ menuBarVisible WRITE setMenuBarVisible NOTIFY menuBarVisibleChanged FINAL)
    Q_PROPERTY(QStringList actions READ actions WRITE setActions NOTIFY actionsChanged FINAL)
    Q_PROPERTY(QQmlListProperty<QObject> items READ items NOTIFY itemsChanged FINAL)
    Q_PROPERTY(KirigamiActionCollection *collection READ collection NOTIFY collectionChanged FINAL)
    Q_PROPERTY(QQmlListProperty<ActionMenu> menus READ menus NOTIFY menusChanged FINAL)
    Q_PROPERTY(QStringList mergedActions READ mergedActions NOTIFY mergedActionsChanged FINAL)
    /*! \qmlproperty list<var> ActionMenu::mergedItems
     * The merged ordered items. Action entries contain \c type, \c name, and
     * the resolved \c action object; separator entries contain only \c type.
     */
    Q_PROPERTY(QVariantList mergedItems READ mergedItems NOTIFY mergedItemsChanged FINAL)
    Q_PROPERTY(QVariantList mergedMenus READ mergedMenus NOTIFY mergedMenusChanged FINAL)

public:
    explicit ActionMenu(QObject *parent = nullptr);
    ~ActionMenu() override;

    QString name() const;
    void setName(const QString &name);
    QString text() const;
    void setText(const QString &text);
    QString iconName() const;
    void setIconName(const QString &iconName);
    bool menuBarVisible() const;
    void setMenuBarVisible(bool visible);
    QStringList actions() const;
    void setActions(const QStringList &actions);
    QQmlListProperty<QObject> items();
    KirigamiActionCollection *collection() const;
    /*! \internal Resolves an action for the menu implementation. */
    Q_INVOKABLE QObject *resolveAction(const QString &name) const;
    QQmlListProperty<ActionMenu> menus();
    QStringList mergedActions() const;
    QVariantList mergedItems() const;
    QVariantList mergedMenus() const;

    void classBegin() override;
    void componentComplete() override;

Q_SIGNALS:
    void nameChanged();
    void textChanged();
    void iconNameChanged();
    void menuBarVisibleChanged();
    void actionsChanged();
    void itemsChanged();
    void collectionChanged();
    void menusChanged();
    void mergedItemsChanged();
    void mergedActionsChanged();
    void mergedMenusChanged();

private:
    void setCollection(KirigamiActionCollection *collection);
    void notifyMergedChanges();
    QStringList menuPath() const;
    QList<ActionMenu *> contributingMenus() const;

    static void appendMenu(QQmlListProperty<ActionMenu> *property, ActionMenu *menu);
    static qsizetype menuCount(QQmlListProperty<ActionMenu> *property);
    static ActionMenu *menuAt(QQmlListProperty<ActionMenu> *property, qsizetype index);
    static void clearMenus(QQmlListProperty<ActionMenu> *property);
    static void appendItem(QQmlListProperty<QObject> *property, QObject *item);
    static qsizetype itemCount(QQmlListProperty<QObject> *property);
    static QObject *itemAt(QQmlListProperty<QObject> *property, qsizetype index);
    static void clearItems(QQmlListProperty<QObject> *property);

    class Private;
    std::unique_ptr<Private> d;

    friend class KirigamiActionCollection;
};
