// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "aboutcomponent_p.h"

#include <KCoreAddons>
#include <KLocalizedString>
#include <KSandbox>
#include <QGuiApplication>
#include <QClipboard>

using namespace Qt::StringLiterals;

AboutComponent::AboutComponent(QObject *parent)
    : QObject(parent)
{}

AboutComponent::~AboutComponent() = default;

QList<KAboutComponent> AboutComponent::components() const
{
    QList<KAboutComponent> allComponents = KAboutData::applicationData().components();
    auto platform = QGuiApplication::platformName();
    platform.replace(0, 1, platform[0].toUpper());
    if (platform == u"Wayland"_s || platform == u"Xcb"_s) {
        platform = i18nc("@info Platform name", "%1 (%2)", QSysInfo::prettyProductName(), platform);
    } else {
        platform = QSysInfo::prettyProductName();
    }
    allComponents.append(KAboutComponent(i18n("KDE Frameworks"),
                                          i18nc("@info", "Collection of libraries created by the KDE Community to extend Qt."),
                                          KCoreAddons::versionString(),
                                          QStringLiteral("https://develop.kde.org/products/frameworks/"),
                                          KAboutLicense::LGPL_V2_1));

    allComponents.append(KAboutComponent(i18n("Qt"),
                                          i18nc("@info", "Cross-platform application development framework."),
                                          i18n("Using %1 and built against %2", QString::fromLocal8Bit(qVersion()), QStringLiteral(QT_VERSION_STR)),
                                          QStringLiteral("https://www.qt.io/"),
                                          KAboutLicense::LGPL_V3));

#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    QString packageText = i18nc("Linux packaging format", "Unknown/Default");
    if (KSandbox::isFlatpak()) {
        packageText = i18nc("Linux packaging format", "Flatpak");
    }
    if (KSandbox::isSnap()) {
        packageText = i18nc("Linux packaging format", "Snap");
    }
    if (qEnvironmentVariableIsSet("APPIMAGE")) {
        packageText = i18nc("Linux packaging format", "AppImage");
    }
    allComponents.append(KAboutComponent(packageText, i18nc("@info", "Distribution method.")));
#endif

    allComponents.prepend(KAboutComponent(platform, i18nc("@info", "Underlying platform.")));

    return allComponents;
}

void AboutComponent::copyToClipboard()
{
    auto aboutData = KAboutData::applicationData();
    QString info = aboutData.displayName() + u": "_s + aboutData.version() + u'\n';

    const auto allComponents = components();
    for (const auto &component : allComponents) {
        info += component.name();
        if (!component.version().isEmpty()) {
            info += u": "_s + component.version();
        }
        info += u'\n';
    }

    info += u"Build ABI: "_s + QSysInfo::buildAbi() + u'\n';
    info += u"Kernel: "_s + QSysInfo::kernelType() + u' ' + QSysInfo::kernelVersion() + u'\n';

    QClipboard *clipboard = QGuiApplication::clipboard();
    clipboard->setText(info);
}

void AboutComponent::copyTextToClipboard(const QString &url)
{
    QClipboard *clipboard = QGuiApplication::clipboard();
    clipboard->setText(url);
}
