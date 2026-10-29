/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components.templates as Templates

Templates.DoubleFloatingButton {
    id: root

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    LayoutMirroring.childrenInherit: true

    Material.background: Qt.tint(Material.theme === Material.Dark ? Material.color(Material.Grey, Material.Shade900) : "white",
                                 Qt.alpha(Material.accent, Material.theme === Material.Dark ? 0.4 : 0.2))
    Material.foreground: Qt.tint(Material.theme === Material.Dark ? "white" : "black", Qt.alpha(Material.accent, 0.2))
    Material.elevation: !enabled || (!leadingAction?.enabled && !trailingAction?.enabled) ? 0
        : !leadingButton.down && !trailingButton.down
            && (leadingButton.hovered || trailingButton.hovered || leadingButton.visualFocus || trailingButton.visualFocus) ? 8 : 6

    _background.anchors.leftMargin: leftMargin
    _background.anchors.rightMargin: rightMargin
    _background.anchors.topMargin: topMargin
    _background.anchors.bottomMargin: bottomMargin

    radius: Kirigami.Units.largeSpacing * 2
    color: Material.buttonColor(Material.theme, Material.background, Material.accent,
                                enabled, false, false, false)
    shadow {
        size: root.Material.elevation * 2
        yOffset: root.Material.elevation / 2
        color: Qt.rgba(0, 0, 0, 0.2)
    }

    component ActionButton: FloatingButton {
        id: button

        required property bool leading
        readonly property bool onLeft: leading !== root.LayoutMirroring.enabled

        enabled: action?.enabled ?? false
        radius: root.radius
        icon.width: action?.icon.width > 0 ? action.icon.width : Kirigami.Units.iconSizes.smallMedium
        icon.height: action?.icon.height > 0 ? action.icon.height : Kirigami.Units.iconSizes.smallMedium
        Material.background: root.Material.background
        Material.foreground: root.Material.foreground
        Material.elevation: 0

        topMargin: root.topMargin
        bottomMargin: root.bottomMargin
        leftMargin: onLeft ? root.leftMargin : 0
        rightMargin: onLeft ? 0 : root.rightMargin

        Layout.fillWidth: true
        Layout.fillHeight: true

        background: Rectangle {
            readonly property real cornerRadius: Math.min(button.radius, height / 2, width)

            implicitWidth: Kirigami.Units.largeSpacing * 7
            implicitHeight: Kirigami.Units.largeSpacing * 7

            color: button.enabled && (button.down || button.visualFocus || button.hovered)
                ? Qt.alpha(root.Material.foreground, button.down || button.visualFocus ? 0.12 : 0.08) : "transparent"
            topLeftRadius: button.onLeft ? cornerRadius : 0
            bottomLeftRadius: button.onLeft ? cornerRadius : 0
            topRightRadius: button.onLeft ? 0 : cornerRadius
            bottomRightRadius: button.onLeft ? 0 : cornerRadius

            Behavior on color {
                ColorAnimation { duration: Kirigami.Units.shortDuration }
            }
        }

        ToolTip.visible: hovered && ToolTip.text.length > 0
        ToolTip.delay: Kirigami.Units.toolTipDelay
        ToolTip.text: (action as Kirigami.Action)?.tooltip ?? ""
    }

    RowLayout {
        id: layout

        anchors.fill: parent
        spacing: 0

        ActionButton {
            id: leadingButton
            leading: true
            action: root.leadingAction
        }

        ActionButton {
            id: trailingButton
            leading: false
            action: root.trailingAction
        }
    }

    Kirigami.Separator {
        x: (leadingButton.onLeft ? leadingButton.x + leadingButton.width : leadingButton.x) - width / 2
        width: implicitWidth
        anchors.top: root._background.top
        anchors.bottom: root._background.bottom
        anchors.margins: Kirigami.Units.largeSpacing * 2
        color: Qt.alpha(root.Material.foreground, root.enabled ? 0.24 : 0.12)
    }
}
