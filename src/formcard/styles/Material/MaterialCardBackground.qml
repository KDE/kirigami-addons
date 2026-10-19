/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls.Material
import org.kde.kirigami as Kirigami

Kirigami.ShadowedRectangle {
    Material.elevation: 1

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    color: Qt.tint(Material.color(Material.Grey, Material.theme === Material.Dark ? Material.Shade900 : Material.Shade100),
        Qt.alpha(Material.primaryColor, 0.05))

    shadow {
        size: Material.elevation * 3
        yOffset: Material.elevation
        color: Qt.rgba(0, 0, 0, 0.2)
    }
}
