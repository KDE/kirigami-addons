// SPDX-FileCopyrightText: 2021 Waqar Ahmed <waqar.17a@gmail.com>
// SPDX-License-Identifier: LGPL-2.0-or-later

#include "actionsmodel_p.h"

#include <KLocalizedString>

#include <QAction>

#include <unordered_set>

KCommandBarModel::KCommandBarModel(QObject *parent)
    : QAbstractTableModel(parent)
{
}

void fillRows(QList<KCommandBarModel::Item> &rows, const QString &title, const QList<QAction *> &actions, std::unordered_set<QAction *> &uniqueActions)
{
    for (const auto &action : actions) {
        // We don't want disabled actions
        if (!action->isEnabled()) {
            continue;
        }

        if (uniqueActions.insert(action).second) {
            rows.push_back(KCommandBarModel::Item{title, action, -1});
        }
    }
}

void KCommandBarModel::refresh(const QList<ActionGroup> &actionGroups)
{
    QSet<QString> groupNames;
    int totalActions = std::accumulate(actionGroups.begin(), actionGroups.end(), 0, [&groupNames](int a, const ActionGroup &ag) {
        groupNames << ag.name;
        return ag.actions.count() + a;
    });
    m_hasMultipleGroup = groupNames.count() > 1;

    QList<Item> temp_rows;
    std::unordered_set<QAction *> uniqueActions;
    temp_rows.reserve(totalActions);
    for (const auto &ag : actionGroups) {
        const auto &agActions = ag.actions;
        fillRows(temp_rows, ag.name, agActions, uniqueActions);
    }

    /**
     * For each action in last triggered actions,
     *  - Find it in the actions
     *  - Use the score variable to set its score
     *
     * Items in m_lastTriggered are stored in descending order
     * by their usage i.e., the first item in the vector is the most
     * recently invoked action.
     *
     * Here we traverse them in reverse order, i.e., from least recent to
     * most recent and then assign a score to them in a way that most recent
     * ends up having the highest score. Thus when proxy model does the sorting
     * later, most recent item will end up on the top
     */
    int score = 0;
    std::for_each(m_lastTriggered.crbegin(), m_lastTriggered.crend(), [&score, &temp_rows](const QString &act) {
        auto it = std::find_if(temp_rows.begin(), temp_rows.end(), [act](const KCommandBarModel::Item &i) {
            return i.action->text() == act;
        });
        if (it != temp_rows.end()) {
            it->score = score++;
        }
    });

    beginResetModel();
    m_rows = std::move(temp_rows);
    endResetModel();
}

QVariant KCommandBarModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) {
        return {};
    }

    const auto &entry = m_rows[index.row()];
    const int col = index.column();

    switch (role) {
    case Qt::DisplayRole:
    case DisplayNameRole:
        if (col == 0) {
            QString actionText = KLocalizedString::removeAcceleratorMarker(entry.action->text());
            if (m_hasMultipleGroup) {
                const QString groupName = KLocalizedString::removeAcceleratorMarker(entry.groupName);
                return QString(groupName + QStringLiteral(": ") + actionText);
            } else {
                return actionText;
            }
        } else {
            return entry.action->shortcut().toString(QKeySequence::NativeText);
        }
    case ShortcutRole:
        return entry.action->shortcut().toString(QKeySequence::NativeText);
    case Qt::DecorationRole:
        if (col == 0) {
            return entry.action->icon().name();
        }
        break;
    case Qt::TextAlignmentRole:
        if (col == 0) {
            return Qt::AlignLeft;
        } else {
            return Qt::AlignRight;
        }
    case Qt::UserRole: {
        return QVariant::fromValue(entry.action);
    }
    case Role::Score:
        return entry.score;
    }

    return {};
}

void KCommandBarModel::actionTriggered(const QString &name)
{
    if (m_lastTriggered.size() == 6) {
        m_lastTriggered.pop_back();
    }
    m_lastTriggered.push_front(name);
}

QStringList KCommandBarModel::lastUsedActions() const
{
    return m_lastTriggered;
}

void KCommandBarModel::setLastUsedActions(const QStringList &actionNames)
{
    m_lastTriggered = actionNames;

    while (m_lastTriggered.size() > 6) {
        m_lastTriggered.pop_back();
    }
}

QHash<int, QByteArray> KCommandBarModel::roleNames() const
{
    auto roles = QAbstractTableModel::roleNames();
    roles[Qt::UserRole] = QByteArrayLiteral("qaction");
    roles[Score] = QByteArrayLiteral("score");
    roles[ShortcutRole] = QByteArrayLiteral("shortcut");
    roles[DisplayNameRole] = QByteArrayLiteral("displayName");
    return roles;
}

#include "moc_actionsmodel_p.cpp"
