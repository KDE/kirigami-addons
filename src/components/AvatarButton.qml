// SPDX-FileCopyrightText: 2023 Carl Schwan <carl\carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.15 as Kirigami

/*!
   \qmltype AvatarButton
   \inqmlmodule org.kde.kirigamiaddons.labs.components
   \brief An button that represents a user, either with initials, an icon, or a profile image.
 */
QQC2.AbstractButton {
    id: root

    /*!
       \qmlproperty string name
       \brief This property holds the given name of a user.
       \sa {Avatar::name} {Avatar.name}
     */
    property alias name: avatar.name

    /*!
       \qmlproperty url source
       \brief This property holds avatar's icon source.
       \sa {Avatar::source} {Avatar.source}
     */
    property alias source: avatar.source

    /*!
       \qmlproperty int initialsMode
       \brief This property holds how the button should represent the user when no user-set image is available.
       \sa {Avatar::initialsMode} {Avatar.initialsMode}
     */
    property alias initialsMode: avatar.initialsMode

    /*!
       \qmlproperty int imageMode
       \brief This property holds how the avatar should be shown.
       \sa {Avatar::imageMode} {Avatar.imageMode}
     */
    property alias imageMode: avatar.imageMode

    /*!
       \qmlproperty bool cache
       \brief This property sets whether the provided image should be cached.
       \sa {Image::cache} {Image.cache}
     */
    property alias cache: avatar.cache

    /*!
       \qmlproperty bool asynchronous
       \brief Load the image asynchronously.
       \sa {Image::asynchronous} {Image.asynchronous}
       \since 1.7.0
     */
    property alias asynchronous: avatar.asynchronous

    /*!
       \qmlproperty int sourceSize
       \brief This property holds the source size of the user's profile picture.
     */
    property alias sourceSize: avatar.sourceSize

    /*!
       \qmlproperty color color
       \brief This property holds the color to use for this avatar.
     */
    property alias color: avatar.color

    /*!
       \qmlproperty color initialsColor
       \brief This property holds the color of the avatar's initials.
     */
    property alias initialsColor: avatar.initialsColor

    /*!
       \qmlproperty color defaultInitialsColor
       \brief This property holds the default color of the avatar's initials.
     */
    readonly property alias defaultInitialsColor: avatar.defaultInitialsColor

    /*!
       \qmlproperty Item clippedContent
       \brief This item holds the parent item on the clipped circle.

       Implementations may add custom graphics which will be clipped along with
       the rest of the avatar content.
     */
    readonly property alias clippedContent: avatar.clippedContent

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    text: name

    padding: 1

    hoverEnabled: true // so the tooltip works

    contentItem: Avatar {
        id: avatar
    }

    background: Rectangle {
        radius: height
        color: Kirigami.Theme.focusColor
        visible: root.visualFocus || root.down
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    QQC2.ToolTip.visible: hovered && text.length > 0
    QQC2.ToolTip.text: text
    QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
}
