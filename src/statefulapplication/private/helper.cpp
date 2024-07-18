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
