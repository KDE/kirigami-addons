// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import Qt.labs.qmlmodels

import org.kde.kirigami as Kirigami
import org.kde.kirigami.private.polyfill // remove once we depend on Qt 6.9
import org.kde.kirigamiaddons.components as KirigamiComponents

/*!
   \qmltype AlbumMaximizeComponent
   \inqmlmodule org.kde.kirigamiaddons.labs.components
   \brief A popup that covers the entire window to show an album of one or more media items.

   The component supports a model with one or more media components (images or
   videos) which can be scrolled through.

   Example:
   \qml
   Components.AlbumMaximizeComponent {
    id: root
    property list<AlbumModelItem> model: [
        AlbumModelItem {
            type: AlbumModelItem.Image
            source: "path/to/source"
            tempSource: "path/to/tempSource"
            caption: "caption text"
        },
        AlbumModelItem {
            type: AlbumModelItem.Video
            source: "path/to/source"
            tempSource: "path/to/tempSource"
            caption: "caption text"
        }
    ]
    initialIndex: 0
    model: model
   }
   \endqml

   \note The model doesn't have to be create using AlbumModelItem, it just
         requires the same roles (i.e. type, source, tempSource (optional) and
         caption (optional)).
 */
AbstractMaximizeComponent {
    id: root

    /*!
       \brief Model containing the media item to be shown.

       The model can be either a qml or a c++ model but each item needs to have the
       values defined in AlbumModelItem (note a list of these is the easiest
       way to create a qml model).
     */
    property var model

    /*!
       \brief The index of the initial item that should be visible.
       \default -1
     */
    property int initialIndex: -1

    /*!
       \brief Whether the caption should be shown.
       \default true
     */
    property bool showCaption: true

    /*!
       \brief Whether the caption is hidden by the user.
       \default false
     */
    property bool hideCaption: false

    /*!
       \brief Whether any video media should auto-load.

       \deprecated due to changes in the Video API this will be removed in KF6. It
                   currently does nothing but is kept to avoid breakage. The loss
                   of this API has been worked around in a way that doesn't break KF5.
       \default true
     */
    property bool autoLoad: true

    /*!
       \brief Whether any video media should auto-play.
       \default true
     */
    property bool autoPlay: true

    /*!
       \brief The default action triggered when the video download button is pressed.

       The download button is only available when the video source is empty (i.e. QUrl()
       or "")

       This exists as a property so that the default action can be overridden. The most
       common use case for this is where a custom URI scheme is used for example.

       \sa DownloadAction
     */
    property DownloadAction downloadAction

    /*!
       \brief The default action triggered when the play button is pressed.

       This exists as a property so that the action can be overridden. For example
       if you want to be able to interface with a media manager.
     */
    property Kirigami.Action playAction

    /*!
       \brief The default action triggered when the pause button is pressed.

       This exists as a property so that the action can be overridden. For example
       if you want to be able to interface with a media manager.
     */
    property Kirigami.Action pauseAction

    /*!
       \qmlproperty Item currentItem
       \brief The current Item in the view.
     */
    property alias currentItem: view.currentItem

    /*!
       \qmlproperty int currentIndex
       \brief The current index in the view.
       \since 1.7.0
     */
    property alias currentIndex: view.currentIndex

    /*!
       \brief Emitted when the content image is right clicked.
     */
    signal itemRightClicked()

    /*!
       \brief Emitted when the save item button is pressed.

       The application needs use this signal to trigger the process to save the
       file.
     */
    signal saveItem()

    actions: [
        Kirigami.Action {
            text: i18nd("kirigami-addons6", "Zoom in")
            icon.name: "zoom-in"
            onTriggered: view.currentItem.scaleFactor = Math.min(view.currentItem.scaleFactor + 0.25, 3)
        },
        Kirigami.Action {
            text: i18nd("kirigami-addons6", "Zoom out")
            icon.name: "zoom-out"
            onTriggered: view.currentItem.scaleFactor = Math.max(view.currentItem.scaleFactor - 0.25, 0.25)
        },
        Kirigami.Action {
            visible: view.currentItem.type === AlbumModelItem.Image
            text: i18nd("kirigami-addons6", "Rotate left")
            icon.name: "object-rotate-left"
            onTriggered: view.currentItem.rotationAngle = view.currentItem.rotationAngle - 90
        },
        Kirigami.Action {
            visible: view.currentItem.type === AlbumModelItem.Image
            text: i18nd("kirigami-addons6", "Rotate right")
            icon.name: "object-rotate-right"
            onTriggered: view.currentItem.rotationAngle = view.currentItem.rotationAngle + 90
        },
        Kirigami.Action {
            text: hideCaption ? i18ndc("kirigami-addons6", "@action:intoolbar", "Show caption") : i18ndc("kirigami-addons6", "@action:intoolbar", "Hide caption")
            icon.name: "add-subtitle"
            visible: root.showCaption && view.currentItem.caption
            onTriggered: hideCaption = !hideCaption
        },
        Kirigami.Action {
            text: i18nd("kirigami-addons6", "Save as")
            icon.name: "document-save"
            onTriggered: saveItem()
        }
    ]

    content: ListView {
        id: view
        Layout.fillWidth: true
        Layout.fillHeight: true
        interactive: !hoverHandler.hovered && count > 1
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 0
        focus: true
        keyNavigationEnabled: true
        keyNavigationWraps: false
        model: root.model
        orientation: ListView.Horizontal
        clip: true
        delegate: DelegateChooser {
            role: "type"
            DelegateChoice {
                roleValue: AlbumModelItem.Image
                ImageMaximizeDelegate {
                    width: ListView.view.width
                    height: ListView.view.height

                    onItemRightClicked: root.itemRightClicked()
                    onBackgroundClicked: root.close()
                }
            }
            DelegateChoice {
                roleValue: AlbumModelItem.Video
                VideoMaximizeDelegate {
                    id: videoMaximizeDelegate
                    width: ListView.view.width
                    height: ListView.view.height

                    autoPlay: root.autoPlay
                    // Make sure that the default action in the delegate is used if not overridden
                    downloadAction: root.downloadAction ? root.downloadAction : undefined
                    StateGroup {
                        states: State {
                            when: root.playAction
                            PropertyChanges {
                                target: videoMaximizeDelegate
                                playAction: root.playAction
                            }
                        }
                    }
                    StateGroup {
                        states: State {
                            when: root.pauseAction
                            PropertyChanges {
                                target: videoMaximizeDelegate
                                pauseAction: root.pauseAction
                            }
                        }
                    }

                    onItemRightClicked: root.itemRightClicked()
                    onBackgroundClicked: root.close()
                }
            }
        }

        KirigamiComponents.FloatingButton {
            anchors {
                left: parent.left
                leftMargin: Kirigami.Units.largeSpacing
                verticalCenter: parent.verticalCenter
            }
            icon.name: "arrow-left"
            visible: !Kirigami.Settings.hasTransientTouchInput && view.currentIndex > 0
            Keys.forwardTo: view
            Accessible.name: i18nd("kirigami-addons6", "Previous image")
            onClicked: {
                view.currentItem.pause()
                view.currentIndex -= 1
                if (root.autoPlay && view.currentItem.playAction) {
                    view.currentItem.playAction.trigger()
                }
            }
        }
        KirigamiComponents.FloatingButton {
            anchors {
                right: parent.right
                rightMargin: Kirigami.Units.largeSpacing
                verticalCenter: parent.verticalCenter
            }
            icon.name: "arrow-right"
            visible: !Kirigami.Settings.hasTransientTouchInput && view.currentIndex < view.count - 1
            Keys.forwardTo: view
            Accessible.name: i18nd("kirigami-addons6", "Next image")
            onClicked: {
                view.currentItem.pause()
                view.currentIndex += 1
                if (root.autoPlay && view.currentItem.playAction) {
                    view.currentItem.playAction.trigger()
                }
            }
        }
        HoverHandler {
            id: hoverHandler
            acceptedDevices: PointerDevice.Mouse
        }
    }

    footer: QQC2.Control {
        visible: root.showCaption && view.currentItem.caption && !root.hideCaption
        leftPadding: root.parent.SafeArea.margins.left
        rightPadding: root.parent.SafeArea.margins.right
        bottomPadding: root.parent.SafeArea.margins.bottom
        contentItem: QQC2.ScrollView {
            anchors.fill: parent
            QQC2.ScrollBar.vertical.policy: QQC2.ScrollBar.AlwaysOn
            QQC2.ScrollBar.horizontal.policy: QQC2.ScrollBar.AsNeeded
            contentWidth: captionLabel.width - captionLabel.padding * 2
            contentItem: Flickable {
                width: root.width
                height: parent.height
                contentWidth: captionLabel.width
                contentHeight: captionLabel.height

                Kirigami.SelectableLabel {
                    id: captionLabel
                    wrapMode: Text.WordWrap
                    text: view.currentItem.caption
                    padding: Kirigami.Units.largeSpacing
                    width: root.width - padding * 2
                }
            }
        }

        background: Rectangle {
            color: Kirigami.Theme.alternateBackgroundColor
        }

        Kirigami.Separator {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.top
            }
            height: 1
        }
    }

    parent: applicationWindow().overlay
    closePolicy: QQC2.Popup.CloseOnEscape
    width: parent.width
    height: parent.height
    modal: true
    padding: 0
    background: Item {}

    onAboutToShow: {
        if (root.initialIndex != -1 && root.initialIndex >= 0) {
            view.currentIndex = initialIndex
        }
    }
}
