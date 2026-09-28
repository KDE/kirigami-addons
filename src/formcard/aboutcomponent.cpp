// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-FileCopyrightText: 2026 Volker Krause <vkrause@kde.org>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "aboutcomponent_p.h"

#include <KConfigGroup>
#include <KCoreAddons>
#include <KLocalizedString>
#include <KSharedConfig>
#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
#include <KSandbox>
#endif
#include <QGuiApplication>
#include <QClipboard>
#include <QCoreApplication>
#include <QVersionNumber>

using namespace Qt::StringLiterals;

AboutComponent::AboutComponent(QObject *parent)
    : QObject(parent)
    , m_currentVersion(QCoreApplication::applicationVersion())
{
    const KConfigGroup config(KSharedConfig::openStateConfig(), QStringLiteral("WhatsNew"));
    m_lastSeenVersion = config.readEntry("LastSeenVersion", QString());
    qWarning() << m_lastSeenVersion;
}

AboutComponent::~AboutComponent() = default;

QStringList AboutComponent::releaseVersions() const
{
    return m_releaseVersions;
}

QString AboutComponent::currentVersion() const
{
    return m_currentVersion;
}

void AboutComponent::setReleaseVersions(const QStringList &releaseVersions)
{
    if (m_releaseVersions == releaseVersions) {
        return;
    }
    m_releaseVersions = releaseVersions;
    updateNewReleases();
}

void AboutComponent::setCurrentVersion(const QString &currentVersion)
{
    if (m_currentVersion == currentVersion) {
        return;
    }
    m_currentVersion = currentVersion;
    updateNewReleases();
}

void AboutComponent::updateNewReleases()
{
    m_newReleaseIndexes.clear();
    const auto lastVersion = QVersionNumber::fromString(m_lastSeenVersion.isEmpty() ? m_currentVersion : m_lastSeenVersion);
    for (int i = 0; i < m_releaseVersions.size(); ++i) {
        if (QVersionNumber::fromString(m_releaseVersions.at(i)) > lastVersion) {
            m_newReleaseIndexes.append(i);
        }
    }
    Q_EMIT releasesChanged();
    Q_EMIT hasNewReleasesChanged();
}

QList<int> AboutComponent::newReleaseIndexes() const
{
    return m_newReleaseIndexes;
}

bool AboutComponent::hasNewReleases() const
{
    return !m_newReleaseIndexes.empty()
        && QVersionNumber::fromString(m_lastSeenVersion.isEmpty() ? m_currentVersion : m_lastSeenVersion)
            < QVersionNumber::fromString(m_currentVersion);
}

void AboutComponent::updateLastSeenVersion()
{
    // This intentionally does not update m_newReleaseIndexes, so things don't change in the UI.
    m_lastSeenVersion = m_currentVersion;
    KConfigGroup config(KSharedConfig::openStateConfig(), QStringLiteral("WhatsNew"));
    config.writeEntry("LastSeenVersion", m_lastSeenVersion);
    config.sync();

    Q_EMIT hasNewReleasesChanged();
}

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

#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
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
