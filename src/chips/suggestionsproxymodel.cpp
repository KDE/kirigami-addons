/*
 * SPDX-FileCopyrightText: 2026 Kai Uwe Broulik <kde@broulik.de>
 *
 * SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL
 */

#include "suggestionsproxymodel.h"

#include "chipgroup.h"
#include "chipobject.h"
#include "chipsmodel.h"

using namespace Qt::StringLiterals;

SuggestionsProxyModel::SuggestionsProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{
}

SuggestionsProxyModel::~SuggestionsProxyModel() = default;

ChipGroup *SuggestionsProxyModel::group() const
{
    return m_group;
}

void SuggestionsProxyModel::setGroup(ChipGroup *group)
{
    if (m_group == group) {
        return;
    }

    beginFilterChange();
    m_group = group;
    Q_EMIT groupChanged(group);
    endFilterChange(Direction::Rows);
}

QString SuggestionsProxyModel::query() const
{
    return m_query;
}

void SuggestionsProxyModel::setQuery(const QString &query)
{
    if (m_query == query) {
        return;
    }

    beginFilterChange();
    m_query = query;
    Q_EMIT queryChanged(query);
    endFilterChange(Direction::Rows);
}

bool SuggestionsProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    if (!m_group && m_query.isEmpty()) {
        return false;
    }

    const QModelIndex sourceIndex = sourceModel()->index(sourceRow, 0, sourceParent);
    auto *chip = sourceIndex.data(ChipsModel::ChipRole).value<ChipObject *>();
    auto *group = ChipGroup::groupForChip(chip);

    if (!m_query.isEmpty()) {
        // TODO this also looks up the group...
        const QString display = sourceIndex.data(Qt::DisplayRole).toString();
        if (display.startsWith(m_query, Qt::CaseInsensitive)) {
            return true;
        }

        if (chip->label().startsWith(m_query, Qt::CaseInsensitive)) {
            return true;
        }

        QString prefix;
        if (group) {
            prefix = group->prefix();
        }

        // TODO value only if it is a string or something?
        QString stringValue = chip->value().toString();
        if (prefix.isEmpty()) {
            return stringValue.startsWith(m_query);
        } else {
            // TODO optimize
            const QString valueWithPrefix = prefix + stringValue;
            if (valueWithPrefix.startsWith(m_query, Qt::CaseInsensitive)) {
                return true;
            }

            // A bit weird maybe?
            const QString labelWithPrefix = prefix + chip->label();
            if (labelWithPrefix.startsWith(m_query, Qt::CaseInsensitive)) {
                return true;
            }
        }
    }

    return !m_group || m_group == group;
}

#include "moc_suggestionsproxymodel.cpp"
