// SPDX-FileCopyrightText: 2026 Sandro Andrade <sandroandrade@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

#include <QGuiApplication>
#include <QDir>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QUrl>

#include <utility>

#include <KLocalizedContext>
#include <KLocalizedQmlContext>
#include <KLocalizedString>

static QStringList takeImportPathEnvironmentVariable(const char *name)
{
    const QByteArray value = qgetenv(name);
    if (value.isEmpty()) {
        return {};
    }

    const QStringList paths = QString::fromLocal8Bit(value).split(QDir::listSeparator(), Qt::KeepEmptyParts);
    QStringList normalizedPaths;
    normalizedPaths.reserve(paths.size());

    for (const QString &path : paths) {
        if (path.isEmpty() || QDir::isAbsolutePath(path)) {
            normalizedPaths.append(path);
        } else {
            normalizedPaths.append(QDir::current().absoluteFilePath(path));
        }
    }

    qunsetenv(name);
    return normalizedPaths;
}

int main(int argc, char *argv[])
{
    QStringList importPaths = takeImportPathEnvironmentVariable("QML_IMPORT_PATH");
    importPaths += takeImportPathEnvironmentVariable("QML2_IMPORT_PATH");

    QGuiApplication app(argc, argv);
    KLocalizedString::setApplicationDomain("kirigami-addons6");

    QQuickStyle::setStyle(QStringLiteral("org.kde.desktop"));

    QQmlApplicationEngine engine;
    const QDir applicationDir(QCoreApplication::applicationDirPath());
    const QString buildImportPath = applicationDir.absoluteFilePath(QStringLiteral("../../bin"));
    if (QDir(buildImportPath).exists()) {
        importPaths.prepend(buildImportPath);
    }
    importPaths.removeDuplicates();
    for (auto it = importPaths.crbegin(); it != importPaths.crend(); ++it) {
        if (!it->isEmpty()) {
            engine.addImportPath(*it);
        }
    }

    KLocalization::setupLocalizedContext(&engine);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() {
            QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/org/kde/kirigamiaddons/examples/onboardingtutorial/Main.qml")));

    return QGuiApplication::exec();
}
