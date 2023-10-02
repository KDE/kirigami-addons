/*
 *   SPDX-FileCopyrightText: 2019 David Edmundson <davidedmundson@kde.org>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include <QQmlExtensionPlugin>
#include <QQmlEngine>

#include "yearmodel.h"
#include "monthmodel.h"
#include "infinitecalendarviewmodel.h"

#ifdef Q_OS_ANDROID
#include "androidintegration.h"

using namespace KirigamiAddonsDateAndTime;
#endif

class KirigamiAddonsDataAndTimePlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    KirigamiAddonsDataAndTimePlugin() = default;
    ~KirigamiAddonsDataAndTimePlugin() = default;
    void registerTypes(const char *uri) override;
};

void KirigamiAddonsDataAndTimePlugin::registerTypes(const char *uri)
{
    qmlRegisterType<YearModel>(uri, 1, 0, "YearModel");
    qmlRegisterType<MonthModel>(uri, 1, 0, "MonthModel");
    qmlRegisterType<InfiniteCalendarViewModel>(uri, 1, 0, "InfiniteCalendarViewModel");

#ifdef Q_OS_ANDROID
    qmlRegisterSingletonType<AndroidIntegration>(uri, 1, 0, "AndroidIntegration", [](QQmlEngine*, QJSEngine*) -> QObject* {
        QQmlEngine::setObjectOwnership(&AndroidIntegration::instance(), QQmlEngine::CppOwnership);
        return &AndroidIntegration::instance();
    });
#endif
}

#include "plugin.moc"
