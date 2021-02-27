/*
 *   SPDX-FileCopyrightText: 2019 David Edmundson <davidedmundson@kde.org>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include <QQmlExtensionPlugin>
#include <QQmlEngine>

#include "timezonemodel.h"
#include "timeinputvalidator.h"
#include "yearmodel.h"
#include "monthmodel.h"

class KirigamiAddonsDataAndTimePlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    KirigamiAddonsDataAndTimePlugin() = default;
    ~KirigamiAddonsDataAndTimePlugin() = default;
    void initializeEngine(QQmlEngine *engine, const char *uri) override;
    void registerTypes(const char *uri) override;
};

void KirigamiAddonsDataAndTimePlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(engine)
    Q_UNUSED(uri)
}

void KirigamiAddonsDataAndTimePlugin::registerTypes(const char *uri)
{
    qmlRegisterType<YearModel>(uri, 0, 1, "YearModel");
    qmlRegisterType<MonthModel>(uri, 0, 1, "MonthModel");
    qmlRegisterType<TimeZoneModel>(uri, 0, 1, "TimeZoneModel");
    qmlRegisterType<TimeZoneFilterProxy>(uri, 0, 1, "TimeZoneFilterModel");
    qmlRegisterType<TimeInputValidator>(uri, 0, 1, "TimeInputValidator");
}

#include "plugin.moc"
