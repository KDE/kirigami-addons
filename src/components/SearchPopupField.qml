// SPDX-FileCopyrightText: 2021 Jonah Brüchert <jbb@kaidan.im>
// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl\carlschwan.eu>
// SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>
//
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import QtQuick.Layouts
import Qt.labs.qmlmodels
import org.kde.kirigami as Kirigami

/*!
   \qmltype SearchPopupField
   \inqmlmodule org.kde.kirigamiaddons.components
   \brief SearchField with a Popup to show autocompletion entries or search results

   \deprecated Use Kirigami.SearchDialog instead.

   Can be replaced by the following code:

   \qml
   Kirigami.SearchField {
       TapHandler {
           onTapped: {
               searchDialog.open();
           }
           acceptedButtons: Qt.RightButton | Qt.LeftButton
       }
       Keys.onPressed: (event) => {
           if (event.key !== Qt.Key_Tab || event.key !== Qt.Key_Backtab) {
               searchDialog.open();
               searchDialog.text = text;
           }
       }
       Keys.priority: Keys.AfterItem

       Kirigami.SearchDialog {
           id: searchDialog
           ...
       }
   }
   \endqml
   \since 1.0
   \sa SearchDialog
 */
QQC2.Control {
    id: root

    /*!
       \qmlproperty Item popupContentItem
       This property holds the content item of the \l popup.

       Overflow will be automatically handled as popupContentItem is
       contained inside a ScrollView.

       This is the default element of SearchPopupField.

       \qml
       SearchPopupField {
           ListView {
               model: SearchModel {}
               delegate: QQC2.ItemDelegate {}

               Kirigami.PlaceholderMessage {
                   id: loadingPlaceholder
                   anchors.centerIn: parent
                   width: parent.width - Kirigami.Units.gridUnit * 4
                   // ...
               }
           }
       }
       \endqml

       \since 1.0
     */
    default property alias popupContentItem: scrollView.contentItem

    /*!
       \qmlproperty string text
       This property holds the \l {TextInput::text} {text} of the search field.
       \since 1.0
     */
    property alias text: root.searchField.text

    /*!
       \qmlproperty bool delaySearch
       \brief This property sets whether to delay automatic acceptance of the search input.

       Set this to \c true if your search is expensive (such as for online
       operations or in exceptionally slow data sets) and want to delay it
       for 2.5 seconds.

       \note If you must have immediate feedback (filter-style), use the
       \l text property directly instead of accepted()

       \default false

       \since 1.0
     */
    property alias delaySearch: root.searchField.delaySearch

    /*!
       \qmlproperty bool autoAccept
       \brief This property sets whether the accepted signal is fired automatically
       when the text is changed.

       Setting this to \c false will require that the user presses return or enter
       (the same way a TextInput works).

       \default false

       \since 1.0
     */
    property alias autoAccept: root.searchField.autoAccept

    /*!
       This property holds whether there is space available on the left.

       This is used by the left shadow.

       \since 1.0
       \deprecated Was not really used by anything.
     */
    property bool spaceAvailableLeft: true

    /*!
       This property holds whether there is space available on the left.

       This is used by the right shadow.

       \since 1.0
       \deprecated Was not really used by anything.
     */
    property bool spaceAvailableRight: true

    /*!
       \qmlproperty bool fieldFocus
       \brief This hold the \l {Item::focus} {focus} state of the internal SearchField.
     */
    property alias fieldFocus: root.searchField.focus

    /*!
       This signal is triggered when the user trigger a search.
     */
    signal accepted()

    /*!
       \qmlproperty Popup popup
     */
    property alias popup: popup

    /*!
     */
    property Kirigami.SearchField searchField: Kirigami.SearchField {}

    contentItem: Item {
        implicitHeight: root.searchField ? root.searchField.implicitHeight : 0
        implicitWidth: root.searchField ? root.searchField.implicitWidth : 0

        // by default popup is hidden
        children: [root.searchField]

        states: State {
            when: root.searchField !== null // one the the only, fallback, always active state
            AnchorChanges {
                target: root.searchField
                anchors.left: root.searchField && root.searchField.parent ? root.searchField.parent.left : undefined
                anchors.right: root.searchField && root.searchField.parent ? root.searchField.parent.right : undefined
                anchors.verticalCenter:  root.searchField && root.searchField.parent ? root.searchField.parent.verticalCenter : undefined
            }
            PropertyChanges {
                target: root.searchField ? root.searchField.KeyNavigation : null
                tab: scrollView.contentItem
                down: scrollView.contentItem
            }
        }
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
        if (searchField && activeFocus) {
            searchField.forceActiveFocus();
        }
    }

    onVisibleChanged: {
        if (!visible) {
            popup.close();
        }
    }

    onSearchFieldChanged: {
        __openPopupIfSearchFieldHasActiveFocus();
    }

    function __handoverChild(child: Item, oldParent: Item, newParent: Item) {
        // It used to be more complicated with QQC2.Control::contentItem
        // handover. But plain Items are very simple to deal with, and they
        // don't attempt to hide old contentItem by setting their visible=false.
        child.parent = newParent;
    }

    function __openPopupIfSearchFieldHasActiveFocus() {
        if (searchField && searchField.activeFocus && !popup.opened) {
            // Don't mess with popups and reparenting inside focus change handler.
            // Especially nested popups hate that: it may break all focus management
            // on a scene until restart.
            Qt.callLater(() => {
                // TODO: Kirigami.OverlayZStacking fails to find and bind to
                // parent logical popup when parent item is itself reparented
                // on the fly.
                //
                // Catch a case of reopening during exit transition. But don't
                // attempt to reorder a visible popup, it doesn't like that.
                if (!popup.visible) {
                    if (typeof popup.Kirigami.OverlayZStacking !== "undefined") {
                        popup.z = Qt.binding(() => popup.Kirigami.OverlayZStacking.z);
                    }
                }
                popup.open();
            });
        }
    }

    function __searchFieldWasAccepted() {
        if (autoAccept) {
            if (searchField.text.length > 2) {
                accepted()
            }
        } else if (searchField.text.length === 0) {
            popup.close();
        } else {
            accepted();
        }
    }

    Connections {
        target: root.searchField

        function onActiveFocusChanged() {
            root.__openPopupIfSearchFieldHasActiveFocus();
        }

        function onAccepted() {
            root.__searchFieldWasAccepted();
        }
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

        readonly property real searchFieldY: root.searchField
                                             ? root.height/2 - root.searchField.height / 2
                                             : 0
        readonly property real collapsedHeight: (root.searchField ? root.searchField.implicitHeight : 0)
            + topMargin + bottomMargin + topPadding + bottomPadding

        // How much vertical space this popup is actually going to take,
        // considering that margins will push it inside and shrink if needed.
        readonly property real realisticHeight: {
            const wantedHeight = (root.searchField ? root.searchField.implicitHeight : 0) + Kirigami.Units.gridUnit * 20;
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
            return Math.max(-root.Kirigami.ScenePosition.y, Math.min(0, overlay.height - root.Kirigami.ScenePosition.y - realisticHeight)) + searchFieldY;
        }

        clip: false
        parent: root

        // make sure popup is being pushed in-bounds if it is too large or root control is (partially) out of bounds
        margins: 0

        leftPadding: dialogRoundedBackground.border.width
        rightPadding: dialogRoundedBackground.border.width
        bottomPadding: dialogRoundedBackground.border.width
        x: -leftPadding
        y: searchFieldY // initial value, will be managed by enter/exit transitions

        implicitWidth: root.width + leftPadding + rightPadding
        height: popup.collapsedHeight // initial binding, will be managed by enter/exit transitions

        onVisibleChanged: {
            root.searchField.QQC2.ToolTip.hide();
            if (visible) {
                root.__handoverChild(root.searchField, root.contentItem, fieldContainer);
                root.searchField.forceActiveFocus();
            } else {
                root.__handoverChild(root.searchField, fieldContainer, root.contentItem);
            }
        }

        onAboutToHide: {
            root.searchField.focus = false;
        }

        enter: Transition {
            SequentialAnimation {
                // cross-fade search field's background with popup's bigger rounded background
                ParallelAnimation {
                    NumberAnimation {
                        target: root.searchField.background
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
            root.searchField.background.opacity = 0;
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
                        to: popup.searchFieldY
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
                        target: root.searchField.background
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
            root.searchField.background.opacity = 1;
            dialogRoundedBackground.opacity = 0;
            // Make sure height stays sensible if search field is resized while popup is closed.
            popup.y = searchFieldY;
            popup.height = Qt.binding(() => popup.collapsedHeight);
        }

        background: DialogRoundedBackground {
            id: dialogRoundedBackground

            // initial value, will be managed by enter/exit transitions
            opacity: 0
        }

        contentItem: Item {
            clip: true

            Rectangle {
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
                    implicitWidth: root.searchField ? root.searchField.implicitWidth : 0
                    implicitHeight: root.searchField ? root.searchField.implicitHeight : 0
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
