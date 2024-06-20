// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QObject>
#include <QtQml/qqmlregistration.h>

/// \internal This is private API, do not use.
class Helper : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QString styleName READ styleName CONSTANT);

public:
    explicit Helper(QObject *parent = nullptr);

    QString styleName() const;
};
