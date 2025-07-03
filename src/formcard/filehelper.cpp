// SPDX-CopyrightText: 2025 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "filehelper_p.h"

#include <QFileInfo>
#include <QUrl>
#include <QDir>

FileHelper::FileHelper(QObject *parent)
    : QObject(parent)
{}

bool FileHelper::fileExists(const QString &fileName)
{
    QFileInfo info(fileName);
    return info.exists() && !info.isDir();
}

bool FileHelper::folderExists(const QString &fileName)
{
    QFileInfo info(fileName);
    return info.exists() && info.isDir();
}

bool FileHelper::parentDirectoryExists(const QString &fileName)
{
    QFileInfo info(fileName);
    const auto dir = info.absoluteDir();
    return dir.exists();
}
