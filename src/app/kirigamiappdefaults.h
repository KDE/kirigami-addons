/*
 *   SPDX-FileCopyrightText: 2025 Aleix Pol Gonzalez <aleixpol@kde.org>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

#pragma once

class QGuiApplication;
class QQmlApplicationEngine;

#include <QAnyStringView>

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
 *     if (!KirigamiAppDefaults::load("org.kde.myapp", u"Main", &engine)) {
 *         return EXIT_FAILURE;
 *     }
 *     return app.exec();
 * }
 *
 * \endcode
 *
 * \since 1.11
 */
KIRIGAMIAPP_EXPORT void apply(QGuiApplication *app);

/*!
 * Loads the QML module and displays its loading errors if startup fails.
 *
 * On desktop platforms, the errors are shown in a native message box. On
 * Android, a Qt Quick dialog is used so this helper does not require Qt Widgets.
 *
 * Returns \c true when the requested module or fallback error UI loaded
 * successfully.
 *
 * \since 1.14.1
 */
KIRIGAMIAPP_EXPORT bool load(QAnyStringView uri, QAnyStringView typeName, QQmlApplicationEngine *engine);
}
