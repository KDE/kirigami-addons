// SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
//
// SPDX-License-Identifier: LGPL-2.0-or-later

#pragma once

#include <QColor>
#include <QVariant>
#include <qqmlregistration.h>

class NameUtilsElement : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(NameUtils)
    QML_SINGLETON

public:
    Q_INVOKABLE QString initialsFromString(const QString &name);
    Q_INVOKABLE QColor colorsFromString(const QString &name);
    Q_INVOKABLE bool isStringUnsuitableForInitials(const QString &name);
};
