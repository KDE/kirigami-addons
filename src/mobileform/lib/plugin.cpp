/*
 *   SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include <QQmlExtensionPlugin>
#include <QQmlEngine>

class MobileFormPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    MobileFormPlugin() = default;
    ~MobileFormPlugin() = default;
    void initializeEngine(QQmlEngine *engine, const char *uri) override;
    void registerTypes(const char *uri) override;
};

void MobileFormPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(engine)
    Q_UNUSED(uri)
}

void MobileFormPlugin::registerTypes(const char *uri)
{
    qmlRegisterModule(uri, 0, 1);
}

#include "plugin.moc"
