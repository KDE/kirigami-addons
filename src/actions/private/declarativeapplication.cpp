// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "declarativeapplication.h"

DeclarativeApplication::DeclarativeApplication(QObject *parent)
    : AbstractKirigamiApplication(parent)
{
    setupActions();
}

void DeclarativeApplication::setupActions()
{
    AbstractKirigamiApplication::setupActions();
    readSettings();
}

#include "moc_declarativeapplication.cpp"
