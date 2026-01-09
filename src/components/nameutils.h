// SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
//
// SPDX-License-Identifier: LGPL-2.0-or-later

#pragma once

#include <QVariant>

#include "kirigamiaddonscomponents_export.h"

class KIRIGAMIADDONSCOMPONENTS_EXPORT NameUtils
{
public:
    static QString initialsFromString(const QString &name);
    static QColor colorsFromString(const QString &name);
    static bool isStringUnsuitableForInitials(const QString &name);
};
