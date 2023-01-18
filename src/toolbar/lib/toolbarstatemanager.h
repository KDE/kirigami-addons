// SPDX-FileCopyrightText: 2022 Tobias Fella <fella@posteo.de>
// SPDX-License-Identifier: LGPL-2.0-or-later

#include <QObject>
#include <QList>
#include <QQmlListReference>
#include <QAbstractListModel>

class QQuickIcon;

class ToolBarStateManager : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QQmlListReference actions READ actions WRITE setActions NOTIFY actionsChanged)
    Q_PROPERTY(QStringList defaultLayout READ defaultLayout WRITE setDefaultLayout NOTIFY defaultLayoutChanged)

public:
    enum Roles {
        Text,
        Icon,
        DisplayStyle,
        IndexInAll,
    };
    Q_ENUM(Roles);

    struct ToolBarItem {
        QString objectName;
        QString text;
        QString icon;
        int display;
        int index;
    };

    ToolBarStateManager(QObject *parent = nullptr);

    QQmlListReference actions() const;
    void setActions(const QQmlListReference &actions);

    QStringList defaultLayout() const;
    void setDefaultLayout(const QStringList &defaultLayout);

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int roleName) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void removeItem(int index);

Q_SIGNALS:
    void actionsChanged();
    void defaultLayoutChanged();

private:
    QQmlListReference m_actions;
    QStringList m_defaultLayout;

    QList<ToolBarItem> m_items;
    void init();
};
