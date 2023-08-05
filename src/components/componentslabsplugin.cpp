// SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
// SPDX-FileCopyrightText: 2022 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

#include <QQmlExtensionPlugin>
#include <QQmlEngine>

class ComponentsLabsPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    ComponentsLabsPlugin() = default;
    ~ComponentsLabsPlugin() = default;
    void registerTypes(const char *uri) override
    {
        qmlRegisterModule(uri, 1, 0);
    }
};

#include "componentslabsplugin.moc"
