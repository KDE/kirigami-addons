/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import QtQuick.Controls.impl
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components.templates as Templates

Templates.FloatingButton {
    id: root

    readonly property size __effectiveIconSize: Qt.size(icon.width, icon.height)

    radius: Kirigami.Units.largeSpacing * 2
    padding: Kirigami.Units.largeSpacing * 2

    icon.width: Kirigami.Units.iconSizes.smallMedium
    icon.height: Kirigami.Units.iconSizes.smallMedium

    contentItem: IconLabel {
        spacing: root.spacing
        mirrored: root.mirrored
        display: root.display
        icon: root.icon
        defaultIconColor: !root.enabled ? root.Material.hintTextColor
            : root.flat && root.highlighted ? root.Material.accentColor
            : root.highlighted ? root.Material.primaryHighlightedTextColor
            : root.Material.foreground
        text: root.text
        font: root.font
        color: defaultIconColor
    }

    background: Rectangle {
        implicitWidth: Kirigami.Units.largeSpacing * 7
        implicitHeight: Kirigami.Units.largeSpacing * 7
        radius: root.radius
        color: root.Material.buttonColor(root.Material.theme, root.Material.background,
                                         root.Material.accent, root.enabled, root.flat, root.highlighted, false)

        Behavior on color {
            ColorAnimation { duration: Kirigami.Units.shortDuration }
        }

        Rectangle {
            anchors.fill: parent
            radius: root.radius
            visible: root.enabled && (root.down || root.hovered || root.visualFocus)
            color: root.Material.rippleColor
        }

        layer.enabled: root.enabled && color.a > 0 && !root.flat
        layer.effect: ElevationEffect {
            elevation: root.Material.elevation
        }
    }

    Material.background: Qt.tint(Material.theme === Material.Dark ? Material.color(Material.Grey, Material.Shade900) : "white",
                                 Qt.alpha(Material.accent, Material.theme === Material.Dark ? 0.4 : 0.2))
    Material.foreground: Qt.tint(Material.theme === Material.Dark ? "white" : "black", Qt.alpha(Material.accent, 0.2))
    Material.elevation: !enabled ? 0 : !down && (hovered || visualFocus) ? 8 : 6
}
