// SPDX-FileCopyrightText: 2024 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "shortcutsmodel_p.h"

#include <QAction>
#include <unordered_set>

ShortcutsModel::ShortcutsModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int ShortcutsModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_items.count();
}

QVariant ShortcutsModel::data(const QModelIndex &index, int role) const
{
    Q_ASSERT(checkIndex(index, QAbstractItemModel::CheckIndexOption::IndexIsValid));

    const auto &item = m_items[index.row()];

    switch (role) {
    case Qt::DisplayRole:
        return item.action->text();
    case IconNameRole:
        return item.action->icon().name();
    case ShortcutRole:
        return item.action->shortcut().toString(QKeySequence::NativeText);
    case DefaultShortcutRole:
        return item.action->shortcut().toString(QKeySequence::NativeText);
    case AlternateShortcutRole:
        if (item.action->shortcuts().size() <= 1) {
            return {};
        } else {
            return item.action->shortcuts().at(1).toString(QKeySequence::NativeText);
        }
    default:
        return {};
    }
}

QHash<int, QByteArray> ShortcutsModel::roleNames() const
{
    return {
        { Qt::DisplayRole, "actionName" },
        { IconNameRole, "iconName" },
        { DefaultShortcutRole, "defaultShortcut" },
        { ShortcutRole, "shortcut" },
        { AlternateShortcutRole, "alternateShortcut" },
        { CollectionNameRole, "collectionName" },
    };
}

void ShortcutsModel::refresh(const QList<KalCommandBarModel::ActionGroup> &actionGroups)
{
    int totalActions = std::accumulate(actionGroups.begin(), actionGroups.end(), 0, [](int a, const KalCommandBarModel::ActionGroup &ag) {
        return a + ag.actions.count();
    });

    QList<Item> temp_rows;
    std::unordered_set<QAction *> uniqueActions;
    temp_rows.reserve(totalActions);
    int actionGroupIdx = 0;
    for (const auto &ag : actionGroups) {
        for (const auto &action : std::as_const(ag.actions)) {
            // We don't want disabled actions
            if (uniqueActions.insert(action).second) {
                temp_rows.push_back(ShortcutsModel::Item{ag.name, action});
            }
        }

        actionGroupIdx++;
    }

    beginResetModel();
    m_items = std::move(temp_rows);
    endResetModel();
}
