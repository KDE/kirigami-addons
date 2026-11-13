/*
 * SPDX-FileCopyrightText: 2026 Kai Uwe Broulik <kde@broulik.de>
 *
 * SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL
 */

#include "chipsmodel.h"

#include "chipgroup.h"

using namespace Qt::StringLiterals;

ChipsModel::ChipsModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

ChipsModel::~ChipsModel() = default;

void ChipsModel::append(ChipObject *chip)
{
    beginInsertRows({}, m_chips.size(), m_chips.size());
    m_chips.append(chip);
    endInsertRows();
}

ChipObject *ChipsModel::chipAt(int row) const
{
    // TODO sanity check?
    return m_chips.at(row);
}

bool ChipsModel::contains(ChipObject *chip) const
{
    return m_chips.contains(chip);
}

void ChipsModel::clear()
{
    beginResetModel();
    m_chips.clear();
    endResetModel();
}

int ChipsModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_chips.size();
}

QVariant ChipsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_chips.size()) {
        return {};
    }

    auto *chip = m_chips.at(index.row());

    switch (role) {
    case Qt::DisplayRole:
        return ChipObject::displayText(chip);
    case ChipRole:
        return QVariant::fromValue(chip);
    }

    return {};
}

QHash<int, QByteArray> ChipsModel::roleNames() const
{
    return {
        {Qt::DisplayRole, "text"_ba},
        {ChipRole, "chip"_ba},
    };
}

#include "moc_chipsmodel.cpp"
