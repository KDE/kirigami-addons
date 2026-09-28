// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

#pragma once

#include <KConfig>
#include <QObject>
#include <QTemporaryDir>

class TestConfig : public QObject
{
    Q_OBJECT
    Q_PROPERTY(KConfig *config READ config CONSTANT)

public:
    explicit TestConfig(QObject *parent = nullptr)
        : QObject(parent)
        , m_config(m_directory.filePath(QStringLiteral("messagedialogrc")), KConfig::SimpleConfig)
    {
    }

    KConfig *config()
    {
        return &m_config;
    }

private:
    QTemporaryDir m_directory;
    KConfig m_config;
};
