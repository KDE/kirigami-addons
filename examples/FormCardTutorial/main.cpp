#include <QtQml>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <KAboutData>
#include <KLocalizedContext>
#include <KLocalizedString>

int main(int argCount, char* argVector[])
{
    QApplication app(argCount, argVector);
    KLocalizedString::setApplicationDomain("org.kde.addonsexample");

    KAboutData aboutData(
        QStringLiteral("addonsexample"),
        i18n("Addons Example"),
        QStringLiteral("1.0"),
        i18n("This program shows how to use Kirigami Addons"),
        KAboutLicense::GPL_V3,
        QStringLiteral("(C) 2023"),
        i18n("Optional text shown in the About"),
        QStringLiteral("https://kde.org"));

    aboutData.addAuthor(i18nc("@info:credit", "John Doe"),
                        i18nc("@info:credit", "Maintainer"));

    KAboutData::setApplicationData(aboutData);

    QApplication::setWindowIcon(QIcon::fromTheme(QStringLiteral("kde")));

    qmlRegisterSingletonType(
        "org.kde.about",
        1, 0, "About",
        [](QQmlEngine *engine, QJSEngine *) -> QJSValue {
            return engine->toScriptValue(KAboutData::applicationData());
        }
    );

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    engine.load(QStringLiteral("qrc:/main.qml"));
    app.exec();
}

