/*
 * SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#pragma once

#include <Kirigami/Platform/PlatformTheme>
#include <QPointer>

class QQmlEngine;

// Adapted from Kirigami's BasicTheme, using its QML definition through QObject.
class MaterialTheme : public Kirigami::Platform::PlatformTheme
{
    Q_OBJECT

public:
    explicit MaterialTheme(QObject *parent, QObject *definition);

    static QObject *themeDefinition(QQmlEngine *engine);
    QIcon iconFromTheme(const QString &name, const QColor &customColor = Qt::transparent) override;

protected:
    bool event(QEvent *event) override;

private Q_SLOTS:
    void syncColors();

private:
    QColor tint(const QColor &color) const;
    void syncToQml();

    QPointer<QObject> m_definition;
    bool m_syncing = false;
};
