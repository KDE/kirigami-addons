// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QObject>
#include <qqmlregistration.h>
#include <KAboutComponent>

/// @internal Do not use this
class AboutComponent : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QList<KAboutComponent> components READ components CONSTANT)

public:
    explicit AboutComponent(QObject *parent = nullptr);
    ~AboutComponent();

    QList<KAboutComponent> components() const;

    Q_INVOKABLE void copyToClipboard();
    Q_INVOKABLE void copyTextToClipboard(const QString &url);
};
