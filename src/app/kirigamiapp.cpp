/*
 *   SPDX-FileCopyrightText: 2025 Aleix Pol Gonzalez <aleixpol@kde.org>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "kirigamiapp.h"

#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <KLocalizedContext>

#include "kirigamiappdefaults.h"

class KirigamiAppPrivate
{
public:
    KirigamiAppPrivate() = default;
};

KirigamiApp::KirigamiApp()
{
    Q_ASSERT(qGuiApp);
    KirigamiAppDefaults::apply(qGuiApp);
}

KirigamiApp::~KirigamiApp() = default;

bool KirigamiApp::start(QAnyStringView uri, QAnyStringView typeName, QQmlApplicationEngine *engine)
{
    Q_ASSERT(engine);
    if (!qobject_cast<KLocalizedContext *>(engine->rootContext()->contextObject())) {
        // Ensure the i18n() infrastructure is available
        engine->rootContext()->setContextObject(new KLocalizedContext(engine));
    }
    engine->loadFromModule(uri, typeName);
    return !engine->rootObjects().isEmpty();
}
