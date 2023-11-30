/*
 * Copyright 2024 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "booktablemodel.h"

#include "book.h"

BookTableModel::BookTableModel(const QList<Book *> &books, QObject *parent)
    : QAbstractTableModel(parent)
    , m_books(books)
{
}

int BookTableModel::rowCount(const QModelIndex & /* parent */) const
{
    return m_books.count();
}

int BookTableModel::columnCount(const QModelIndex & /* parent */) const
{
    return 4; // for title, author, year, rating
}

QVariant BookTableModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_books.count())
        return QVariant();

    Book *book = m_books[index.row()];

    if (role == Qt::DisplayRole) {
        switch (index.column()) {
        case TitleRole:
            return book->title();
        case AuthorRole:
            return book->author();
        case YearRole:
            return book->year();
        case RatingRole:
            return book->rating();
        }
    }

    return QVariant();
}

QVariant BookTableModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        if (section == TitleRole) {
            return QStringLiteral("Book");
        }

        if (section == AuthorRole) {
            return QStringLiteral("Author");
        }

        if (section == YearRole) {
            return QStringLiteral("Year");
        }

        if (section == RatingRole) {
            return QStringLiteral("Rating");
        }
    }

    return QVariant();
}
