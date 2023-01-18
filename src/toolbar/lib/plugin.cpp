/*
 *   SPDX-FileCopyrightText: 2022 Tobias Fella <fella@posteo.de>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include <QQmlExtensionPlugin>
#include <QQmlEngine>

#include "toolbarstatemanager.h"

class ToolBarPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    ToolBarPlugin() = default;
    ~ToolBarPlugin() = default;
    void initializeEngine(QQmlEngine *engine, const char *uri) override;
    void registerTypes(const char *uri) override;
};

void ToolBarPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(engine)
    Q_UNUSED(uri)
}

void ToolBarPlugin::registerTypes(const char *uri)
{
    qmlRegisterModule(uri, 0, 1);
    qmlRegisterType<ToolBarStateManager>(uri, 0, 1, "ToolBarStateManager");
}

#include "plugin.moc"
