// SPDX-FileCopyrightText: 2025 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QObject>
#include <qqmlregistration.h>

/**
 * @internal Do not use!
 */
class PasswordHealth : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
    Q_PROPERTY(double entropy READ entropy NOTIFY passwordChanged)
    Q_PROPERTY(Quality quality READ quality NOTIFY passwordChanged)

public:
    enum Quality {
        Bad,
        Poor,
        Weak,
        Good,
        Excellent,
    };
    Q_ENUM(Quality)

    explicit PasswordHealth(QObject *parent = nullptr);

    [[nodiscard]] QString password() const;
    void setPassword(const QString &password);

    double entropy() const;
    Quality quality() const;

Q_SIGNALS:
    void passwordChanged();

private:
    QString m_password;
    double m_entropy;
};
