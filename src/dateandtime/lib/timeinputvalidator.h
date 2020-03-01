/*
 *   Copyright 2019 David Edmundson <davidedmundson@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#pragma once

#include <QValidator>

class TimeInputValidatorPrivate;

class TimeInputValidator : public QValidator
{
    Q_OBJECT

    /**
     * This property holds the desired time format.
     */
    Q_PROPERTY(QString format READ format WRITE setFormat NOTIFY formatChanged)

public:
    explicit TimeInputValidator(QObject *parent = nullptr);
    ~TimeInputValidator() override;

    // Overrides from QValidator.
    void fixup(QString &input) const override;
    QValidator::State validate(QString &input, int &pos) const override;

    /**
     * Returns the desired time format.
     */
    QString format() const;

    /**
     * Sets the desired time format.
     */
    void setFormat(const QString &format);

Q_SIGNALS:
    void formatChanged();

private:
    QScopedPointer<TimeInputValidatorPrivate> d;

    Q_DISABLE_COPY(TimeInputValidator)
};
