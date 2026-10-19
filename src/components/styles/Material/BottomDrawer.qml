/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components.templates as Templates

Templates.BottomDrawer {
    id: root

    width: Math.min(QQC2.ApplicationWindow.window?.width ?? 0, Kirigami.Units.largeSpacing * 80)
    x: Math.round(((QQC2.ApplicationWindow.window?.width ?? 0) - width) / 2)

    topPadding: 0

    _handleMargin: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    _headerHorizontalPadding: Kirigami.Units.largeSpacing * 3
    _headerBottomPadding: Kirigami.Units.largeSpacing * 2

    Material.background: Qt.tint(Material.theme === Material.Dark ? Material.color(Material.Grey, Material.Shade900) : "white",
                                 Qt.alpha(Material.primary, 0.05))
    Material.elevation: 1

    _handle: Rectangle {
        implicitWidth: Kirigami.Units.largeSpacing * 4
        implicitHeight: Kirigami.Units.smallSpacing
        radius: height / 2
        color: Qt.alpha(root.Material.foreground, 0.4)
    }

    background: Rectangle {
        color: root.Material.background
        radius: Kirigami.Units.largeSpacing * 3 + Kirigami.Units.smallSpacing
        bottomLeftRadius: 0
        bottomRightRadius: 0

        layer.enabled: root.Material.elevation > 0
        layer.effect: RoundedElevationEffect {
            roundedScale: root.background.radius
            elevation: root.Material.elevation
        }
    }

    QQC2.Overlay.modal: Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.32)
    }
}
