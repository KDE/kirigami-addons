#include <QtQml>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QQuickStyle>
#include <KAboutData>
#include <KLocalizedContext>
#include <KLocalizedString>

int main(int argCount, char* argVector[])
{
    QApplication app(argCount, argVector);
    KLocalizedString::setApplicationDomain("org.kde.addonsexample");

    KAboutData aboutData(
        QStringLiteral("addonsexample"),
        i18nc("@title:window", "Addons Example"),
        QStringLiteral("1.0"),
        i18nc("@info", "This program shows how to use Kirigami Addons"),
        KAboutLicense::GPL_V3,
        QStringLiteral("(C) 2023"),
        i18nc("@info", "Optional text shown in the About"),
        QStringLiteral("https://kde.org"));

    aboutData.addAuthor(i18nc("@info:credit", "John Doe"),
                        i18nc("@info:credit", "Maintainer"));

    KAboutData::setApplicationData(aboutData);

    if (qEnvironmentVariableIsEmpty("QT_QUICK_CONTROLS_STYLE")) {
        QQuickStyle::setStyle(QStringLiteral("org.kde.desktop"));
    }
    QApplication::setWindowIcon(QIcon::fromTheme(QStringLiteral("kde")));

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    engine.loadFromModule("org.kde.addonsexample", "Main");
    app.exec();
}

