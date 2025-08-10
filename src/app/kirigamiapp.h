/*
 *   SPDX-FileCopyrightText: 2025 Aleix Pol Gonzalez <aleixpol@kde.org>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

#pragma once

#include <QQuickWindow>

#include "kirigamiapp_export.h"

class QQmlApplicationEngine;
class KirigamiAppPrivate;

/*!
 * \class KirigamiApp
 * \inmodule KirigamiAddons
 * \inheaderfile KirigamiApp
 *
 * \brief Helper to set up the process to properly run a Kirigami app
 *
 * Kirigami apps are generally Qt apps using Kirigami. While that stands, there's
 * certain things we need to do to ensure proper integration with the OS and that
 * the different KDE Frameworks are engaged in making the app work smoothly.
 *
 * Your normal main function should look something like
 * \code
 * int main(int argc, char *argv[])
 * {
 *     KirigamiApp::App app(argc, argv);
 *     KirigamiApp kapp;
 *
 *     // Set up KAboutData
 *
 *     // QCommandLineParser creation and processing
 *
 *     if (!kapp.start("org.kde.myapp", u"Main", new QQmlApplicationEngine)) {
 *         return -1;
 *     }
 *     return app.exec();
 * }
 *
 * \endcode
 *
 * \since 1.10
 */
class KIRIGAMIAPP_EXPORT KirigamiApp : public QObject
{
public:
    /*!
     * Constructor.
     *
     * Call right after initialising the Q*Application
     */
    KirigamiApp();
    ~KirigamiApp() override;

    /*!
     * \class KirigamiApp::App
     *
     * \brief Chooses either \class QGuiApplication or \class QApplication for you.
     *
     * Allows the system to choose the one you'll want without really having to
     * decide. Kirigami apps should generally not need QApplication (only for
     * certain specific cases), but we keep using it in most apps to support
     * qqc2-desktop-style which depends on QStyle. Except for on Android where
     * we normally run with qqc2-breeze-style by default, which is QWidgets-free.
     */
#ifdef Q_OS_ANDROID
    using App = QGuiApplication;
#else
    using App = QApplication;
#endif

    /*!
     * Sets up the app's QQmlApplicationEngine, enables the translation context
     * and loads the QML type \a typeName from the module specified by \a uri.
     */
    bool start(QAnyStringView uri, QAnyStringView typeName, QQmlApplicationEngine *engine);

private:
    std::unique_ptr<KirigamiAppPrivate> d;
};
