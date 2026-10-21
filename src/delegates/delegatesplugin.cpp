/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "delegatesplugin.h"

#include <Kirigami/Platform/StyleSelector>
#include <QtQml>

using namespace Qt::StringLiterals;

extern void qml_register_types_org_kde_kirigamiaddons_delegates();
Q_GHS_KEEP_REFERENCE(qml_register_types_org_kde_kirigamiaddons_delegates)

DelegatesPlugin::DelegatesPlugin(QObject *parent)
    : QQmlExtensionPlugin(parent)
{
    volatile auto registration = &qml_register_types_org_kde_kirigamiaddons_delegates;
    Q_UNUSED(registration)
}

void DelegatesPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(QLatin1StringView(uri) == "org.kde.kirigamiaddons.delegates"_L1);

    const auto prefix = Kirigami::Platform::StyleSelector::style() == "Material"_L1 ? u"styles/Material/"_s : QString();
    const QUrl root(u"qrc:/qt/qml/org/kde/kirigamiaddons/delegates/"_s);
    qmlRegisterType(root.resolved(QUrl(prefix + u"RoundedItemDelegate.qml"_s)), uri, 1, 0, "RoundedItemDelegate");
    qmlRegisterType(root.resolved(QUrl(prefix + u"CheckDelegate.qml"_s)), uri, 1, 0, "CheckDelegate");
    qmlRegisterType(root.resolved(QUrl(prefix + u"RadioDelegate.qml"_s)), uri, 1, 0, "RadioDelegate");
    qmlRegisterType(root.resolved(QUrl(prefix + u"IndicatorItemDelegate.qml"_s)), uri, 1, 0, "IndicatorItemDelegate");
}

#include "moc_delegatesplugin.cpp"
