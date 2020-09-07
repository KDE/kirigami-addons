/*
 *  SPDX-FileCopyrightText: 2020 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

#pragma once

#include <QQmlExtensionPlugin>

class TreeViewPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    TreeViewPlugin(QObject *parent = nullptr);
    void registerTypes(const char *uri) override;

private:
    QUrl componentUrl(const QString &fileName) const;
    QString resolveFilePath(const QString &path) const
    {
        return baseUrl().toLocalFile() + QLatin1Char('/') + path;
    }
    QString resolveFileUrl(const QString &filePath) const
    {
        return baseUrl().toString() + QLatin1Char('/') + filePath;
    }
    QStringList m_stylesFallbackChain;
};
