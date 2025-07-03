// SPDX-FileCopyrightText: 2025 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QObject>
#include <qqmlregistration.h>

class FileHelper : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit FileHelper(QObject *parent = nullptr);

    Q_INVOKABLE bool fileExists(const QString &fileName);
    Q_INVOKABLE bool folderExists(const QString &fileName);
    Q_INVOKABLE bool parentDirectoryExists(const QString &fileName);
};
