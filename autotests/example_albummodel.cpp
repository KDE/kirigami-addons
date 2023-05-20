// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

#include "example_albummodel.h"

#include <QDebug>

ExampleAlbumModel::ExampleAlbumModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

ExampleAlbumModel::~ExampleAlbumModel() = default;

QString ExampleAlbumModel::testImage() const
{
    return m_testImage;
}

void ExampleAlbumModel::setTestImage(QString image)
{
    if (image == m_testImage) {
        return;
    }
    m_testImage = image;
    testImageChanged();

    resetModel();
}

QString ExampleAlbumModel::testVideo() const
{
    return m_testVideo;
}

void ExampleAlbumModel::setTestVideo(QString video)
{
    if (video == m_testVideo) {
        return;
    }
    m_testVideo = video;
    testVideoChanged();

    resetModel();
}

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

void ExampleAlbumModel::resetModel()
{
    beginResetModel();
    m_items.clear();

    // Create dummy data using latest image and video sources.
    m_items.append(Item {
        m_testImage,
        m_testImage,
        Type::Image,
        QStringLiteral("A test image"),
    });
    m_items.append(Item {
        m_testVideo,
        m_testImage,
        Type::Video,
        QStringLiteral("A test video"),
    });
    m_items.append(Item {
        m_testImage,
        m_testImage,
        Type::Image,
        QString(),
    });

    endResetModel();
}
