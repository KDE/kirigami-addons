/*
 * SPDX-FileCopyrightText: 2026 Kai Uwe Broulik <kde@broulik.de>
 *
 * SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL
 */

#pragma once

#include <QAbstractListModel>

#include "chipobject.h"

class ChipsModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    QML_UNCREATABLE("Managed by ChipsTextDocument")

public:
    explicit ChipsModel(QObject *parent = nullptr);
    ~ChipsModel() override;

    enum Roles {
        ChipRole = Qt::UserRole + 1,
    };
    Q_ENUM(Roles)

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &data, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void append(ChipObject *chip);
    ChipObject *chipAt(int row) const;
    bool contains(ChipObject *chip) const;
    void clear();

private:
    QList<ChipObject *> m_chips;
};
