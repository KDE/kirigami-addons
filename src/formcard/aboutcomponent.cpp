// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "aboutcomponent_p.h"

#include <KLocalizedString>
#include <QGuiApplication>

AboutComponent::AboutComponent(QObject *parent)
    : QObject(parent)
{}

AboutComponent::~AboutComponent() = default;

QList<KAboutComponent> AboutComponent::components() const
{
    QList<KAboutComponent> allComponents = KAboutData::applicationData().components();
    auto platform = QGuiApplication::platformName();
    platform.replace(0, 1, platform[0].toUpper());
    allComponents.prepend(KAboutComponent(platform, i18n("Windowing system")));
    allComponents.prepend(KAboutComponent(i18n("Qt"),
                                          i18nc("@info", "Cross-platform application development framework"),
                                          i18n("Using %1 and built against %2", QString::fromLocal8Bit(qVersion()), QStringLiteral(QT_VERSION_STR)),
                                          QStringLiteral("https://www.qt.io/"),
                                          KAboutLicense::LGPL_V3));
    allComponents.prepend(KAboutComponent(i18n("KDE Frameworks"),
                                          i18nc("@info", "Collection of libraries created by the KDE Community to extend Qt"),
                                          QStringLiteral(KI18N_VERSION_STRING),
                                          QStringLiteral("https://develop.kde.org/products/frameworks/"),
                                          KAboutLicense::LGPL_V2_1));

    return allComponents;
}