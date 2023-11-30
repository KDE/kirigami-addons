/*
 *  SPDX-FileCopyrightText: 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include <QQmlEngine>
#include <QQmlExtensionPlugin>

class TableViewPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    TableViewPlugin() = default;
    ~TableViewPlugin() = default;
    void registerTypes(const char *uri) override
    {
        Q_ASSERT(QLatin1String(uri) == QLatin1String("org.kde.kirigamiaddons.tableview"));
        qmlRegisterModule(uri, 1, 0);
    }
};

#include "tableviewplugin.moc"
