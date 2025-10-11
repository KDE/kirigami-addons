/*
 *   SPDX-FileCopyrightText: 2025 Aleix Pol Gonzalez <aleixpol@kde.org>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

#pragma once

class QGuiApplication;

#include "kirigamiapp_export.h"

/*!
 * \namespace KirigamiAppDefaults
 * \inmodule KirigamiApp
 * \brief Contains a function to apply useful default Qt options for Kirigami apps.
 */
namespace KirigamiAppDefaults
{
/*!
 * \inmodule KirigamiApp
 * \inheaderfile KirigamiAppDefaults
 *
 * \brief Helper to apply suitable defaults for an app using Kirigami
 *
 * Kirigami apps are generally Qt apps using Kirigami.
 * Qt's defaults and fallbacks on different platforms don't fit these apps very well.
 * This function sets up the default style to Breeze, sets up support for color schemes,
 * sets the Breeze icon theme, sets a font size and configures logging and crash handling.
 *
 * Your normal main function should look something like
 * \code
 * int main(int argc, char *argv[])
 * {
 *     QApplication app(argc, argv);
 *     KirigamiAppDefaults::apply(&app);
 *
 *     // Set up KAboutData
 *
 *     // QCommandLineParser creation and processing
 *
 *     QQmlApplicationEngine engine;
 *     KLocalization::setupLocalizedContext(&engine);
 *     engine.loadFromModule("org.kde.myapp", u"Main");
 *
 *     if (!engine.rootObjects().isEmpty()) {
 *         return -1;
 *     }
 *     return app.exec();
 * }
 *
 * \endcode
 *
 * \since 1.11
 */
KIRIGAMIAPP_EXPORT void apply(QGuiApplication *app);
}
