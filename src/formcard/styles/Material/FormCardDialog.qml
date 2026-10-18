/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick.Controls.Material
import org.kde.kirigamiaddons.formcard.templates as T

T.FormCardDialog {
    Material.roundedScale: Material.ExtraLargeScale
    Material.elevation: 6

    horizontalContentPadding: 24
    verticalContentPadding: 24
    titleFont: Qt.font({ pixelSize: Material.dialogTitleFontPixelSize })

    horizontalPadding: 12
    bottomPadding: 12
}
