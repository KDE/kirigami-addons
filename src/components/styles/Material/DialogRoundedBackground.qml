/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls.Material
import org.kde.kirigami as Kirigami

Kirigami.ShadowedRectangle {
    Material.roundedScale: Material.ExtraLargeScale
    Material.elevation: 6

    radius: Material.roundedScale
    color: Material.dialogColor

    shadow {
        size: Material.elevation * 3
        yOffset: Material.elevation
        color: Qt.rgba(0, 0, 0, 0.2)
    }
}
