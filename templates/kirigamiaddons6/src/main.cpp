/*
    SPDX-License-Identifier: GPL-2.0-or-later
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
*/

#include <QtGlobal>
#include <KirigamiApp>

#include <QCommandLineParser>
#include <QIcon>
#include <QQmlApplicationEngine>

#include "version-%{APPNAMELC}.h"
#include <KAboutData>
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

    auto aboutData = KAboutData::fromAppStreamId(u"org.kde.%{APPNAMELC}"_s);
    aboutData.setVersion(%{APPNAMEUC}_VERSION_STRING);
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

    {
        QCommandLineParser parser;
        aboutData.setupCommandLine(&parser);
        parser.process(app);
        aboutData.processCommandLine(&parser);
    }

    if (!kapp.start("org.kde.%{APPNAMELC}", u"Main"_s, &engine)) {
        return EXIT_FAILURE;
    }

    return app.exec();
}
