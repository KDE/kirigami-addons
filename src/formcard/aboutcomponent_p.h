// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-FileCopyrightText: 2026 Volker Krause <vkrause@kde.org>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QObject>
#include <QStringList>
#include <qqmlregistration.h>
#include <KAboutComponent>

/*!
 * \class AboutComponent
 * \inmodule KirigamiAddonsFormCard
 * \internal Do not use this
 */
class AboutComponent : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QList<KAboutComponent> components READ components CONSTANT)
    Q_PROPERTY(QStringList releaseVersions READ releaseVersions WRITE setReleaseVersions NOTIFY releasesChanged)
    Q_PROPERTY(QString currentVersion READ currentVersion WRITE setCurrentVersion NOTIFY releasesChanged)
    Q_PROPERTY(QList<int> newReleaseIndexes READ newReleaseIndexes NOTIFY releasesChanged)
    Q_PROPERTY(bool hasNewReleases READ hasNewReleases NOTIFY hasNewReleasesChanged)

public:
    explicit AboutComponent(QObject *parent = nullptr);
    ~AboutComponent();

    QList<KAboutComponent> components() const;

    [[nodiscard]] QStringList releaseVersions() const;
    [[nodiscard]] QString currentVersion() const;
    void setReleaseVersions(const QStringList &releaseVersions);
    void setCurrentVersion(const QString &currentVersion);
    [[nodiscard]] QList<int> newReleaseIndexes() const;
    [[nodiscard]] bool hasNewReleases() const;

    Q_INVOKABLE void updateLastSeenVersion();

    Q_INVOKABLE void copyToClipboard();
    Q_INVOKABLE void copyTextToClipboard(const QString &url);

Q_SIGNALS:
    void releasesChanged();
    void hasNewReleasesChanged();

private:
    void updateNewReleases();

    QString m_currentVersion;
    QString m_lastSeenVersion;
    QStringList m_releaseVersions;
    QList<int> m_newReleaseIndexes;
};
