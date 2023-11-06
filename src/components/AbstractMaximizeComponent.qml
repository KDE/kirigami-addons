// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0

import org.kde.kirigami 2.15 as Kirigami

/**
 * @brief A popup that covers the entire window to show a content item.
 *
 * This component is designed to show a content item at the maximum size the
 * application window will allow. The typical use is for showing a maximized image
 * or other piece of media in an application, but it could be any item if desired.
 *
 * The popup also has a header bar which has a writable title, an optional leading
 * item to the left, a list of custom actions specified by the actions property
 * and an optional footer item.
 */
QQC2.Popup {
    id: root

    /**
     * @brief The title of the overlay window.
     */
    property alias title: titleLabel.text

    /**
     * @brief The subtitle of the overlay window.
     *
     * The label will be hidden and the title centered if this is not provided.
     */
    property alias subtitle: subtitleLabel.text

    /**
     * @brief List of top row actions.
     *
     * Each action will be allocated a QQC2.ToolButton on the top row. All actions
     * are right aligned and appear next to the close button which is always present
     * so does not require specifying.
     */
    property alias actions: actionToolBar.actions

    /**
     * @brief The main content item in the view.
     *
     * The item will be the sized to fit the available space. If the item is
     * larger than the available space it will be shrunk to fit.
     *
     * @note If stretching the item isn't desirable the user needs to manage this,
     *       e.g. with a holding item. See ImageMaximizeDelegate.qml for an example.
     *
     * @sa ImageMaximizeDelegate.qml
     */
    property Item content

    /**
     * @brief Item to the left of the overlay title.
     */
    property Item leading

    /**
     * @brief Item at the bottom under the content.
     */
    property Item footer

    parent: applicationWindow().overlay
    closePolicy: QQC2.Popup.CloseOnEscape
    width: parent.width
    height: parent.height
    modal: true
    padding: 0
    background: Item {}

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        QQC2.Control {
            Layout.fillWidth: true
            contentItem: RowLayout {
                spacing: Kirigami.Units.largeSpacing

                Item {
                    id: leadingParent
                    Layout.preferredWidth: root.leading ? root.leading.implicitWidth : 0
                    Layout.preferredHeight: root.leading ? root.leading.implicitHeight : 0
                    visible: root.leading
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    QQC2.Label {
                        id: titleLabel
                        Layout.fillWidth: true
                        Layout.maximumWidth: implicitWidth + Kirigami.Units.largeSpacing
                        font.weight: Font.Bold
                        elide: Text.ElideRight
                        textFormat: Text.PlainText
                    }
                    QQC2.Label {
                        id: subtitleLabel
                        Layout.fillWidth: true
                        Layout.maximumWidth: implicitWidth + Kirigami.Units.largeSpacing
                        visible: text !== ""
                        color: Kirigami.Theme.disabledTextColor
                        elide: Text.ElideRight
                        textFormat: Text.PlainText
                    }
                }
                Kirigami.ActionToolBar {
                    id: actionToolBar
                    alignment: Qt.AlignRight
                    display: QQC2.AbstractButton.IconOnly
                }
                QQC2.ToolButton {
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 2
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 2
                    display: QQC2.AbstractButton.IconOnly

                    action: Kirigami.Action {
                        text: i18nd("kirigami-addons6", "Close")
                        icon.name: "dialog-close"
                        onTriggered: root.close()
                    }

                    QQC2.ToolTip.text: text
                    QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                    QQC2.ToolTip.visible: hovered
                }
            }

            background: Rectangle {
                color: Kirigami.Theme.alternateBackgroundColor
            }

            Kirigami.Separator {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                height: 1
            }
        }
        Item {
            id: contentParent
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        Item {
            id: footerParent
            Layout.fillWidth: true
            Layout.preferredHeight: root.footer ? root.footer.implicitHeight > Kirigami.Units.gridUnit * 12 ? Kirigami.Units.gridUnit * 12 : root.footer.implicitHeight : 0
            visible: root.footer && !root.hideCaption
        }
    }

    // TODO: blur
    QQC2.Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.5)
    }

    onLeadingChanged: {
        if (!root.leading) {
            return;
        }
        root.leading.parent = leadingParent;
        root.leading.anchors.fill = leadingParent;
    }

    onContentChanged: {
        if (!root.content) {
            return;
        }
        root.content.parent = contentParent;
        root.content.anchors.fill = contentParent;
    }

    onFooterChanged: {
        if (!root.footer) {
            return;
        }
        root.footer.parent = footerParent;
        root.footer.anchors.fill = footerParent;
    }
}
