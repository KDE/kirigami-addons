// SPDX-FileCopyrightText: 2024 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL

#include "defaultapplication.h"

DefaultKirigamiApplication::DefaultKirigamiApplication(QObject *parent)
    : AbstractKirigamiApplication(parent)
{
    setupActions();
}

void DefaultKirigamiApplication::setupActions()
{
    AbstractKirigamiApplication::setupActions();

    readSettings();
}

#include "moc_defaultapplication.cpp"
