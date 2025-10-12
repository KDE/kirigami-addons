/*
 *   SPDX-FileCopyrightText: 2025 Aleix Pol Gonzalez <aleixpol@kde.org>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "kirigamiappdefaults.h"
#include <KAboutData>
#include <KColorSchemeManager>
#include <KLocalizedContext>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QSurfaceFormat>
#include <kcoreaddons_version.h>

#ifndef Q_OS_ANDROID
#include <KCrash>
#include <KIconTheme>
#include <QApplication>
#include <QStyleFactory>
#endif

#ifdef Q_OS_WINDOWS
#include <QFont>
#include <Windows.h>
#endif

namespace KirigamiAppDefaults
{

void apply(QGuiApplication *app)
{
    Q_ASSERT(app);

    using namespace Qt::Literals::StringLiterals;

    auto format = QSurfaceFormat::defaultFormat();
    format.setOption(QSurfaceFormat::ResetNotification);
    QSurfaceFormat::setDefaultFormat(format);

    // Needed when not running with the Plasma QPlatformTheme to ensure colours get initialised
    KColorSchemeManager::instance();

#ifdef Q_OS_ANDROID
    // We don't want the QtWidgets dependency on Android, so we use qqc2-breeze-style there.
    // Icons ought to be included with the app on CMake
    QQuickStyle::setStyle(u"org.kde.breeze"_s);
#else
    // Ensure breeze is the fallback, to make sure all icons are found and no awkward empty spaces.
    QIcon::setFallbackThemeName("breeze"_L1);
    // Default to org.kde.desktop style unless the user forces another style
    if (qEnvironmentVariableIsEmpty("QT_QUICK_CONTROLS_STYLE")) {
        QQuickStyle::setStyle(u"org.kde.desktop"_s);
#ifndef Q_OS_ANDROID
        // TODO remove once we no longer use the org.kde.desktop style
        qApp->setStyle(QStyleFactory::create(QStringLiteral("Breeze")));
#endif
    }
    KIconTheme::initTheme();
#endif

#ifdef Q_OS_WINDOWS
    if (AttachConsole(ATTACH_PARENT_PROCESS)) {
        freopen("CONOUT$", "w", stdout);
        freopen("CONOUT$", "w", stderr);
    }

    auto font = qGuiApp->font();
    font.setPointSize(10);
    qGuiApp->setFont(font);
#endif

#ifndef Q_OS_ANDROID
#if KCOREADDONS_VERSION >= QT_VERSION_CHECK(6, 19, 0)
    // Embrace KCrash. If an application misbehaves, we should know as much as possible about it.
    // Needs initialising KAboutData::setApplicationData
    QObject::connect(KAboutDataListener::instance(), &KAboutDataListener::applicationDataChanged, app, [] {
        KCrash::initialize();
    });
#endif
#endif
}

}
