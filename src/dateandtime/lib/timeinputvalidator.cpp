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

#include "timeinputvalidator.h"

#include "qdatetimeparser_p.h"

static QDateTime nullDateTime()
{
    return QDateTime(QDate::currentDate(), QTime(0, 0));
}

class TimeInputValidatorPrivate : public QDateTimeParser
{
public:
    TimeInputValidatorPrivate();

    void fixup(QString &input) const;
    QValidator::State validate(QString &input, int &pos) const;

    QDateTime defaultValue;
    QString format;
};

TimeInputValidatorPrivate::TimeInputValidatorPrivate()
    : QDateTimeParser(QVariant::DateTime, Context::DateTimeEdit)
    , defaultValue(nullDateTime())
{
}

void TimeInputValidatorPrivate::fixup(QString &input) const
{
    if (input.isEmpty()) {
        return;
    }

    if (format.isEmpty()) {
        return;
    }

    const StateNode stateNode = parse(input, cursorPosition(), defaultValue, true);

    input = stateNode.input;
}

QValidator::State TimeInputValidatorPrivate::validate(QString &input, int &pos) const
{
    if (input.isEmpty()) {
        return QValidator::State::Invalid;
    }

    if (format.isEmpty()) {
        return QValidator::State::Invalid;
    }

    const StateNode stateNode = parse(input, pos, defaultValue, false);

    // TODO: Take conflicts field into account?
    input = stateNode.input;
    pos += stateNode.padded;

    return QValidator::State(stateNode.state);
}

TimeInputValidator::TimeInputValidator(QObject *parent)
    : QValidator(parent)
    , d(new TimeInputValidatorPrivate)
{
}

TimeInputValidator::~TimeInputValidator()
{
}

void TimeInputValidator::fixup(QString &input) const
{
    d->fixup(input);
}

QValidator::State TimeInputValidator::validate(QString &input, int &pos) const
{
    return d->validate(input, pos);
}

QString TimeInputValidator::format() const
{
    return d->format;
}

void TimeInputValidator::setFormat(const QString &format)
{
    if (d->format == format) {
        return;
    }
    if (!d->parseFormat(format)) {
        return;
    }
    d->format = format;
    emit formatChanged();
}
