/*
    SPDX-License-Identifier: GPL-2.0-or-later
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
*/

#include <QtGlobal>
#include <KirigamiApp.h>

#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QUrl>

#include "version-%{APPNAMELC}.h"
#include <KAboutData>
#include <KIconTheme>
#include <KLocalizedQmlContext>
#include <KLocalizedString>

#include "%{APPNAMELC}config.h"

using namespace Qt::Literals::StringLiterals;

#ifdef Q_OS_ANDROID
Q_DECL_EXPORT
#endif
int main(int argc, char *argv[])
{
    KirigamiApp::App app(argc, argv);
    KirigamiApp kapp;

    KLocalizedString::setApplicationDomain("%{APPNAMELC}");
    QCoreApplication::setOrganizationName(u"KDE"_s);

    KAboutData aboutData(
        // The program name used internally.
        u"%{APPNAMELC}"_s,
        // A displayable program name string.
        i18nc("@title", "%{APPNAME}"),
        // The program version string.
        QStringLiteral(%{APPNAMEUC}_VERSION_STRING),
        // Short description of what the app does.
        i18n("Application Description"),
        // The license this code is released under.
        KAboutLicense::GPL,
        // Copyright Statement.
        i18n("(c) %{CURRENT_YEAR}"));
    aboutData.addAuthor(i18nc("@info:credit", "%{AUTHOR}"),
                        i18nc("@info:credit", "Maintainer"),
                        u"%{EMAIL}"_s,
                        u"https://yourwebsite.com"_s);
    aboutData.setTranslator(i18nc("NAME OF TRANSLATORS", "Your names"), i18nc("EMAIL OF TRANSLATORS", "Your emails"));
    KAboutData::setApplicationData(aboutData);
    QGuiApplication::setWindowIcon(QIcon::fromTheme(u"org.kde.%{APPNAMELC}"_s));

    QQmlApplicationEngine engine;

    auto config = %{APPNAME}Config::self();

    qmlRegisterSingletonInstance("org.kde.%{APPNAMELC}.private", 1, 0, "Config", config);

    KLocalization::setupLocalizedContext(&engine);
    engine.loadFromModule("org.kde.%{APPNAMELC}", u"Main"_s);

    {
        QCommandLineParser parser;
        aboutData.setupCommandLine(&parser);
        parser.process(app);
        aboutData.processCommandLine(&parser);
    }

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
