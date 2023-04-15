// SPDX-FileCopyrightText: 2021 Jonah Brüchert <jbb@kaidan.im>
// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
//
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Templates 2.15 as T
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0
import org.kde.kirigami 2.19 as Kirigami

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
     */
    property bool spaceAvailableLeft: true

    /**
     * This property holds whether there is space available on the left.
     *
     * This is used by the right shadow.
     *
     * @since KirigamiAddons.labs.components 1.0
     */
    property bool spaceAvailableRight: true

    /**
     * This signal is triggered when the user trigger a search.
     */
    signal accepted()

    property alias popup: popup

    property Kirigami.SearchField searchField: Kirigami.SearchField {
        // HACK: anchor searchField to (changing) parent; this is done to
        // guarantee that it resizes properly and timely
        anchors.left: parent.left
        anchors.right: parent.right
        selectByMouse: true

        KeyNavigation.tab: scrollView.contentItem
        KeyNavigation.down: scrollView.contentItem

        onFocusChanged: if (focus) {
            root.popup.open()
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

    contentItem: searchField

    leftPadding: 0
    topPadding: 0
    bottomPadding: 0
    rightPadding: 0

    T.Popup {
        id: popup

        rightMargin: root.spaceAvailableRight ? Kirigami.Units.gridUnit * 2 : 3
        leftMargin: root.spaceAvailableLeft ? Kirigami.Units.gridUnit * 2 : 3
        topMargin: 0

        width: root.width
        height: Kirigami.Units.gridUnit * 20

        onAboutToShow: {
            searchField.parent = fieldContainer
            fieldContainer.contentItem = searchField
            searchField.background.visible = false
            playOpenHeight.running = true
        }

        onAboutToHide: {
            root.contentItem = searchField;
            searchField.parent = root;
            searchField.background.visible = true
            searchField.focus = false
            playCloseHeight.running = true
        }

        background: Kirigami.ShadowedRectangle{
            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: Kirigami.Theme.View
            color: Kirigami.Theme.backgroundColor
            radius: 7
            shadow.size: 20
            shadow.yOffset: 5
            shadow.color: Qt.rgba(0, 0, 0, 0.2)

            border.width: 1
            border.color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.3);
        }

        NumberAnimation on height{
            id: playOpenHeight
            easing.type: Easing.OutCubic
            from: 40
            duration: Kirigami.Units.longDuration
            to: Kirigami.Units.gridUnit * 20 + 40
        }

        NumberAnimation on height{
            id: playCloseHeight
            easing.type: Easing.OutCubic
            from: Kirigami.Units.gridUnit * 20 + 40
            duration: Kirigami.Units.longDuration
            to: searchField.heigth + 40
        }

        contentItem: Item {
            ColumnLayout {
                id: content
                anchors.fill: parent
                spacing: 0

                QQC2.Control{
                    id: fieldContainer

                    topPadding: 0
                    leftPadding: 0
                    rightPadding: 0
                    bottomPadding: 0

                    Layout.fillWidth: true
                    Layout.topMargin: 2
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
