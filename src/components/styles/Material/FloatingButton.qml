/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Material
import org.kde.kirigami as Kirigami

RoundButton {
    id: root

    property real margins: 0
    property real topMargin: margins
    property real leftMargin: margins
    property real rightMargin: margins
    property real bottomMargin: margins

    readonly property size __effectiveIconSize: Qt.size(icon.width, icon.height)

    display: RoundButton.IconOnly
    radius: Kirigami.Units.largeSpacing * 2
    padding: Kirigami.Units.largeSpacing * 2
    spacing: 0
    hoverEnabled: !Kirigami.Settings.hasTransientTouchInput

    icon.width: Kirigami.Units.iconSizes.smallMedium
    icon.height: Kirigami.Units.iconSizes.smallMedium

    topPadding: padding + topMargin
    leftPadding: padding + leftMargin
    rightPadding: padding + rightMargin
    bottomPadding: padding + bottomMargin
    topInset: topMargin
    leftInset: leftMargin
    rightInset: rightMargin
    bottomInset: bottomMargin

    background.implicitWidth: Kirigami.Units.largeSpacing * 7
    background.implicitHeight: Kirigami.Units.largeSpacing * 7

    Material.background: Qt.tint(Material.theme === Material.Dark ? Material.color(Material.Grey, Material.Shade900) : "white",
                                 Qt.alpha(Material.accent, Material.theme === Material.Dark ? 0.4 : 0.2))
    Material.foreground: Qt.tint(Material.theme === Material.Dark ? "white" : "black", Qt.alpha(Material.accent, 0.2))
    Material.elevation: !enabled ? 0 : !down && (hovered || visualFocus) ? 8 : 6
}
