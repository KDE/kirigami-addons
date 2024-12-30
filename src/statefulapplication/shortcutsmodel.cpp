// SPDX-FileCopyrightText: 2024 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "shortcutsmodel_p.h"

#include <QAction>
#include <unordered_set>
#include <KLocalizedString>
#include <KConfigGroup>
#include "kirigamiactioncollection.h"

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
        return item.action->shortcut();
    case ShortcutDisplayRole: {
        QStringList displayText;
        const auto shortcuts = item.action->shortcuts();
        for (const auto &shortcut : shortcuts) {
             displayText << shortcut.toString(QKeySequence::NativeText);
        }
        return displayText.join(i18nc("List separator", ", "));
    }
    case DefaultShortcutRole:
        return item.action->shortcut().toString(QKeySequence::NativeText);
    case AlternateShortcutsRole:
        if (item.action->shortcuts().size() <= 1) {
            return {};
        } else {
            return QVariant::fromValue(item.action->shortcuts().mid(1));
        }
    case CollectionNameRole:
        return item.collection->componentDisplayName();
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
        { ShortcutDisplayRole, "shortcutDisplay" },
        { AlternateShortcutsRole, "alternateShortcuts" },
        { CollectionNameRole, "collectionName" },
    };
}

void ShortcutsModel::refresh(const QList<KirigamiActionCollection *> &actionCollections)
{
    m_collections = actionCollections;
    int totalActions = std::accumulate(actionCollections.begin(), actionCollections.end(), 0, [](int a, KirigamiActionCollection *collection) {
        return a + collection->actions().count();
    });

    QList<Item> temp_rows;
    std::unordered_set<QAction *> uniqueActions;
    temp_rows.reserve(totalActions);
    for (const auto &collection : actionCollections) {
        for (const auto action : collection->actions()) {
            if (collection->isShortcutsConfigurable(action)) {
                temp_rows.push_back(ShortcutsModel::Item{collection, action});
            }
        }
    }

    beginResetModel();
    m_items = std::move(temp_rows);
    endResetModel();
}

QList<QKeySequence> ShortcutsModel::updateShortcut(int row, int shortcutIndex, const QKeySequence &keySequence)
{
    Q_ASSERT(row >= 0 && row < rowCount());

    const auto &item = m_items[row];
    auto oldShortcuts = item.action->shortcuts();
    if (keySequence.isEmpty()) {
        if (shortcutIndex != oldShortcuts.count()) {
            oldShortcuts.remove(shortcutIndex);
        }
    } else {
        if (shortcutIndex == oldShortcuts.count()) {
            oldShortcuts << keySequence;
        } else {
            oldShortcuts[shortcutIndex] = keySequence;
        }
    }

    item.action->setShortcuts(oldShortcuts);

    Q_EMIT dataChanged(index(row), index(row));

    if (item.action->shortcuts().size() <= 1) {
        return {};
    } else {
        return item.action->shortcuts().mid(1);
    }
}

void ShortcutsModel::resetAll()
{
    for (int i = 0, count = rowCount(); i < count; i++) {
        reset(i);
    }
}

void ShortcutsModel::save()
{
    for (const auto *collection : std::as_const(m_collections)) {
        collection->writeSettings(nullptr); // Use default location
    }
}

QList<QKeySequence> ShortcutsModel::reset(int row)
{
    Q_ASSERT(row >= 0 && row < rowCount());

    const auto &item = m_items[row];

    const QList<QKeySequence> defaultShortcuts = item.action->property("defaultShortcuts").value<QList<QKeySequence>>();

    if (item.action->shortcuts() != defaultShortcuts) {
        item.action->setShortcuts(defaultShortcuts);
    }

    Q_EMIT dataChanged(index(row), index(row));

    if (item.action->shortcuts().size() <= 1) {
        return {};
    } else {
        return item.action->shortcuts().mid(1);
    }
}
QKeySequence ShortcutsModel::emptyKeySequence() const
{
    return {};
}
