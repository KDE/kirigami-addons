// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0
import Qt.labs.qmlmodels 1.0

import org.kde.kirigami 2.15 as Kirigami

/**
 * @brief A popup that covers the entire window to show an album of 1 or more media items.
 *
 * The component supports a model with one or more media components (images or
 * videos) which can be scrolled through.
 *
 * Example:
 * @code
 * Components.AlbumMaximizeComponent {
 *  id: root
 *  property list<AlbumModelItem> model: [
 *      AlbumModelItem {
 *          type: AlbumModelItem.Image
 *          source: "path/to/source"
 *          tempSource: "path/to/tempSource"
 *          caption: "caption text"
 *      },
 *      AlbumModelItem {
 *          type: AlbumModelItem.Video
 *          source: "path/to/source"
 *          tempSource: "path/to/tempSource"
 *          caption: "caption text"
 *      }
 *  ]
 *  initialIndex: 0
 *  model: model
 * }
 * @endcode
 *
 * @note The model doesn't have to be create using AlbumModelItem, it just
 *       requires the same roles (i.e. type, source, tempSource (optional) and
 *       caption (optional)).
 *
 * @inherit AbstractMaximizeComponent
 */
AbstractMaximizeComponent {
    id: root

    /**
     * @brief Model containing the media item to be shown.
     *
     * The model can be either a qml or a c++ model but each item needs to have the
     * values defined in AlbumModelItem.qml (note a list of these is the easiest
     * way to create a qml model).
     */
    property var model

    /**
     * @brief The index of the initial item that should be visible.
     */
    property int initialIndex: -1

    /**
     * @brief Whether the caption should be shown.
     */
    property bool showCaption: true

    /**
     * @brief Emitted when the content image is right clicked.
     */
    signal itemRightClicked()

    /**
     * @brief Emitted when the save item button is pressed.
     *
     * The application needs use this signal to trigger the process to save the
     * file.
     */
    signal saveItem()

    actions: [
        Kirigami.Action {
            text: i18n("Zoom in")
            icon.name: "zoom-in"
            onTriggered: view.currentItem.scaleFactor = Math.min(view.currentItem.scaleFactor + 0.25, 3)
        },
        Kirigami.Action {
            text: i18n("Zoom out")
            icon.name: "zoom-out"
            onTriggered: view.currentItem.scaleFactor = Math.max(view.currentItem.scaleFactor - 0.25, 0.25)
        },
        Kirigami.Action {
            visible: view.currentItem.type === AlbumModelItem.Image
            text: i18n("Rotate left")
            icon.name: "image-rotate-left-symbolic"
            onTriggered: view.currentItem.rotationAngle = view.currentItem.rotationAngle - 90
        },
        Kirigami.Action {
            visible: view.currentItem.type === AlbumModelItem.Image
            text: i18n("Rotate right")
            icon.name: "image-rotate-right-symbolic"
            onTriggered: view.currentItem.rotationAngle = view.currentItem.rotationAngle + 90
        },
        Kirigami.Action {
            text: i18n("Save as")
            icon.name: "document-save"
            onTriggered: saveItem()
        }
    ]

    content: ListView {
        id: view
        Layout.fillWidth: true
        Layout.fillHeight: true
        interactive: count > 1
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 0
        focus: true
        keyNavigationEnabled: true
        keyNavigationWraps: true
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
                    width: ListView.view.width
                    height: ListView.view.height

                    onItemRightClicked: root.itemRightClicked()
                    onBackgroundClicked: root.close()
                }
            }
        }

        QQC2.RoundButton {
            anchors {
                left: parent.left
                leftMargin: Kirigami.Units.largeSpacing
                verticalCenter: parent.verticalCenter
            }
            width: Kirigami.Units.gridUnit * 2
            height: width
            icon.name: "arrow-left"
            visible: !Kirigami.Settings.isMobile && view.currentIndex > 0
            Keys.forwardTo: view
            Accessible.name: i18n("Previous image")
            onClicked: view.currentIndex -= 1
        }
        QQC2.RoundButton {
            anchors {
                right: parent.right
                rightMargin: Kirigami.Units.largeSpacing
                verticalCenter: parent.verticalCenter
            }
            width: Kirigami.Units.gridUnit * 2
            height: width
            icon.name: "arrow-right"
            visible: !Kirigami.Settings.isMobile && view.currentIndex < view.count - 1
            Keys.forwardTo: view
            Accessible.name: i18n("Next image")
            onClicked: view.currentIndex += 1
        }
    }

    footer: QQC2.Control {
        visible: root.showCaption && view.currentItem.caption
        contentItem: QQC2.ScrollView {
            anchors.fill: parent
            QQC2.ScrollBar.horizontal.policy: QQC2.ScrollBar.AlwaysOff
            QQC2.ScrollBar.vertical.policy: QQC2.ScrollBar.AlwaysOn

            contentItem: QQC2.Label {
                id: captionLabel
                wrapMode: Text.WordWrap
                text: view.currentItem.caption
                padding: Kirigami.Units.largeSpacing
                width: root.width - padding * 2
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
