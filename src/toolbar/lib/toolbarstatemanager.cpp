// SPDX-FileCopyrightText: 2022 Tobias Fella <fella@posteo.de>
// SPDX-License-Identifier: LGPL-2.0-or-later

#include "toolbarstatemanager.h"
#include <QDebug>
#include <QMetaProperty>
#include <QJsonObject>
#include <private/qquickicon_p.h>
#include <KConfig>
#include <KConfigGroup>

ToolBarStateManager::ToolBarStateManager(QObject *parent)
    : QAbstractListModel(parent)
{
    connect(this, &ToolBarStateManager::defaultLayoutChanged, this, [=](){
        init();
    });
    connect(this, &ToolBarStateManager::actionsChanged, this, [=](){
        init();
    });
}

void ToolBarStateManager::init()
{
    if (m_defaultLayout.isEmpty() || m_actions.count() == 0) {
        return;
    }
    KConfig config(QStringLiteral("toolbar-foo"));
    KConfigGroup actions(&config, "actions");
    if (actions.exists()) {
        for (const auto &group : actions.groupList()) {
            KConfigGroup entry(&actions, group);
            QString objectName = entry.readEntry("objectName", QString());
            int i = 0;
            for (; i < m_actions.count(); i++) {
                if (m_actions.at(i)->property("objectName") == objectName) {
                    break;
                }
            }
            m_items += ToolBarItem {
                objectName,
                m_actions.at(i)->property("text").toString(),
                qvariant_cast<QQuickIcon>(m_actions.at(i)->property("icon")).name(),
                0,
                i,
            };
        }
        return;
    }
    beginResetModel();
    for (const auto &item : m_defaultLayout) {
        int i = 0;
        for (; i < m_actions.count(); i++) {
            if (m_actions.at(i)->property("objectName") == item) {
                break;
            }
        }
        m_items += ToolBarItem {
            m_actions.at(i)->property("objectName").toString(),
            m_actions.at(i)->property("text").toString(),
            qvariant_cast<QQuickIcon>(m_actions.at(i)->property("icon")).name(),
            0,
            i,
        };
    }
    endResetModel();
}

QQmlListReference ToolBarStateManager::actions() const
{
    return m_actions;
}

void ToolBarStateManager::setActions(const QQmlListReference &actions)
{
    m_actions = actions;
    Q_EMIT actionsChanged();
}

void ToolBarStateManager::setDefaultLayout(const QStringList &defaultLayout)
{
    m_defaultLayout = defaultLayout;
    Q_EMIT defaultLayoutChanged();
}

QStringList ToolBarStateManager::defaultLayout() const
{
    return {};
}

int ToolBarStateManager::rowCount(const QModelIndex &parent) const
{
    return m_items.count();
}

QVariant ToolBarStateManager::data(const QModelIndex &index, int roleName) const
{
    switch (roleName) {
    case Text: {
        return m_items[index.row()].text;
    }
    case Icon: {
        return m_items[index.row()].icon;
    }
    case DisplayStyle: {
        return m_items[index.row()].display;
    }
    case IndexInAll: {
        return m_items[index.row()].index;
    }
    }
    return {};
}

QHash<int, QByteArray> ToolBarStateManager::roleNames() const
{
    return {
        {Text, "text"},
        {Icon, "icon"},
        {DisplayStyle, "display"},
        {IndexInAll, "indexInAll"},
    };
}

void ToolBarStateManager::removeItem(int index)
{
    beginRemoveRows(QModelIndex(), index, index);
    m_items.removeAt(index);
    endRemoveRows();
    KConfig config(QStringLiteral("toolbar-foo")); //TODO toolbar name;
    config.deleteGroup("actions");
    KConfigGroup actions(&config, "actions");
    for (const auto &item : m_items) {
        KConfigGroup itemGroup(&actions, item.objectName);
        itemGroup.writeEntry("objectName", item.objectName);
        itemGroup.sync();
    };

}
