// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as KirigamiComponents

QQC2.Dialog {
    id: root

    parent: QQC2.Overlay.overlay
    x: parent ? Math.round((parent.width - width) / 2) : 0
    y: parent ? Math.round((parent.height - height) / 2) : 0
    implicitWidth: parent ? Math.min(parent.width - Kirigami.Units.gridUnit * 2, Kirigami.Units.gridUnit * 30) : Kirigami.Units.gridUnit * 30
    implicitHeight: Math.min(parent ? parent.height - Kirigami.Units.gridUnit * 2 : Kirigami.Units.gridUnit * 32,
                             Kirigami.Units.gridUnit * 32,
                             implicitHeaderHeight + implicitContentHeight)
    modal: true
    focus: true
    padding: 0
    background: KirigamiComponents.DialogRoundedBackground {}

    header: QQC2.Control {
        topPadding: Kirigami.Units.largeSpacing
        bottomPadding: Kirigami.Units.largeSpacing

        contentItem: RowLayout {
            spacing: Kirigami.Units.largeSpacing

            Kirigami.Heading {
                Layout.fillWidth: true
                text: root.title
                elide: Text.ElideRight
                padding: 0
                leftPadding: Kirigami.Units.largeSpacing
            }

            QQC2.ToolButton {
                icon.name: hovered ? "window-close" : "window-close-symbolic"
                text: i18ndc("kirigami-addons6", "@action:button", "Close")
                display: QQC2.ToolButton.IconOnly
                onClicked: root.close()
            }
        }

        Kirigami.Separator {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
        }
    }

    footer: null
}
