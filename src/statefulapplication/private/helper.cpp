// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "helper.h"

#include <KWindowConfig>
#include <KConfig>

Helper::Helper(QObject *parent)
    : QObject(parent)
{}

QString Helper::iconName(const QIcon &icon) const
{
    return icon.name();
}

QList<QKeySequence> Helper::alternateShortcuts(QAction *action) const
{
    if (!action || action->shortcuts().length() <= 1) {
        return {};
    } else {
        return action->shortcuts().mid(1);
    }
}

void Helper::restoreWindowGeometry(QQuickWindow *window, const QString &group) const
{
    KConfig dataResource(u"data"_s, KConfig::SimpleConfig, QStandardPaths::AppDataLocation);
    KConfigGroup windowGroup(&dataResource, "Window-"_L1 + group);
    KWindowConfig::restoreWindowSize(window, windowGroup);
    KWindowConfig::restoreWindowPosition(window, windowGroup);
}

void Helper::saveWindowGeometry(QQuickWindow *window, const QString &group) const
{
    KConfig dataResource(u"data"_s, KConfig::SimpleConfig, QStandardPaths::AppDataLocation);
    KConfigGroup windowGroup(&dataResource, "Window-"_L1 + group);
    KWindowConfig::saveWindowPosition(window, windowGroup);
    KWindowConfig::saveWindowSize(window, windowGroup);
    dataResource.sync();
}

