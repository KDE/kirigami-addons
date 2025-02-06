// SPDX-FileCopyrightText: 2025 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "passwordhealth.h"
#include "zxcvbn/zxcvbn.h"

constexpr static int ZXCVBN_ESTIMATE_THRESHOLD = 256;

PasswordHealth::PasswordHealth(QObject *parent)
    : QObject(parent)
{}

QString PasswordHealth::password() const
{
    return m_password;
}

void PasswordHealth::setPassword(const QString &password)
{
    if (m_password == password) {
        return;
    }
    m_password = password;

    auto entropy = 0.0;
    entropy += ZxcvbnMatch(m_password.left(ZXCVBN_ESTIMATE_THRESHOLD).toUtf8().data(), nullptr, nullptr);
    if (m_password.length() > ZXCVBN_ESTIMATE_THRESHOLD) {
        // Add the average entropy per character for any characters above the estimate threshold
        auto average = entropy / ZXCVBN_ESTIMATE_THRESHOLD;
        entropy += average * (m_password.length() - ZXCVBN_ESTIMATE_THRESHOLD);
    }
    m_entropy = entropy;

    Q_EMIT passwordChanged();
}

double PasswordHealth::entropy() const
{
    return m_entropy;
}

PasswordHealth::Quality PasswordHealth::quality() const
{
    if (m_entropy <= 0) {
        return Quality::Bad;
    } else if (m_entropy < 40) {
        return Quality::Poor;
    } else if (m_entropy < 75) {
        return Quality::Weak;
    } else if (m_entropy < 100) {
        return Quality::Good;
    }
    return Quality::Excellent;
}
