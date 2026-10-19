/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls.Material
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard.templates as T

T.FormGridContainer {
    id: root

    component InfoCard: T.FormGridContainer.InfoCard {}

    Material.roundedScale: Material.MediumScale

    _cornerRadius: Material.roundedScale
    _horizontalInset: Kirigami.Units.largeSpacing

    _backgroundDelegate: MaterialCardBackground {
        radius: root._cornerRadius
    }
}
