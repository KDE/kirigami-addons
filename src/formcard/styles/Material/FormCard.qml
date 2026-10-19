/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls.Material
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard.templates as T

T.FormCard {
    id: root

    Material.roundedScale: Material.MediumScale
    Material.elevation: 1

    _cornerRadius: Material.roundedScale
    _horizontalInset: Kirigami.Units.largeSpacing

    _background: MaterialCardBackground {
        Material.theme: root.Material.theme
        Material.elevation: root.Material.elevation
        radius: root._cornerRadius
    }
}
