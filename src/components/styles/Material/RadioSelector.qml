// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls.impl
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components.templates as Templates
import "../../templates/private" as Private

Templates.RadioSelector {
    id: root

    spacing: Kirigami.Units.smallSpacing

    _delegate: Private.RadioSelectorButton {
        id: button
        selector: root

        implicitWidth: Math.max(implicitBackgroundWidth, implicitContentWidth + leftPadding + rightPadding)
        implicitHeight: Math.max(Kirigami.Units.largeSpacing * 5, implicitContentHeight + topPadding + bottomPadding)
        horizontalPadding: Kirigami.Units.largeSpacing * 2
        verticalPadding: Kirigami.Units.largeSpacing
        spacing: Kirigami.Units.largeSpacing

        icon.width: Kirigami.Units.iconSizes.smallMedium
        icon.height: Kirigami.Units.iconSizes.smallMedium

        contentItem: IconLabel {
            icon: button.icon
            text: button.text
            font: button.font
            spacing: button.spacing
            mirrored: button.mirrored
            display: button.display
            defaultIconColor: color
            color: button.enabled ? button.Material.foreground : button.Material.hintTextColor
        }

        background: Rectangle {
            radius: height / 2
            color: "transparent"

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: Qt.alpha(button.Material.foreground, !button.enabled ? 0 : button.down || button.visualFocus ? 0.12 : button.hovered ? 0.08 : 0)
                border.width: button.visualFocus ? 2 : 0
                border.color: button.Material.accent
            }
        }
    }

    Rectangle {
        x: root.leftPadding + (root._checkedButton?.x ?? 0)
        y: root.topPadding + (root._checkedButton?.y ?? 0)
        z: -1
        width: root._checkedButton?.width ?? 0
        height: root._checkedButton?.height ?? 0
        radius: height / 2
        visible: root._checkedButton !== null
        color: Qt.alpha(root.Material.primary, root._checkedButton?.enabled ? 0.16 : 0.08)

        Behavior on x {
            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutCubic
            }
        }

        Behavior on width {
            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutCubic
            }
        }
    }
}
