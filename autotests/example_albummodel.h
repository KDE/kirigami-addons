// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

#pragma once

#include <QAbstractListModel>

/**
 * @class ExampleAlbumModel
 *
 * This class defines an example model for populating an AlbumMaximizeComponent.
 *
 * This example provides a minimal implementation using a QList of structs with the
 * necessary parameters. This is not important for any implementation, the data
 * can be sourced however the designer desires. Instead you must ensure that your model
 * passes the same 4 roles as a minimum to the AlbumMaximizeComponent.
 *
 * @note All 4 params are required by the QML so they must be populated, even if
 *       only with an empty value.
 */
class ExampleAlbumModel : public QAbstractListModel
{
    Q_OBJECT

    /**
     * @brief The source for any images in the model.
     *
     * @note This is just an easy interface to allow the data to be set from QML for
     *       writing tests. In an actual implementation the data can come from anywhere.
     */
    Q_PROPERTY(QString testImage READ testImage WRITE setTestImage NOTIFY testImageChanged)

    /**
     * @brief The source for any videos in the model.
     *
     * @note This is just an easy interface to allow the data to be set from QML for
     *       writing tests. In an actual implementation the data can come from anywhere.
     */
    Q_PROPERTY(QString testVideo READ testVideo WRITE setTestVideo NOTIFY testVideoChanged)

public:
    /**
     * @brief Defines the model roles.
     */
    enum Roles {
        /**
         * @brief The source for the item.
         */
        SourceRole = Qt::UserRole + 1,
        /**
         * @brief Source for the temporary content.
         *
         * Typically used when downloading the image to show a thumbnail or other
         * temporary image while the main image downloads.
         */
        TempSourceRole,
        /**
         * @brief The delegate type that should be shown for this item.
         *
         * @sa Type
         */
        TypeRole, /**< The delegate type that should be shown for this item. */
        /**
         * @brief The caption for the item.
         *
         * Typically set to the filename if no caption is available.
         */
        CaptionRole,
    };

    /**
     * @brief The media type for the album item.
     */
    enum Type {
        Image = 0, /**< The media has an image or animated image mime type. */
        Video, /**< The media has a video mime type. */
    };

    /**
     * @brief Define the data required to represent a model item.
     */
    struct Item {
        QString source; /**< The source for the item. */
        QString tempSource; /**< Source for the temporary content. */
        Type type; /**< The delegate type that should be shown for this item. */
        QString caption; /**< The caption for the item. */
    };

    ExampleAlbumModel(QObject *parent = nullptr);
    ~ExampleAlbumModel() override;

    QString testImage() const;
    void setTestImage(QString image);

    QString testVideo() const;
    void setTestVideo(QString image);

    /**
     * @brief Get the given role value at the given index.
     *
     * @sa QAbstractItemModel::data
     */
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    /**
     * @brief Number of rows in the model.
     *
     * @sa QAbstractItemModel::rowCount
     */
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    /**
     * @brief Returns a mapping from Role enum values to role names.
     *
     * @sa EventRoles, QAbstractItemModel::roleNames()
     */
    QHash<int, QByteArray> roleNames() const override;

Q_SIGNALS:
    void testImageChanged();
    void testVideoChanged();

private:
    QList<Item> m_items;

    QString m_testImage;
    QString m_testVideo;

    void resetModel();
};
