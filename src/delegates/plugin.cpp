// SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

#include <QQmlExtensionPlugin>
#include <QQmlEngine>

class DelegatesPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    DelegatesPlugin() = default;
    ~DelegatesPlugin() = default;
    void registerTypes(const char *uri) override;
};

void DelegatesPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(QLatin1String(uri) == QLatin1String("org.kde.kirigamiaddons.delegates"));
    qmlRegisterModule(uri, 1, 0);
}

#include "plugin.moc"
