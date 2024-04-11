// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as Components
import org.kde.kirigamiaddons.delegates as Delegates

/**
 * A dialog to show a message. This dialog exists has 4 modes: success, warning, error, information.
 *
 * @image html messagedialog.png
 */
T.Dialog {
    id: root

    enum DialogType {
        Sucess,
        Warning,
        Error,
        Information
    }

    /**
     * This property holds the dialogType. It can be either:
     *
     * - `MessageDialog.Sucess`: For a sucess message
     * - `MessageDialog.Warning`: For a warning message
     * - `MessageDialog.Error`: For an actual error
     * - `MessageDialog.Information`: For an informational message
     *
     * By default, the dialogType is `MessageDialog.Sucess`
     */
    property int dialogType: MessageDialog.Sucess

    default property alias mainContent: mainLayout.data

    property string iconName: ''

    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)

    parent: applicationWindow().QQC2.Overlay.overlay

    width: Math.min(parent.width - Kirigami.Units.gridUnit * 4, Kirigami.Units.gridUnit * 20)

    z: Kirigami.OverlayZStacking.z

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding,
                            implicitHeaderWidth,
                            implicitFooterWidth)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding
                             + (implicitHeaderHeight > 0 ? implicitHeaderHeight + spacing : 0)
                             + (implicitFooterHeight > 0 ? implicitFooterHeight + spacing : 0))

    padding: Kirigami.Units.largeSpacing * 2
    bottomPadding: Kirigami.Units.largeSpacing

    contentItem: RowLayout {
        spacing: Kirigami.Units.largeSpacing
        Kirigami.Icon {
            source: {
                if (root.iconName.length > 0) {
                    return root.iconName
                }
                switch (root.dialogType) {
                case MessageDialog.Sucess:
                    return "data-sucess";
                case MessageDialog.Warning:
                    return "data-warning";
                case MessageDialog.Error:
                    return "data-error";
                case MessageDialog.Information:
                    return "data-information";
                default:
                    return "data-warning";
                }
            }
            Layout.preferredWidth: Kirigami.Units.iconSizes.huge
            Layout.preferredHeight: Kirigami.Units.iconSizes.huge
            Layout.alignment: Qt.AlignTop
        }

        ColumnLayout {
            id: mainLayout

            spacing: Kirigami.Units.smallSpacing

            Layout.fillWidth: true

            Kirigami.Heading {
                text: root.title
                visible: root.title
                elide: QQC2.Label.ElideRight
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }

    footer: QQC2.DialogButtonBox {
        leftPadding: Kirigami.Units.largeSpacing * 2
        rightPadding: Kirigami.Units.largeSpacing * 2
        bottomPadding: Kirigami.Units.largeSpacing * 2
        topPadding: Kirigami.Units.largeSpacing * 2

        standardButtons: root.standardButtons
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            easing.type: Easing.InOutQuad
            duration: Kirigami.Units.longDuration
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1
            to: 0
            easing.type: Easing.InOutQuad
            duration: Kirigami.Units.longDuration
        }
    }

    modal: true
    focus: true

    background: Components.DialogRoundedBackground {}

    // black background, fades in and out
    QQC2.Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.3)

        // the opacity of the item is changed internally by QQuickPopup on open/close
        Behavior on opacity {
            OpacityAnimator {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
    }
}
