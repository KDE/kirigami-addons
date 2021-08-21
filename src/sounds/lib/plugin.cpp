/*
 *   SPDX-FileCopyrightText: 2021 Han Young <hanyoung@protonmail.com>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include <QQmlExtensionPlugin>
#include <QQmlEngine>
#include "soundspickermodel.h"

class SoundPickerPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    SoundPickerPlugin() = default;
    ~SoundPickerPlugin() = default;
    void initializeEngine(QQmlEngine *engine, const char *uri) override;
    void registerTypes(const char *uri) override;
};

void SoundPickerPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(engine)
    Q_UNUSED(uri)
}

void SoundPickerPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<SoundsPickerModel>(uri, 0, 1, "SoundsModel");
}

#include "plugin.moc"
