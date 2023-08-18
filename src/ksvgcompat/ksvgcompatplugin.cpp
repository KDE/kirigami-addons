/*
 *   SPDX-FileCopyrightText: 2023 Marco Martin <mart@kde.org>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include <QQmlExtensionPlugin>
#include <QQmlEngine>

class KSvgComaptPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    KSvgComaptPlugin() = default;
    ~KSvgComaptPlugin() = default;
    void registerTypes(const char *uri) override
    {
        Q_ASSERT(QLatin1String(uri) == QLatin1String("org.kde.ksvg"));
        qmlRegisterModule(uri, 1, 0);
    }
};

#include "ksvgcompatplugin.moc"
