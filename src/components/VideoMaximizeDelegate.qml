// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import QtMultimedia

import org.kde.kirigami as Kirigami

/*!
   \qmltype VideoMaximizeDelegate
   \inqmlmodule org.kde.kirigamiaddons.labs.components
 */
Item {
    id: root

    /*!
       \brief The source for the image to be viewed.
     */
    required property string source

    /*!
       \brief Source for the temporary content.

       Typically used when downloading the image to show a thumbnail or other
       temporary image while the main image downloads.
     */
    required property string tempSource

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
    readonly property int type: AlbumModelItem.Video

    /*!
       \brief Whether the source video should auto-load.

       \deprecated due to changes in the Video API this will be removed in KF6. It
                   currently does nothing but is kept to avoid breakage. The loss
                   of this API has been worked around in a way that doesn't break KF5.
     */
    property bool autoLoad

    /*!
       \brief Whether the source video should auto-play.
     */
    property bool autoPlay

    /*!
       \brief The default action triggered when the download button is pressed.

       This exists as a property so that the action can be overridden. The most common
       use case for this is where a custom URI scheme is used.
     */
    property DownloadAction downloadAction: DownloadAction {
        onTriggered: videoItem.play()
    }

    /*!
       \brief The default action triggered when the play button is pressed.

       This exists as a property so that the action can be overridden. For example
       if you want to be able to interface with a media manager.
     */
    property Kirigami.Action playAction: Kirigami.Action {
        onTriggered: videoItem.play()
    }

    /*!
       \brief The default action triggered when the pause button is pressed.

       This exists as a property so that the action can be overridden. For example
       if you want to be able to interface with a media manager.
     */
    property Kirigami.Action pauseAction: Kirigami.Action {
        onTriggered: videoItem.pause()
    }

    /*!
       \qmlproperty enumeration playbackState
       \brief The playback state of the media.
       \value MediaPlayer.PlayingState
              The media is playing.
       \value MediaPlayer.PausedState
              The media is paused.
       \value MediaPlayer.StoppedState
              The media is stopped.
       \sa {QtMultimedia::MediaPlayer::playbackState} {QtMultimedia.MediaPlayer.playBackState}
     */
    property alias playbackState: videoItem.playbackState

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
       \brief Emitted when the background space around the content item is clicked.
     */
    signal backgroundClicked()

    /*!
       \brief Emitted when the content image is right clicked.
     */
    signal itemRightClicked()

    /*!
       \brief Start media playback.
     */
    function play() {
        videoItem.play()
    }

    /*!
       \brief Pause media playback.
     */
    function pause() {
        videoItem.pause()
    }

    clip: true

    Video {
        id: videoItem

        anchors.centerIn: parent
        width: {
            if (root.sourceWidth > 0 ) {
                return Math.min(root.sourceWidth, root.width - root.padding * 2)
            } else if (metaData.resolution && metaData.resolution.width) {
                return Math.min(metaData.resolution.width, root.width - root.padding * 2)
            } else {
                return 0
            }
        }
        height: {
            if (root.sourceHeight > 0 ) {
                return Math.min(root.sourceHeight, root.height - root.padding * 2)
            } else if (metaData.resolution && metaData.resolution.height) {
                return Math.min(metaData.resolution.height, root.height - root.padding * 2)
            } else {
                return 0
            }
        }

        source: root.source
        onSourceChanged: {
            if (source.toString().length > 0 && root.autoPlay && root.index === root.ListView.view.currentIndex) {
                root.playAction.trigger()
            }
        }

        Component.onDestruction: videoItem.stop()

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
            width: root.sourceWidth > 0 || (videoItem.metaData.resolution && videoItem.metaData.resolution.width > 0) ? root.sourceWidth : tempImage.sourceSize.width
            height: root.sourceHeight > 0 || (videoItem.metaData.resolution && videoItem.metaData.resolution.height > 0) ? root.sourceHeight : tempImage.sourceSize.height
            visible: source && status === Image.Ready && !videoItem.source.toString().length > 0

            source: root.tempSource
        }

        QQC2.ProgressBar {
            anchors.centerIn: parent
            visible: root.downloadAction.started && !root.downloadAction.completed
            width: videoItem.width * 0.8

            from: 0.0
            to: 100.0
            value: root.downloadAction.progress
        }

        QQC2.Button {
            anchors.centerIn: parent
            icon.width: Kirigami.Units.iconSizes.large
            icon.height: Kirigami.Units.iconSizes.large
            visible: !videoItem.source.toString().length > 0 && !root.downloadAction.started
            display: QQC2.AbstractButton.IconOnly
            action: root.downloadAction
        }

        transform: [
            Scale {
                origin.x: videoItem.width / 2
                origin.y: videoItem.height / 2
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

        QQC2.Control {
            id: videoControls
            anchors.bottom: videoItem.bottom
            anchors.left: videoItem.left
            anchors.right: videoItem.right
            visible: videoArea.hovered || volumePopupHoverHandler.hovered || volumeSlider.hovered || videoControlTimer.running

            contentItem: RowLayout {
                id: controlRow
                QQC2.ToolButton {
                    id: playButton
                    z: 1
                    icon.name: videoItem.playbackState === MediaPlayer.PlayingState ? "media-playback-pause" : "media-playback-start"
                    action: videoItem.playbackState === MediaPlayer.PlayingState ? root.pauseAction : root.playAction
                }
                QQC2.Slider {
                    Layout.fillWidth: true
                    from: 0
                    to: videoItem.duration
                    value: videoItem.position
                    onMoved: videoItem.seek(value)
                }
                QQC2.Label {
                    text: root.getTimeString(videoItem.position) + "/" + root.getTimeString(videoItem.duration)
                }
                QQC2.ToolButton {
                    id: volumeButton
                    property var unmuteVolume: videoItem.volume

                    icon.name: videoItem.volume <= 0 ? "player-volume-muted" : "player-volume"

                    QQC2.ToolTip.visible: hovered
                    QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                    QQC2.ToolTip.timeout: Kirigami.Units.toolTipDelay
                    QQC2.ToolTip.text: i18ndc("kirigami-addons6", "@action:button", "Volume")

                    onClicked: {
                        if (videoItem.volume > 0) {
                            videoItem.volume = 0
                        } else {
                            if (unmuteVolume === 0) {
                                videoItem.volume = 1
                            } else {
                                videoItem.volume = unmuteVolume
                            }
                        }
                    }
                    onHoveredChanged: {
                        if (!hovered) {
                            videoControlTimer.restart()
                            volumePopupTimer.restart()
                        }
                    }

                    QQC2.Popup {
                        id: volumePopup
                        y: -height
                        width: volumeButton.width
                        visible: volumeButton.hovered || volumePopupHoverHandler.hovered || volumeSlider.hovered || volumePopupTimer.running

                        focus: true
                        padding: Kirigami.Units.smallSpacing
                        closePolicy: QQC2.Popup.NoAutoClose

                        QQC2.Slider {
                            id: volumeSlider
                            anchors.centerIn: parent
                            implicitHeight: Kirigami.Units.gridUnit * 7
                            orientation: Qt.Vertical
                            padding: 0
                            from: 0
                            to: 1
                            value: videoItem.volume
                            onMoved: {
                                videoItem.volume = value
                                volumeButton.unmuteVolume = value
                            }
                            onHoveredChanged: {
                                if (!hovered) {
                                    videoControlTimer.restart()
                                    volumePopupTimer.restart()
                                }
                            }
                        }
                        Timer {
                            id: volumePopupTimer
                            interval: 500
                        }
                        HoverHandler {
                            id: volumePopupHoverHandler
                            onHoveredChanged: {
                                if (!hovered) {
                                    videoControlTimer.restart()
                                    volumePopupTimer.restart()
                                }
                            }
                        }
                        background: Kirigami.ShadowedRectangle {
                            radius: Kirigami.Units.cornerRadius
                            color: Kirigami.Theme.backgroundColor
                            opacity: 0.8

                            border.color:  Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, Kirigami.Theme.frameContrast)
                            border.width: 1

                            shadow.xOffset: 0
                            shadow.yOffset: 4
                            shadow.color: Qt.rgba(0, 0, 0, 0.3)
                            shadow.size: 8
                        }
                    }
                }
            }
            background: Kirigami.ShadowedRectangle {
                radius: Kirigami.Units.cornerRadius
                color: Kirigami.Theme.backgroundColor
                opacity: 0.8

                border.color:  Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, Kirigami.Theme.frameContrast)
                border.width: 1

                shadow.xOffset: 0
                shadow.yOffset: 4
                shadow.color: Qt.rgba(0, 0, 0, 0.3)
                shadow.size: 8
            }
        }
        Timer {
            id: videoControlTimer
            interval: 1000
        }

        TapHandler {
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.Stylus
            acceptedButtons: Qt.RightButton
            gesturePolicy: TapHandler.ReleaseWithinBounds

            onTapped: root.itemRightClicked()
        }

        TapHandler {
            acceptedDevices: PointerDevice.TouchScreen
            gesturePolicy: TapHandler.ReleaseWithinBounds

            onLongPressed: root.itemRightClicked()
        }
        HoverHandler {
            id: videoArea
            onHoveredChanged: {
                if (!hovered) {
                    videoControlTimer.restart()
                }
            }
        }
    }
    TapHandler {
        // We don't want this to apply to touch screens, to prevent it from closing too easily.
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.Stylus
        acceptedButtons: Qt.LeftButton
        gesturePolicy: TapHandler.ReleaseWithinBounds

        onTapped: root.backgroundClicked()
    }
    function formatTimer(time){
        return (time < 10 ? "0" : "") + time
    }

    function getTimeString(timeMilliseconds){
        let hours = root.formatTimer(Math.floor(timeMilliseconds/3600000));
        let minutes = root.formatTimer(Math.floor(timeMilliseconds%3600000/60000));
        let seconds = root.formatTimer(Math.floor(timeMilliseconds%60000/1000));

        return (hours + ":" + minutes + ":" + seconds);
    }
}
