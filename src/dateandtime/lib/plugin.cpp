#include <QQmlExtensionPlugin>
#include <QQmlEngine>

#include "timezonemodel.h"
#include "knumbermodel.h"
#include "timeinputvalidator.h"

class KirigamiAddonsDataAndTimePlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    KirigamiAddonsDataAndTimePlugin() = default;
    ~KirigamiAddonsDataAndTimePlugin() = default;
    void initializeEngine(QQmlEngine *engine, const char *uri) override {};
    void registerTypes(const char *uri) override;
};

void KirigamiAddonsDataAndTimePlugin::registerTypes(const char *uri)
{
    qmlRegisterType<TimeZoneModel>(uri, 0, 1, "TimeZoneModel");
    qmlRegisterType<TimeZoneFilterProxy>(uri, 0, 1, "TimeZoneFilterModel");
    qmlRegisterType<KNumberModel>(uri, 0, 1, "NumberModel");
    qmlRegisterType<TimeInputValidator>(uri, 0, 1, "TimeInputValidator");
}

#include "plugin.moc"
