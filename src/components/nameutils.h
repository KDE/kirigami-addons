// SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
//
// SPDX-License-Identifier: LGPL-2.0-or-later

#pragma once

#include <QColor>
#include <QObject>
#include <QVariant>
#include <qqmlregistration.h>

class NameUtils : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    Q_INVOKABLE QString initialsFromString(const QString &name);
    Q_INVOKABLE QColor colorsFromString(const QString &name);
    Q_INVOKABLE bool isStringUnsuitableForInitials(const QString &name);
};
