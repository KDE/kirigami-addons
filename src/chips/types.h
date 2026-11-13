// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

#include <qqmlregistration.h>
#include <QQmlEngine>

#ifdef Q_OS_ANDROID
#include "androidintegration.h"

struct AndroidIntegrationForeign
{
    Q_GADGET
    QML_FOREIGN(KirigamiAddonsDateAndTime::AndroidIntegration)
    QML_NAMED_ELEMENT(AndroidIntegration)
    QML_SINGLETON

public:
    static KirigamiAddonsDateAndTime::AndroidIntegration *create(QQmlEngine *, QJSEngine *)
    {
        auto instance = &KirigamiAddonsDateAndTime::AndroidIntegration::instance();
        QJSEngine::setObjectOwnership(instance, QJSEngine::CppOwnership);
        return instance;
    }
};
#endif
