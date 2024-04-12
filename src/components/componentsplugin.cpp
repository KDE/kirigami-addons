// SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
// SPDX-FileCopyrightText: 2022 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

#include <QQmlExtensionPlugin>
#include <QQmlEngine>
#include "nameutils.h"
#include "messagedialoghelper.h"

class ComponentsPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    ComponentsPlugin() = default;
    ~ComponentsPlugin() = default;
    void initializeEngine(QQmlEngine *engine, const char *uri) override;
    void registerTypes(const char *uri) override;
};

void ComponentsPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(engine)
    Q_UNUSED(uri)
}

void ComponentsPlugin::registerTypes(const char *uri)
{
    qmlRegisterModule(uri, 1, 0);
    qmlRegisterSingletonType<NameUtils>(uri, 1, 0, "NameUtils", [](QQmlEngine*, QJSEngine*) -> QObject* {
        return new NameUtils;
    });

    qmlRegisterSingletonType<MessageDialogHelper>(uri, 1, 0, "MessageDialogHelper", [](QQmlEngine*, QJSEngine*) -> QObject* {
        return new MessageDialogHelper;
    });
}

#include "componentsplugin.moc"
