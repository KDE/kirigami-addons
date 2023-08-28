// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.15 as Kirigami

/**
 * @brief An button that represents a user, either with initials, an icon, or a profile image.
 */
QQC2.AbstractButton {
    id: root

    /**
     * @brief This property holds the given name of a user.
     * @see org:kde::kirigamiaddons::components::Avatar::source
     */
    property alias name: avatar.name

    /**
     * @brief This property holds avatar's icon source.
     * @see org:kde::kirigamiaddons::components::Avatar::source
     */
    property alias source: avatar.source

    /**
     * @brief This property holds how the button should represent the user when no user-set image is available.
     * @see org:kde::kirigamiaddons::components::Avatar::initialsMode
     */
    property alias initialsMode: avatar.initialsMode

    /**
     * @brief This property holds how the avatar should be shown.
     * @see org:kde::kirigamiaddons::components::Avatar::imageMode
     */
    property alias imageMode: avatar.imageMode

    /**
     * @brief This property sets whether the provided image should be cached.
     * @see QtQuick.Image::cache
     */
    property alias cache: avatar.cache

    /**
     * @brief This property holds the source size of the user's profile picture.
     */
    property alias sourceSize: avatar.sourceSize

    /**
     * @brief This property holds the color to use for this avatar.
     */
    property alias color: avatar.color

    /**
     * @brief This property holds the color of the avatar's initials.
     */
    property alias initialsColor: avatar.initialsColor

    /**
     * @brief This property holds the default color of the avatar's initials.
     */
    readonly property alias defaultInitialsColor: avatar.defaultInitialsColor

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
