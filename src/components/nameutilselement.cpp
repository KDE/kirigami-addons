// SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
//
// SPDX-License-Identifier: LGPL-2.0-or-later

#include "nameutilselement.h"

#include "nameutils.h"

QString NameUtilsElement::initialsFromString(const QString &string)
{
    return NameUtils::initialsFromString(string);
}

auto NameUtilsElement::colorsFromString(const QString &string) -> QColor
{
    return NameUtils::colorsFromString(string);
}

auto NameUtilsElement::isStringUnsuitableForInitials(const QString &string) -> bool
{
    return NameUtils::isStringUnsuitableForInitials(string);
}

#include "moc_nameutilselement.cpp"
