/*
 * Copyright 2024 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "book.h"

Book::Book(const QString &title, const QString &author, int year, double rating, QObject *parent)
    : QObject(parent)
    , m_title(title)
    , m_author(author)
    , m_year(year)
    , m_rating(rating)
{
}

QString Book::title() const
{
    return m_title;
}

void Book::setTitle(const QString &title)
{
    if (m_title != title) {
        m_title = title;
        Q_EMIT titleChanged();
    }
}

QString Book::author() const
{
    return m_author;
}

void Book::setAuthor(const QString &author)
{
    if (m_author != author) {
        m_author = author;
        Q_EMIT authorChanged();
    }
}

int Book::year() const
{
    return m_year;
}

void Book::setYear(int year)
{
    if (m_year != year) {
        m_year = year;
        Q_EMIT yearChanged();
    }
}

double Book::rating() const
{
    return m_rating;
}

void Book::setRating(double rating)
{
    if (m_rating != rating) {
        m_rating = rating;
        Q_EMIT ratingChanged();
    }
}
