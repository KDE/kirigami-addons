// SPDX-FileCopyrightText: 2021 Jonah Brüchert <jbb@kaidan.im>
// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>
//
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Templates 2.15 as T
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0
import org.kde.kirigami 2.20 as Kirigami

/**
 * SearchField with a Popup to show autocompletion entries or search results
 *
 * @since KirigamiAddons.labs.components 1.0
 */
QQC2.Control {
    id: root

    /**
     * This property holds the content item of the popup.
     *
     * Overflow will be automatically be handled as popupContentItem is
     * contained inside a ScrollView.
     *
     * This is the default element of SearchPopupField.
     *
     * ```qml
     * SearchPopupField {
     *     ListView {
     *         model: SearchModel {}
     *         delegate: QQC2.ItemDelegate {}
     *
     *         Kirigami.PlaceholderMessage {
     *             id: loadingPlaceholder
     *             anchors.centerIn: parent
     *             width: parent.width - Kirigami.Units.gridUnit * 4
     *             // ...
     *         }
     *     }
     * }
     * ```
     *
     * @since KirigamiAddons.labs.components 1.0
     */
    default property alias popupContentItem: scrollView.contentItem

    /**
     * This property holds the text of the search field.
     *
     * @since KirigamiAddons.labs.components 1.0
     */
    property alias text: root.searchField.text

    /**
     * @brief This property sets whether to delay automatic acceptance of the search input.
     *
     * Set this to true if your search is expensive (such as for online
     * operations or in exceptionally slow data sets) and want to delay it
     * for 2.5 seconds.
     *
     * @note If you must have immediate feedback (filter-style), use the
     * text property directly instead of accepted()
     *
     * default: ``false``
     *
     * @since KirigamiAddons.labs.components 1.0
     */
    property alias delaySearch: root.searchField.delaySearch

    /**
     * @brief This property sets whether the accepted signal is fired automatically
     * when the text is changed.
     *
     * Setting this to false will require that the user presses return or enter
     * (the same way a QtQuick.Controls.TextInput works).
     *
     * default: ``false``
     *
     * @since KirigamiAddons.labs.components 1.0
     */
    property alias autoAccept: root.searchField.autoAccept

    /**
     * This property holds whether there is space available on the left.
     *
     * This is used by the left shadow.
     *
     * @since KirigamiAddons.labs.components 1.0
     * @deprecated Was not really used by anything.
     */
    property bool spaceAvailableLeft: true

    /**
     * This property holds whether there is space available on the left.
     *
     * This is used by the right shadow.
     *
     * @since KirigamiAddons.labs.components 1.0
     * @deprecated Was not really used by anything.
     */
    property bool spaceAvailableRight: true

    /**
     * @brief This hold the focus state of the internal SearchField.
    */
    property alias fieldFocus: searchField.focus

    /**
     * This signal is triggered when the user trigger a search.
     */
    signal accepted()

    property alias popup: popup

    property Kirigami.SearchField searchField: Kirigami.SearchField {
        id: searchField
        anchors.left: parent ? parent.left : undefined
        anchors.right: parent ? parent.right : undefined
        selectByMouse: true

        KeyNavigation.tab: scrollView.contentItem
        KeyNavigation.down: scrollView.contentItem

        onActiveFocusChanged: if (activeFocus) {
            // Don't mess with popups and reparenting inside focus change handler.
            // Especially nested popups hate that: it may break all focus management
            // on a scene until restart.
            Qt.callLater(() => {
                // TODO: Kirigami.OverlayZStacking fails to find and bind to
                // parent logical popup when parent item is itself reparented
                // on the fly.
                if (typeof Kirigami.OverlayZStacking !== "undefined") {
                    root.popup.z = Qt.binding(() => root.popup.Kirigami.OverlayZStacking.z);
                }
                root.popup.open();
            });
        }

        onAccepted: {
            if (root.autoAccept) {
                if (text.length > 2) {
                    root.accepted()
                }
            } else if (text.length === 0) {
                root.popup.close();
            } else {
                root.accepted();
            }
        }
    }

    contentItem: Item {
        implicitHeight: searchField.implicitHeight
        implicitWidth: searchField.implicitWidth
        children: searchField
    }

    padding: 0
    topPadding: undefined
    leftPadding: undefined
    rightPadding: undefined
    bottomPadding: undefined
    verticalPadding: undefined
    horizontalPadding: undefined

    focusPolicy: Qt.NoFocus
    activeFocusOnTab: true

    onActiveFocusChanged: {
        if (activeFocus) {
            searchField.forceActiveFocus();
        }
    }

    onVisibleChanged: {
        if (!visible) {
            popup.close();
        }
    }

    function __handoverChild(child: Item, oldParent: Item, newParent: Item) {
        // It used to be more complicated with QQC2.Control::contentItem
        // handover. But plain Items are very simple to deal with, and they
        // don't attempt to hide old contentItem by setting their visible=false.
        child.parent = newParent;
    }

    T.Popup {
        id: popup

        Component.onCompleted: {
            // TODO KF6: port to declarative bindings.
            if (typeof Kirigami.OverlayZStacking !== "undefined") {
                Kirigami.OverlayZStacking.layer = Kirigami.OverlayZStacking.Dialog;
                z = Qt.binding(() => Kirigami.OverlayZStacking.z);
            }
        }

        readonly property real collapsedHeight: searchField.implicitHeight
            + topMargin + bottomMargin + topPadding + bottomPadding

        // How much vertical space this popup is actually going to take,
        // considering that margins will push it inside and shrink if needed.
        readonly property real realisticHeight: {
            const wantedHeight = searchField.implicitHeight + Kirigami.Units.gridUnit * 20;
            const overlay = root.QQC2.Overlay.overlay;
            if (!overlay) {
                return 0;
            }
            return Math.min(wantedHeight, overlay.height - topMargin - bottomMargin);
        }

        readonly property real realisticContentHeight: realisticHeight - topPadding - bottomPadding

        // y offset from parent/root control if there's not enough space on
        // the bottom, so popup is being pushed upward.
        readonly property real yOffset: {
            const overlay = root.QQC2.Overlay.overlay;
            if (!overlay) {
                return 0;
            }
            return Math.max(-root.Kirigami.ScenePosition.y, Math.min(0, overlay.height - root.Kirigami.ScenePosition.y - realisticHeight));
        }

        clip: false
        parent: root

        // make sure popup is being pushed in-bounds if it is too large or root control is (partially) out of bounds
        margins: 0

        leftPadding: dialogRoundedBackground.border.width
        rightPadding: dialogRoundedBackground.border.width
        bottomPadding: dialogRoundedBackground.border.width
        x: -leftPadding
        y: 0 // initial value, will be managed by enter/exit transitions

        implicitWidth: root.width + leftPadding + rightPadding
        height: popup.collapsedHeight // initial binding, will be managed by enter/exit transitions

        onVisibleChanged: {
            searchField.QQC2.ToolTip.hide();
            if (visible) {
                root.__handoverChild(searchField, root.contentItem, fieldContainer);
                searchField.forceActiveFocus();
            } else {
                root.__handoverChild(searchField, fieldContainer, root.contentItem);
            }
        }

        onAboutToHide: {
            searchField.focus = false;
        }

        enter: Transition {
            SequentialAnimation {
                // cross-fade search field's background with popup's bigger rounded background
                ParallelAnimation {
                    NumberAnimation {
                        target: searchField.background
                        property: "opacity"
                        to: 0
                        easing.type: Easing.OutCubic
                        duration: Kirigami.Units.shortDuration
                    }
                    NumberAnimation {
                        target: dialogRoundedBackground
                        property: "opacity"
                        to: 1
                        easing.type: Easing.OutCubic
                        duration: Kirigami.Units.shortDuration
                    }
                }
                // push Y upward (if needed) and expand at the same time
                ParallelAnimation {
                    NumberAnimation {
                        property: "y"
                        easing.type: Easing.OutCubic
                        duration: Kirigami.Units.longDuration
                        to: popup.yOffset
                    }
                    NumberAnimation {
                        property: "height"
                        easing.type: Easing.OutCubic
                        duration: Kirigami.Units.longDuration
                        to: popup.realisticHeight
                    }
                }
            }
        }

        // Rebind animated properties in case enter/exit transition was skipped.
        onOpened: {
            searchField.background.opacity = 0;
            dialogRoundedBackground.opacity = 1;
            // Make sure height stays sensible if window is resized while popup is open.
            popup.y = Qt.binding(() => popup.yOffset);
            popup.height = Qt.binding(() => popup.realisticHeight);
        }

        exit: Transition {
            SequentialAnimation {
                // return Y back to root control's position (if needed) and collapse at the same time
                ParallelAnimation {
                    NumberAnimation {
                        property: "y"
                        easing.type: Easing.OutCubic
                        duration: Kirigami.Units.longDuration
                        to: 0
                    }
                    NumberAnimation {
                        property: "height"
                        easing.type: Easing.OutCubic
                        duration: Kirigami.Units.longDuration
                        to: popup.collapsedHeight
                    }
                }
                // cross-fade search field's background with popup's bigger rounded background
                ParallelAnimation {
                    NumberAnimation {
                        target: searchField.background
                        property: "opacity"
                        to: 1
                        easing.type: Easing.OutCubic
                        duration: Kirigami.Units.shortDuration
                    }
                    NumberAnimation {
                        target: dialogRoundedBackground
                        property: "opacity"
                        to: 0
                        easing.type: Easing.OutCubic
                        duration: Kirigami.Units.shortDuration
                    }
                }
            }
        }

        // Rebind animated properties in case enter/exit transition was skipped.
        onClosed: {
            searchField.background.opacity = 1;
            dialogRoundedBackground.opacity = 0;
            // Make sure height stays sensible if search field is resized while popup is closed.
            popup.y = 0;
            popup.height = Qt.binding(() => popup.collapsedHeight);
        }

        background: DialogRoundedBackground {
            id: dialogRoundedBackground

            // initial value, will be managed by enter/exit transitions
            opacity: 0
        }

        contentItem: Item {
            // clip with rounded corners
            layer.enabled: popup.enter.running || popup.exit.running
            layer.effect: Kirigami.ShadowedTexture {
                // color is not needed, we are here for the clipping only.
                color: "transparent"
                // border is not needed, as is is already accounted by
                // padding. But radius has to be adjusted for that padding.
                radius: dialogRoundedBackground.radius - popup.leftPadding - popup.bottomPadding
            }

            ColumnLayout {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                height: popup.realisticContentHeight
                spacing: 0

                Item {
                    id: fieldContainer
                    implicitWidth: searchField.implicitWidth
                    implicitHeight: searchField.implicitHeight
                    Layout.fillWidth: true
                }

                Kirigami.Separator {
                    Layout.fillWidth: true
                }

                QQC2.ScrollView {
                    id: scrollView

                    Kirigami.Theme.colorSet: Kirigami.Theme.View
                    Kirigami.Theme.inherit: false

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
        }
    }
}
