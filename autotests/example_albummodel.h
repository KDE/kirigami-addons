// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

#pragma once

#include <QAbstractListModel>
#include <QUrl>

/**
 * @class ItemObject
 *
 * An example QObject containing the minimum required properties for AlbumMaximizeComponent.
 */
class ItemObject : public QObject
{
    Q_OBJECT

    /**
     * @brief The source for the item.
     */
    Q_PROPERTY(QUrl source READ source CONSTANT)

    /**
     * @brief The width of the item.
     */
    Q_PROPERTY(qreal sourceWidth READ sourceWidth CONSTANT)

    /**
     * @brief The height of the item.
     */
    Q_PROPERTY(qreal sourceHeight READ sourceHeight CONSTANT)

    /**
     * @brief Source for the temporary content.
     *
     * Typically used when downloading the image to show a thumbnail or other
     * temporary image while the main image downloads.
     */
    Q_PROPERTY(QUrl tempSource READ tempSource CONSTANT)

    /**
     * @brief The delegate type that should be shown for this item.
     *
     * @sa Type
     */
    Q_PROPERTY(Type type READ type CONSTANT)

    /**
     * @brief The caption for the item.
     *
     * Typically set to the filename if no caption is available.
     */
    Q_PROPERTY(QString caption READ caption CONSTANT)

public:
    /**
     * @brief The media type for the album item.
     */
    enum Type {
        Image = 0, /**< The media has an image or animated image mime type. */
        Video, /**< The media has a video mime type. */
    };
    Q_ENUM(Type);

    ItemObject(QObject *parent = nullptr,
               QUrl source = {},
               qreal sourceWidth = {},
               qreal sourceHeight = {},
               QUrl tempSource = {},
               Type type = Type::Image,
               QString caption = {})
        : QObject(parent)
        , m_source(source)
        , m_sourceWidth(sourceWidth)
        , m_sourceHeight(sourceHeight)
        , m_tempSource(tempSource)
        , m_type(type)
        , m_caption(caption)
    {
    };

    QUrl source () const {return m_source;}
    qreal sourceWidth() const {return m_sourceWidth;}
    qreal sourceHeight() const {return m_sourceHeight;}
    QUrl tempSource () const {return m_tempSource;}
    Type type () const {return m_type;}
    QString caption () const {return m_caption;}

private:
    QUrl m_source;
    qreal m_sourceWidth;
    qreal m_sourceHeight;
    QUrl m_tempSource;
    Type m_type;
    QString m_caption;
};
Q_DECLARE_METATYPE(ItemObject *)

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
    Q_PROPERTY(QUrl testImage READ testImage WRITE setTestImage NOTIFY testImageChanged)

    /**
     * @brief The source for any videos in the model.
     *
     * @note This is just an easy interface to allow the data to be set from QML for
     *       writing tests. In an actual implementation the data can come from anywhere.
     */
    Q_PROPERTY(QUrl testVideo READ testVideo WRITE setTestVideo NOTIFY testVideoChanged)

public:
    /**
     * @brief Defines the model roles.
     */
    enum Roles {
        /**
         * @brief The source for the item.
         */
        SourceRole = Qt::DisplayRole,
        SourceWidthRole,
        SourceHeightRole,
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
     * @brief Define the data required to represent a model item.
     */
    struct Item {
        QUrl source; /**< The source for the item. */
        QUrl tempSource; /**< Source for the temporary content. */
        ItemObject::Type type; /**< The delegate type that should be shown for this item. */
        QString caption; /**< The caption for the item. */
    };

    ExampleAlbumModel(QObject *parent = nullptr);

    QUrl testImage() const;
    void setTestImage(QUrl image);

    QUrl testVideo() const;
    void setTestVideo(QUrl image);

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
    QList<ItemObject *> m_items;

    QUrl m_testImage;
    QUrl m_testVideo;

    void resetModel();
};
