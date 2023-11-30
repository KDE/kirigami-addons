/*
 * Copyright 2024 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#pragma once

#include <QAbstractListModel>

class Book;
class BookListModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum BookRoles {
        TitleRole = Qt::UserRole + 1,
        AuthorRole,
        YearRole,
        RatingRole,
    };
    Q_ENUM(BookRoles)

    explicit BookListModel(const QList<Book *> &books, QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QList<Book *> m_books;
};
