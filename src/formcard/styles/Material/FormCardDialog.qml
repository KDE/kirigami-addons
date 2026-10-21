/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick.Controls as QQC2
import QtQuick.Controls.Material
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as Components
import org.kde.kirigamiaddons.formcard.templates as T

T.FormCardDialog {
    id: root

    Material.roundedScale: Material.ExtraLargeScale
    Material.elevation: 6

    _horizontalContentPadding: 24
    _verticalContentPadding: 24
    _titleFont: Qt.font({ pixelSize: Material.dialogTitleFontPixelSize })

    horizontalPadding: 12
    bottomPadding: 12

    background: Components.DialogRoundedBackground {
        Material.roundedScale: root.Material.roundedScale
        Material.elevation: root.Material.elevation
    }

    header: Kirigami.Heading {
        id: heading

        text: root.title
        elide: QQC2.Label.ElideRight
        leftPadding: root._horizontalContentPadding
        rightPadding: root._horizontalContentPadding
        topPadding: root._verticalContentPadding
        bottomPadding: 0
    }
}
