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
 * \qmltype ActionMenuData
 * \inqmlmodule org.kde.kirigamiaddons.actions
 * \brief A presentation-independent declarative menu.
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
    Q_PROPERTY(QStringList actions READ actions WRITE setActions NOTIFY actionsChanged FINAL)
    Q_PROPERTY(QQmlListProperty<QObject> items READ items FINAL)
    Q_PROPERTY(KirigamiActionCollection *collection READ collection CONSTANT FINAL)
    Q_PROPERTY(QQmlListProperty<ActionMenu> menus READ menus CONSTANT FINAL)
    Q_PROPERTY(QStringList mergedActions READ mergedActions NOTIFY mergedActionsChanged FINAL)
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
    QStringList actions() const;
    void setActions(const QStringList &actions);
    QQmlListProperty<QObject> items();
    KirigamiActionCollection *collection() const;
    Q_INVOKABLE QObject *resolveAction(const QString &name) const;
    Q_INVOKABLE QObject *resolveMergedAction(const QString &name) const;
    QQmlListProperty<ActionMenu> menus();
    QStringList mergedActions() const;
    QVariantList mergedItems() const;
    QVariantList mergedMenus() const;

    void classBegin() override;
    void componentComplete() override;

    static const QList<ActionMenu *> &allMenus();

Q_SIGNALS:
    void nameChanged();
    void textChanged();
    void iconNameChanged();
    void actionsChanged();
    void mergedItemsChanged();
    void mergedActionsChanged();
    void mergedMenusChanged();

private:
    void setCollection(KirigamiActionCollection *collection);
    QStringList menuPath() const;

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
