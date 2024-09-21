// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

#include <qqmlregistration.h>

#ifdef Q_OS_ANDROID
#include "androidintegration.h"

struct AndroidIntegrationForeign : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(AndroidIntegration)
    QML_SINGLETON
};
#endif
