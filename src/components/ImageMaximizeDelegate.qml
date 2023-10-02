// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.1

import org.kde.kirigami 2.15 as Kirigami

Item {
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
     * @brief The delegate type for this item.
     *
     * @note Declared here so that parent components can access this parameter
     *       when used as a listView delegate.
     */
    readonly property int type: AlbumModelItem.Image

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
     * @brief Emitted when the background space around the content item is clicked.
     */
    signal backgroundClicked()

    /**
     * @brief Emitted when the content image is right clicked.
     */
    signal itemRightClicked()

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

    clip: true

    // AnimatedImage so we can handle GIFs.
    AnimatedImage {
        id: image

        property var rotationInsensitiveWidth: {
            if (root.sourceWidth > 0) {
                return Math.min(root.sourceWidth, root.width - root.padding * 2);
            } else if (implicitWidth > 0){
                return Math.min(implicitWidth, root.width - root.padding * 2);
            } else {
                return root.width - root.padding * 2;
            }
        }
        property var rotationInsensitiveHeight: {
            if (root.sourceHeight > 0) {
                return Math.min(root.sourceHeight, root.height - root.padding * 2)
            } else if (implicitHeight > 0) {
                return Math.min(implicitWidth, root.height - root.padding * 2)
            } else {
                return root.height - root.padding * 2;
            }
        }

        anchors.centerIn: parent

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
            anchors.fill: parent
            visible: source && status === Image.Ready && image.status !== Image.Ready
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
    QQC2.BusyIndicator {
        anchors.centerIn: parent
        visible: image.status !== Image.Ready && tempImage.status !== Image.Ready
        running: visible
    }
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: root.backgroundClicked()
    }
}
