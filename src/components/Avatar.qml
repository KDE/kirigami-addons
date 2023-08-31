/*
 *  SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
 *  SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Window 2.15
import org.kde.kirigami 2.15 as Kirigami
import org.kde.kirigamiaddons.components 1.0 as Components

/**
 * @brief An element that represents a user, either with initials, an icon, or a profile image.
 * @inherit QtQuick.Item
 */
Item {
    id: root

    enum ImageMode {
        AlwaysShowImage,
        AdaptiveImageOrInitals,
        AlwaysShowInitials
    }

    enum InitialsMode {
        UseInitials,
        UseIcon
    }

//BEGIN properties
    /**
     * @brief This property holds the given name of a user.
     *
     * The user's name will be used for generating initials and to provide the
     * accessible name for assistive technology.
     */
    property string name

    /**
     * @brief This property holds the source of the user's profile picture; an image.
     * @see QtQuick.Image::source
     * @property url source
     */
    property alias source: avatarImage.source

    /**
     * @brief This property holds avatar's icon source.
     *
     * This icon  is displayed when using an icon with ``Avatar.InitialsMode.UseIcon`` and
     * ``Avatar.ImageNode.AlwaysShowInitials`` enabled.
     *
     * @see org::kde::kirigami::Icon::source
     * @property var iconSource
     */
    property alias iconSource: avatarIcon.source

    /**
     * @brief This property holds how the button should represent the user when no user-set image is available.
     *
     * Possible values are:
     * * ``Avatar.InitialsMode.UseInitials``: Show the user's initials.
     * * ``Avatar.InitialsMode.UseIcon``: Show a generic icon.
     *
     * @see org::kde::kirigamiaddons::components::Avatar::InitialsMode
     */
    property int initialsMode: Avatar.InitialsMode.UseInitials

    /**
     * @brief This property holds how the avatar should be shown.
     *
     * This property holds whether the button should always show the image; show the image if one is
     * available and show initials when it is not; or always show initials.
     *
     * Possible values are:
     * * ``Avatar.ImageMode.AlwaysShowImage``: Always try to show the image; even if it hasn't loaded yet or is undefined.
     * * ``Avatar.ImageMode.AdaptiveImageOrInitals``: Show the image if it is valid; or show initials if it is not
     * * ``Avatar.ImageMode.AlwaysShowInitials``: Always show initials
     *
     * @see org::kde::kirigamiaddons::components::Avatar::ImageMode
     */
    property int imageMode: Avatar.ImageMode.AdaptiveImageOrInitals

    /**
     * @brief This property sets whether the provided image should be cached.
     * @see QtQuick.Image::cache
     * @property bool cache
     */
    property alias cache: avatarImage.cache

    /**
     * @brief This property holds the source size of the user's profile picture.
     * @see QtQuick.Image::sourceSize
     * @property int sourceSize
     */
    property alias sourceSize: avatarImage.sourceSize

    /**
     * @brief This property holds the color to use for this avatar.
     *
     * If not explicitly set, this defaults to generating a color from the name.
     *
     * @property color color
     */
    property color color: Components.NameUtils.colorsFromString(name)

    /**
     * @brief This property holds the color of the avatar's initials.
     *
     * If not explicitly set, this defaults to defaultInitialsColor.
     *
     * @see defaultInitialsColor
     * @property color initialsColor
     */
    property color initialsColor: defaultInitialsColor

    /**
     * @brief This property holds the default color of the avatar's initials.
     *
     * It depends on the avatar's color.
     *
     * @property color defaultInitialsColor
     */
    readonly property alias defaultInitialsColor: root.__textColor

    implicitWidth: Kirigami.Units.iconSizes.large
    implicitHeight: Kirigami.Units.iconSizes.large

    Accessible.role: Accessible.Graphic
    Accessible.name: name

    readonly property real __diameter: Math.min(root.width, root.height)

    readonly property color __textColor: Kirigami.ColorUtils.brightnessForColor(root.color) === Kirigami.ColorUtils.Light
                            ? "black"
                            : "white"

    readonly property bool __showImage: {
        switch (root.imageMode) {
        case Avatar.ImageMode.AlwaysShowImage:
            return true;
        case Avatar.ImageMode.AdaptiveImageOrInitals:
            return avatarImage.status === Image.Ready;
        case Avatar.ImageMode.AlwaysShowInitials:
        default:
            return false;
        }
    }

    Item {
        anchors.centerIn: parent

        width: root.__diameter
        height: root.__diameter

        Text {
            anchors.fill: parent

            visible: root.initialsMode === Avatar.InitialsMode.UseInitials &&
                    !root.__showImage &&
                    !Components.NameUtils.isStringUnsuitableForInitials(root.name) &&
                    root.width > Kirigami.Units.gridUnit

            text: Components.NameUtils.initialsFromString(root.name)
            color: root.color

            font {
                // this ensures we don't get a both point and pixel size are set warning
                pointSize: -1
                pixelSize: Math.round((root.height - Kirigami.Units.largeSpacing) / 2)
            }
            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Kirigami.Icon {
            id: avatarIcon

            anchors.fill: parent
            anchors.margins: Kirigami.Units.largeSpacing

            visible: !root.__showImage
                && (root.initialsMode === Avatar.InitialsMode.UseIcon
                    || Components.NameUtils.isStringUnsuitableForInitials(root.name))

            color: root.__textColor
            source: "user"
        }

        Image {
            id: avatarImage

            anchors.fill: parent

            visible: root.__showImage

            fillMode: Image.PreserveAspectCrop
            mipmap: true
            sourceSize {
                width: root.__diameter * root.Screen.devicePixelRatio
                height: root.__diameter * root.Screen.devicePixelRatio
            }
        }

        layer {
            enabled: true
            effect: Kirigami.ShadowedTexture {
                radius: root.__diameter

                border {
                    width: root.__showImage ? 0 : 1.25
                    color: root.color
                }

                color: Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, border.color, 0.07)
            }
        }
    }
}
