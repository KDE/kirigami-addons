// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "datetimefactory.h"

using namespace KirigamiAddonsDateAndTime;

DateTimeFactory::DateTimeFactory(QObject *parent)
    : QObject(parent)
{
}

DateTime DateTimeFactory::now() const
{
    return DateTime(QDateTime::currentDateTime());
}

DateTime DateTimeFactory::fromDateTime(const QDateTime &dateTime) const
{
    return DateTime(dateTime);
}

DateTime DateTimeFactory::invalid() const
{
    return DateTime();
}
