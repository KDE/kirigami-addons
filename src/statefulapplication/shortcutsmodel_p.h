// SPDX-FileCopyrightText: 2024 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QAbstractListModel>
#include <QKeySequence>
#include "actionsmodel_p.h"

class QAction;
class KirigamiActionCollection;

/// \internal
class ShortcutsModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit ShortcutsModel(QObject *parent = nullptr);

    enum Role {
        IconNameRole = Qt::UserRole + 1,
        ShortcutRole,
        ShortcutDisplayRole,
        DefaultShortcutRole,
        AlternateShortcutsRole,
        CollectionNameRole,
    };

    struct Item {
        KirigamiActionCollection *collection;
        QAction *action = nullptr;
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void refresh(const QList<KirigamiActionCollection*> &actionCollections);
    Q_INVOKABLE QList<QKeySequence> updateShortcut(int index, int shortcutIndex, QKeySequence keySequence);
    Q_INVOKABLE QList<QKeySequence> reset(int index);
    Q_INVOKABLE void save();
    Q_INVOKABLE void resetAll();

    Q_INVOKABLE QKeySequence emptyKeySequence() const;

private:
    QList<Item> m_items;
    QList<KirigamiActionCollection *> m_collections;
};
