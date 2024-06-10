// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "helper.h"


Helper::Helper(QObject *parent)
    : QObject(parent)
{}

QList<QKeySequence> Helper::alternateShortcuts(QAction *action) const
{
    if (action->shortcuts().length() <= 1) {
        return {};
    } else {
        return action->shortcuts().mid(1);
    }
}

