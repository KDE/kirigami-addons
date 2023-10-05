// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.15

import org.kde.kirigami 2.15 as Kirigami

MaximizeDelegate {
    id: root

    /**
     * @brief The source for the image to be viewed.
     */
    required property string source

    /**
     * @brief The size of the source image.
     *
     * This is used to calculate the maximum size of the content and temporary image.
     */
    required property real sourceWidth

    /**
     * @brief The size of the source image.
     *
     * This is used to calculate the maximum size of the content and temporary image.
     */
    required property real sourceHeight

    /**
     * @brief Source for the temporary content.
     *
     * Typically used when downloading the image to show a thumbnail or other
     * temporary image while the main image downloads.
     */
    required property string tempSource

    /**
     * @brief The caption for the item.
     *
     * Typically set to the filename if no caption is available.
     *
     * @note Declared here so that parent components can access this parameter
     *       when used as a listView delegate.
     */
    required property string caption

    /**
     * @brief The padding around the content image.
     *
     * The padding is factored in when calculating the maximum size of the content
     * image.
     */
    property var padding: Kirigami.Units.largeSpacing

    /**
     * @brief Multiple by which the image is scaled.
     */
    property var scaleFactor: 1

    /**
     * @brief The angle by which the content image is rotated.
     *
     * The default orientation of the image is 0 degrees.
     */
    property int rotationAngle: 0

    /**
     * @brief Start media playback.
     */
    function play() {
        image.paused = false
    }

    /**
     * @brief Pause media playback.
     */
    function pause() {
        image.paused = true
    }

    actions: [
        Kirigami.Action {
            text: i18nd("kirigami-addons", "Zoom in")
            icon.name: "zoom-in"
            onTriggered: root.scaleFactor = Math.min(root.scaleFactor + 0.25, 3)
        },
        Kirigami.Action {
            text: i18nd("kirigami-addons", "Zoom out")
            icon.name: "zoom-out"
            onTriggered: root.scaleFactor = Math.max(root.scaleFactor - 0.25, 0.25)
        },
        Kirigami.Action {
            text: i18nd("kirigami-addons", "Rotate left")
            icon.name: "object-rotate-left"
            onTriggered: root.rotationAngle = root.rotationAngle - 90
        },
        Kirigami.Action {
            text: i18nd("kirigami-addons", "Rotate right")
            icon.name: "object-rotate-right"
            onTriggered: root.rotationAngle = root.rotationAngle + 90
        }
    ]

    // AnimatedImage so we can handle GIFs.
    contentItem: AnimatedImage {
        id: image
        property var rotationInsensitiveWidth: {
            if (sourceWidth > 0) {
                return Math.min(root.sourceWidth, root.width - root.padding * 2);
            } else {
                return Math.min(sourceSize.width, root.width - root.padding * 2);
            }
        }
        property var rotationInsensitiveHeight: {
            if (sourceHeight > 0) {
                return Math.min(root.sourceHeight, root.height - root.padding * 2)
            } else {
                return Math.min(sourceSize.height, root.height - root.padding * 2)
            }
        }

        source: root.source

        width: root.rotationAngle % 180 === 0 ? rotationInsensitiveWidth : rotationInsensitiveHeight
        height: root.rotationAngle % 180 === 0 ? rotationInsensitiveHeight : rotationInsensitiveWidth
        fillMode: Image.PreserveAspectFit
        clip: true

        Behavior on width {
            NumberAnimation {duration: Kirigami.Units.longDuration; easing.type: Easing.InOutCubic}
        }
        Behavior on height {
            NumberAnimation {duration: Kirigami.Units.longDuration; easing.type: Easing.InOutCubic}
        }

        Image {
            id: tempImage
            anchors.centerIn: parent
            visible: source && status === Image.Ready && image.status !== Image.Ready
            width:  root.sourceWidth > 0 || image.sourceSize.width > 0 ? root.sourceWidth : tempImage.sourceSize.width
            height: root.sourceHeight > 0 || image.sourceSize.height > 0 ? root.sourceHeight : tempImage.sourceSize.height
            source: root.tempSource
        }

        transform: [
            Rotation {
                origin.x: image.width / 2
                origin.y: image.height / 2
                angle: root.rotationAngle

                Behavior on angle {
                    RotationAnimation {duration: Kirigami.Units.longDuration; easing.type: Easing.InOutCubic}
                }
            },
            Scale {
                origin.x: image.width / 2
                origin.y: image.height / 2
                xScale: root.scaleFactor
                yScale: root.scaleFactor

                Behavior on xScale {
                    NumberAnimation {duration: Kirigami.Units.longDuration; easing.type: Easing.InOutCubic}
                }
                Behavior on yScale {
                    NumberAnimation {duration: Kirigami.Units.longDuration; easing.type: Easing.InOutCubic}
                }
            }
        ]

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            onClicked: root.itemRightClicked()
        }
    }
}
