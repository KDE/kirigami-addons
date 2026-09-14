// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include "../abstractkirigamiapplication.h"

#include <qqmlregistration.h>

class DeclarativeApplication : public AbstractKirigamiApplication
{
    Q_OBJECT
    QML_NAMED_ELEMENT(Application)

public:
    explicit DeclarativeApplication(QObject *parent = nullptr);

private:
    void setupActions() override;
};
