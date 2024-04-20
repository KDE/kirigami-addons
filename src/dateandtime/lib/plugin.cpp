/*
 *   SPDX-FileCopyrightText: 2019 David Edmundson <davidedmundson@kde.org>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include <QQmlExtensionPlugin>
#include <QQmlEngine>
#include <QAccessible>

#include "yearmodel.h"
#include "monthmodel.h"
#include "infinitecalendarviewmodel.h"
#include <QAccessibleObject>

#ifdef Q_OS_ANDROID
#include "androidintegration.h"

using namespace KirigamiAddonsDateAndTime;
#endif

using namespace Qt::StringLiterals;

class KirigamiAddonsDataAndTimePlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    KirigamiAddonsDataAndTimePlugin() = default;
    ~KirigamiAddonsDataAndTimePlugin() = default;
    void registerTypes(const char *uri) override;
};

class CandoClass : public QAccessibleObject, public QAccessibleValueInterface //, public QAccessibleTextInterface, public QAccessibleEditableTextInterface
{
public:
    using QAccessibleObject::QAccessibleObject;
    [[nodiscard]] QVariant currentValue() const override
    {
        return 1;
     }
     void setCurrentValue(const QVariant &value) override
     {
         abort();
     }
     [[nodiscard]] QVariant maximumValue() const override
     {
         return 1;
     }
     [[nodiscard]] QVariant minimumValue() const override
     {
         return 1;
     }
     [[nodiscard]] QVariant minimumStepSize() const override
     {
         return 1;
     }
     [[nodiscard]] QAccessible::Role role() const override
     {
         return QAccessible::SpinBox;
    }
    [[nodiscard]] QAccessible::State state() const override
    {
        abort();
     }
     [[nodiscard]] QString text(QAccessible::Text t) const override
     {
         return {};
     }
     [[nodiscard]] QAccessibleInterface *child(int index) const override
     {
         return nullptr;
      }
      [[nodiscard]] int childCount() const override
      {
          abort();
      }
      int indexOfChild(const QAccessibleInterface * /*unused*/) const override
      {
          abort();
      }
      [[nodiscard]] QAccessibleInterface *parent() const override
      {
          return nullptr;
       }
};


QAccessibleInterface *sliderFactory(const QString &classname, QObject *object)
{

    qDebug() << classname << object;

    if (classname == "MyComboBox"_L1) {
        abort();
    }
    if (object->metaObject()->indexOfProperty("__kirigami_dateandtime_marker__") >= 0) {
        return new CandoClass(object);
    }

    return nullptr;
}

void KirigamiAddonsDataAndTimePlugin::registerTypes(const char *uri)
{
    QAccessible::installFactory(sliderFactory);

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
