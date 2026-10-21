/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "componentsplugin.h"

#include <Kirigami/Platform/StyleSelector>
#include <QtQml>

using namespace Qt::StringLiterals;

extern void qml_register_types_org_kde_kirigamiaddons_components();
Q_GHS_KEEP_REFERENCE(qml_register_types_org_kde_kirigamiaddons_components)

ComponentsPlugin::ComponentsPlugin(QObject *parent)
    : QQmlExtensionPlugin(parent)
{
    volatile auto registration = &qml_register_types_org_kde_kirigamiaddons_components;
    Q_UNUSED(registration)
}

void ComponentsPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(QLatin1StringView(uri) == "org.kde.kirigamiaddons.components"_L1);

    const auto prefix = Kirigami::Platform::StyleSelector::style() == "Material"_L1 ? u"styles/Material/"_s : QString();
    const QUrl root(u"qrc:/qt/qml/org/kde/kirigamiaddons/components/"_s);
    qmlRegisterType(root.resolved(QUrl(prefix + u"DoubleFloatingButton.qml"_s)), uri, 1, 0, "DoubleFloatingButton");
    qmlRegisterType(root.resolved(QUrl(prefix + u"FloatingButton.qml"_s)), uri, 1, 0, "FloatingButton");
    qmlRegisterType(root.resolved(QUrl(prefix + u"FloatingToolBar.qml"_s)), uri, 1, 0, "FloatingToolBar");
    qmlRegisterType(root.resolved(QUrl(prefix + u"RadioSelector.qml"_s)), uri, 1, 0, "RadioSelector");
    qmlRegisterType(root.resolved(QUrl(prefix + u"BottomDrawer.qml"_s)), uri, 1, 0, "BottomDrawer");
    qmlRegisterType(root.resolved(QUrl(prefix + u"MessageDialog.qml"_s)), uri, 1, 0, "MessageDialog");
    qmlRegisterType(root.resolved(QUrl(prefix + u"DialogRoundedBackground.qml"_s)), uri, 1, 0, "DialogRoundedBackground");
}

#include "moc_componentsplugin.cpp"
