/*
 * Copyright 2024 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#pragma once

#include <QObject>

class Book final : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString author READ author WRITE setAuthor NOTIFY authorChanged)
    Q_PROPERTY(int year READ year WRITE setYear NOTIFY yearChanged)
    Q_PROPERTY(double rating READ rating WRITE setRating NOTIFY ratingChanged)

public:
    explicit Book(const QString &title, const QString &author, int year, double rating, QObject *parent = nullptr);

    QString title() const;
    void setTitle(const QString &title);

    QString author() const;
    void setAuthor(const QString &author);

    int year() const;
    void setYear(int year);

    double rating() const;
    void setRating(double rating);

Q_SIGNALS:
    void titleChanged();
    void authorChanged();
    void yearChanged();
    void ratingChanged();

private:
    QString m_title;
    QString m_author;
    int m_year;
    double m_rating;
};
