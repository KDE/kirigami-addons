// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QObject>
#include <QtQml>
#include <QAction>
#include <QQuickWindow>

using namespace Qt::StringLiterals;

/// \internal This is private API, do not use.
class Helper : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit Helper(QObject *parent = nullptr);

    Q_INVOKABLE QList<QKeySequence> alternateShortcuts(QAction *action) const;
    Q_INVOKABLE QString iconName(const QIcon &icon) const;
};
