// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as Components
import org.kde.kirigamiaddons.formcard as FormCard

import './private' as Private

/**
 * A dialog designed to use FormCard delegates as it's content.
 *
 * \code{.qml}
 * import org.kde.kirigamiaddons.formcard as FormCard
 * import QtQuick.Controls
 *
 * FormCard.FormCardDialog {
 *     title: "Add Thingy"
 *
 *     standardButtons: Dialog.Ok | Dialog.Cancel
 *     FormCard.FormTextFieldDelegate {
 *         label: i18nc("@label:textbox Notebook name", "Name:")
 *     }
 *
 *     FormCard.FormDelegateSeparator {}
 *
 *     FormCard.FormButtonDelegate {
 *         text: i18nc("@action:button", "Color")
 *         icon.name: "color-picker"
 *     }
 *
 *     FormCard.FormDelegateSeparator {}
 *
 *     FormCard.FormButtonDelegate {
 *         text: i18nc("@action:button", "Icon")
 *         icon.name: "preferences-desktop-emoticons"
 *     }
 * }
 * \endcode{}
 *
 * \image html formcarddialog.png
 *
 * \since 1.1.0
 */
QQC2.Dialog {
    id: root

    default property alias content: columnLayout.data

    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    z: Kirigami.OverlayZStacking.z

    background: Components.DialogRoundedBackground {}

    parent: applicationWindow().QQC2.Overlay.overlay

    implicitWidth: Math.min(parent.width - Kirigami.Units.gridUnit * 2, Math.max(Kirigami.Units.gridUnit * 15, header.implicitWidth))

    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding
                             + (implicitHeaderHeight > 0 ? implicitHeaderHeight + spacing : 0)
                             + (implicitFooterHeight > 0 ? implicitFooterHeight + spacing : 0))

    modal: true
    focus: true

    padding: 0

    header: Kirigami.Heading {
        text: root.title
        elide: QQC2.Label.ElideRight
        leftPadding: Private.FormCardUnits.horizontalPadding
        rightPadding: Private.FormCardUnits.horizontalPadding
        topPadding: Private.FormCardUnits.verticalPadding
        bottomPadding: 0
    }

    contentItem: ColumnLayout {
        id: columnLayout

        spacing: 0
    }

    footer: QQC2.DialogButtonBox {
        leftPadding: Private.FormCardUnits.horizontalPadding
        rightPadding: Private.FormCardUnits.horizontalPadding
        bottomPadding: Private.FormCardUnits.verticalPadding
        topPadding: Kirigami.Units.smallSpacing
        spacing: Kirigami.Units.mediumSpacing

        standardButtons: root.standardButtons
        visible: count > 0
    }
}