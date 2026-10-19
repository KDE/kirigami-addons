/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "formcardplugin.h"

#include <Kirigami/Platform/StyleSelector>
#include <QtQml>

using namespace Qt::StringLiterals;

extern void qml_register_types_org_kde_kirigamiaddons_formcard();
Q_GHS_KEEP_REFERENCE(qml_register_types_org_kde_kirigamiaddons_formcard)

FormCardPlugin::FormCardPlugin(QObject *parent)
    : QQmlExtensionPlugin(parent)
{
    volatile auto registration = &qml_register_types_org_kde_kirigamiaddons_formcard;
    Q_UNUSED(registration)
}

void FormCardPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(QLatin1StringView(uri) == "org.kde.kirigamiaddons.formcard"_L1);

    const auto prefix = Kirigami::Platform::StyleSelector::style() == "Material"_L1 ? u"styles/Material/"_s : QString();
    const QUrl root(u"qrc:/qt/qml/org/kde/kirigamiaddons/formcard/"_s);
    qmlRegisterType(root.resolved(QUrl(prefix + u"FormCard.qml"_s)), uri, 1, 0, "FormCard");
    qmlRegisterType(root.resolved(QUrl(prefix + u"FormCardDialog.qml"_s)), uri, 1, 0, "FormCardDialog");
    qmlRegisterType(root.resolved(QUrl(u"FormCardPage.qml"_s)), uri, 1, 0, "FormCardPage");
    qmlRegisterType(root.resolved(QUrl(prefix + u"FormDelegateBackground.qml"_s)), uri, 1, 0, "FormDelegateBackground");
    qmlRegisterType(root.resolved(QUrl(prefix + u"FormGridContainer.qml"_s)), uri, 1, 0, "FormGridContainer");
    qmlRegisterType(root.resolved(QUrl(prefix + u"FormHeader.qml"_s)), uri, 1, 0, "FormHeader");
}

#include "moc_formcardplugin.cpp"
