/*
 *  SPDX-FileCopyrightText: 2020 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "configdialogplugin.h"

#include <QQmlEngine>

static QString s_selectedStyle;

ConfigDialogPlugin::ConfigDialogPlugin(QObject *parent)
    : QQmlExtensionPlugin(parent)
{
}

void ConfigDialogPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(QLatin1String(uri) == QLatin1String("org.kde.kirigamiaddons.configdialog"));

    

    qmlProtectModule(uri, 1);
}

#include "configdialogplugin.moc"
