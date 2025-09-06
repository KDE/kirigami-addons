// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

/*!
   \qmltype ImageMaximizeDelegate
   \inqmlmodule org.kde.kirigamiaddons.labs.components
 */
Item {
    id: root

    /*!
       \brief The source for the image to be viewed.
     */
    required property string source

    /*!
       \brief The size of the source image.

       This is used to calculate the maximum size of the content and temporary image.
     */
    required property real sourceWidth

    /*!
       \brief The size of the source image.

       This is used to calculate the maximum size of the content and temporary image.
     */
    required property real sourceHeight

    /*!
       \brief Source for the temporary content.

       Typically used when downloading the image to show a thumbnail or other
       temporary image while the main image downloads.
     */
    required property string tempSource

    /*!
       \brief The caption for the item.

       Typically set to the filename if no caption is available.

       \note Declared here so that parent components can access this parameter
             when used as a ListView delegate.
     */
    required property string caption

    /*!
       \brief The delegate type for this item.

       \note Declared here so that parent components can access this parameter
             when used as a ListView delegate.
     */
    readonly property int type: AlbumModelItem.Image

    /*!
       \brief The padding around the content image.

       The padding is factored in when calculating the maximum size of the content
       image.
       \default Kirigami.Units.largeSpacing
     */
    property var padding: Kirigami.Units.largeSpacing

    /*!
       \brief Multiple by which the image is scaled.
       \default 1
     */
    property var scaleFactor: 1

    /*!
       \brief The angle by which the content image is rotated.
       \default 0
     */
    property int rotationAngle: 0

    /*!
       \qmlsignal ImageMaximizeDelegate::backgroundClicked
       \brief Emitted when the background space around the content item is clicked.
     */
    signal backgroundClicked()

    /*!
       \qmlsignal ImageMaximizeDelegate::itemRightClicked
       \brief Emitted when the content image is right clicked.
     */
    signal itemRightClicked()

    /*!
       \brief Start media playback.
     */
    function play() {
        image.paused = false
    }

    /*!
       \brief Pause media playback.
     */
    function pause() {
        image.paused = true
    }

    clip: true

    // AnimatedImage so we can handle GIFs.
    AnimatedImage {
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

        anchors.centerIn: parent

        source: root.source

        width: root.rotationAngle % 180 === 0 ? rotationInsensitiveWidth : rotationInsensitiveHeight
        height: root.rotationAngle % 180 === 0 ? rotationInsensitiveHeight : rotationInsensitiveWidth
        fillMode: Image.PreserveAspectFit
        clip: true
        autoTransform: true

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
