// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QObject>
#include <QtQml/qqmlregistration.h>
#include <KSharedConfig>
#include <QJsonObject>

/// @internal Only used by MessageDialog
class MessageDialogHelper : public QObject
{
    Q_OBJECT
    QML_SINGLETON

    Q_PROPERTY(KConfig *config READ config WRITE setConfig NOTIFY configChanged);

public:
    explicit MessageDialogHelper(QObject *parent = nullptr);

    KConfig *config() const;
    void setConfig(KConfig *config);

    Q_INVOKABLE QJsonObject shouldBeShownTwoActions(const QString &dontShowAgainName);

    Q_INVOKABLE bool shouldBeShownContinue(const QString &dontShowAgainName);

    Q_INVOKABLE void saveDontShowAgainTwoActions(const QString &dontShowAgainName, bool result);

    Q_INVOKABLE void saveDontShowAgainContinue(const QString &dontShowAgainName);

Q_SIGNALS:
    void configChanged();

private:
    KConfig *m_config = nullptr;
};
