/*
 * Copyright 2024 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "booklistmodel.h"

#include "book.h"

BookListModel::BookListModel(const QList<Book *> &books, QObject *parent)
    : QAbstractListModel(parent)
    , m_books(books)
{
}

int BookListModel::rowCount(const QModelIndex & /* parent */) const
{
    return m_books.count();
}

QVariant BookListModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_books.count())
        return QVariant();

    Book *book = m_books[index.row()];

    if (role == TitleRole)
        return book->title();
    else if (role == AuthorRole)
        return book->author();
    else if (role == YearRole)
        return book->year();
    else if (role == RatingRole)
        return book->rating();

    return QVariant();
}

QHash<int, QByteArray> BookListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "title";
    roles[AuthorRole] = "author";
    roles[YearRole] = "year";
    roles[RatingRole] = "rating";
    return roles;
}
