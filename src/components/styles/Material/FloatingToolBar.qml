/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components.templates as Templates

Templates.FloatingToolBar {
    id: root

    padding: Kirigami.Units.largeSpacing
    horizontalPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    spacing: Kirigami.Units.largeSpacing

    Material.background: Qt.tint(Material.theme === Material.Dark ? Material.color(Material.Grey, Material.Shade900) : "white",
                                 Qt.alpha(Material.primary, 0.08))
    Material.elevation: enabled ? 3 : 0

    background: Rectangle {
        implicitWidth: Kirigami.Units.largeSpacing * 8
        implicitHeight: Kirigami.Units.largeSpacing * 8
        radius: Math.min(width, height) / 2
        color: root.Material.background

        layer.enabled: root.Material.elevation > 0
        layer.effect: ElevationEffect {
            elevation: root.Material.elevation
        }
    }
}
