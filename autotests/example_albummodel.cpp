// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

#include "example_albummodel.h"

#include <QDebug>

ExampleAlbumModel::ExampleAlbumModel(QObject *parent)
    : QAbstractListModel(parent)
{
    // Create some dummy data.
    m_items.append(Item {
        QStringLiteral("https://kde.org/stuff/clipart/logo/kde-logo-white-blue-rounded-source.svg"),
        QStringLiteral("https://kde.org/stuff/clipart/logo/kde-logo-white-gray-rounded-source.svg"),
        Type::Image,
        QStringLiteral("A test image"),
    });
    m_items.append(Item {
        QStringLiteral("https://cdn.kde.org/promo/Announcements/Plasma/5.27/discover_hl_720p.webm"),
        QStringLiteral("https://kde.org/stuff/clipart/logo/kde-logo-white-gray-rounded-source.svg"),
        Type::Video,
        QStringLiteral("A test video"),
    });
    m_items.append(Item {
        QStringLiteral("https://kde.org/stuff/clipart/logo/kde-logo-white-blue-rounded-source.svg"),
        QStringLiteral("https://kde.org/stuff/clipart/logo/kde-logo-white-gray-rounded-source.svg"),
        Type::Image,
        QString(),
    });
}

ExampleAlbumModel::~ExampleAlbumModel() = default;

QVariant ExampleAlbumModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) {
        return {};
    }

    if (index.row() >= m_items.count()) {
        qDebug() << "ExampleAlbumModel, something's wrong: index.row() >= m_items.count()";
        return {};
    }

    if (role == SourceRole) {
        return m_items.at(index.row()).source;
    }
    if (role == TempSourceRole) {
        return m_items.at(index.row()).tempSource;
    }
    if (role == TypeRole) {
        return m_items.at(index.row()).type;
    }
    if (role == CaptionRole) {
        return m_items.at(index.row()).caption;
    }

    return {};
}

int ExampleAlbumModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_items.count();
}

QHash<int, QByteArray> ExampleAlbumModel::roleNames() const
{
    return {
        {SourceRole, QByteArrayLiteral("source")},
        {TempSourceRole, QByteArrayLiteral("tempSource")},
        {TypeRole, QByteArrayLiteral("type")},
        {CaptionRole, QByteArrayLiteral("caption")},
    };
}
