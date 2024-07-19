// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "messagedialoghelper.h"
#include <KConfigGroup>

using namespace Qt::StringLiterals;

MessageDialogHelper::MessageDialogHelper(QObject *parent)
    : QObject(parent)
{
}

QJsonObject MessageDialogHelper::shouldBeShownTwoActions(const QString &dontShowAgainName)
{
    KConfigGroup cg(m_config ? m_config : KSharedConfig::openConfig().data(), QStringLiteral("Notification Messages"));
    const QString dontAsk = cg.readEntry(dontShowAgainName, QString()).toLower();
    if (dontAsk == QLatin1StringView("yes") || dontAsk == QLatin1StringView("true")) {
        return {
            { "result"_L1, true },
            { "show"_L1, false },
        };
    }
    if (dontAsk == QLatin1StringView("no") || dontAsk == QLatin1StringView("false")) {
        return {
            { "result"_L1, false },
            { "show"_L1, false },
        };
    }

    return {
        { "show"_L1, true },
    };
}

bool MessageDialogHelper::shouldBeShownContinue(const QString &dontShowAgainName)
{
    KConfigGroup cg(m_config ? m_config : KSharedConfig::openConfig().data(), QStringLiteral("Notification Messages"));
    return cg.readEntry(dontShowAgainName, true);
}

void MessageDialogHelper::saveDontShowAgainTwoActions(const QString &dontShowAgainName, bool result)
{
    KConfigGroup::WriteConfigFlags flags = KConfig::Persistent;
    if (dontShowAgainName[0] == QLatin1Char(':')) {
        flags |= KConfigGroup::Global;
    }
    KConfigGroup cg(m_config ? m_config : KSharedConfig::openConfig().data(), QStringLiteral("Notification Messages"));
    cg.writeEntry(dontShowAgainName, result, flags);
    cg.sync();
}

void MessageDialogHelper::saveDontShowAgainContinue(const QString &dontShowAgainName)
{
    KConfigGroup::WriteConfigFlags flags = KConfigGroup::Persistent;
    if (dontShowAgainName[0] == QLatin1Char(':')) {
        flags |= KConfigGroup::Global;
    }
    KConfigGroup cg(m_config ? m_config : KSharedConfig::openConfig().data(), QStringLiteral("Notification Messages"));
    cg.writeEntry(dontShowAgainName, false, flags);
    cg.sync();
}

KConfig *MessageDialogHelper::config() const
{
    return m_config;
}

void MessageDialogHelper::setConfig(KConfig *config)
{
    if (m_config == config) {
        return;
    }
    m_config = config;
    Q_EMIT configChanged();
}
