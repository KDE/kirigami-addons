// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick

/*!
   \qmltype AlbumModelItem
   \inqmlmodule org.kde.kirigamiaddons.labs.components
   \brief An object container for defining content items to show in an AlbumMaximizeComponent.

   The intended use is that a list of these can be used as the ListView model for
   a AlbumMaximizeComponent.

   Example definition:
   \qml
   property list<AlbumModelItem> model: [
        AlbumModelItem {
            type: AlbumModelItem.Image
            source: "path/to/source"
            tempSource: "path/to/tempSource"
        },
        AlbumModelItem {
            type: AlbumModelItem.Video
            source: "path/to/source"
            tempSource: "path/to/tempSource"
        }
   ]
   \endqml

 */
QtObject {
    id: root

    enum Type {
        Image,
        Video
    }

    /*!
       \brief The delegate type that should be shown for this item.

       Possible values:
       \value AlbumModelItem.Image
              Show an image delegate (including GIFs).
       \value AlbumModelItem.Video
              Show a video delegate.
     */
    property int type

    /*!
       \brief The source for the item.
     */
    property string source

    /*!
       \brief Source for the temporary content.

       Typically used when downloading the image to show a thumbnail or other
       temporary image while the main image downloads.
       \default ""
     */
    property string tempSource: ""

    /*!
       \brief The caption for the item.

       Typically set to the filename if no caption is available.
       \default ""
     */
    property string caption: ""

    /*!
       \brief The height of the source image.

       Used to calculate the aspect ratio of the image.
       \default 0
     */
    property real sourceHeight: 0

    /*!
       \brief The width of the source image.

       Used to calculate the aspect ratio of the image.
       \default 0
     */
    property real sourceWidth: 0
}
