// SPDX-FileCopyrightText: 2024 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QAbstractListModel>
#include "actionsmodel_p.h"

class QAction;

class ShortcutsModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit ShortcutsModel(QObject *parent = nullptr);

    enum Role {
        IconNameRole = Qt::UserRole + 1,
        ShortcutRole,
        DefaultShortcutRole,
        AlternateShortcutRole,
        CollectionNameRole,
    };

    struct Item {
        QString collectionName;
        QAction *action = nullptr;
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void refresh(const QList<KalCommandBarModel::ActionGroup> &actionGroups);

private:
    QList<Item> m_items;
};
