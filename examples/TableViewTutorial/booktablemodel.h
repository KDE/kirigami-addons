/*
 * Copyright 2024 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#pragma once

#include <QAbstractTableModel>

class Book;
class BookTableModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    enum BookRoles {
        TitleRole = 0,
        AuthorRole,
        YearRole,
        RatingRole,
    };
    Q_ENUM(BookRoles)

    explicit BookTableModel(const QList<Book *> &books, QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const override;

private:
    QList<Book *> m_books;
};
