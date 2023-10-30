// SPDX-FileCopyrightText: 2023 Tobias Fella <tobias.fella@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

Kirigami.Dialog {
    id: root

    preferredWidth: Kirigami.Units.gridUnit * 24

    required property int index
    required property ToolBarStateManager manager
    property alias text: textField.text

    signal displayChanged(int mode)

    title: i18nc("@title", "Edit Button")

    FormCard.FormCard {
        FormCard.FormComboBoxDelegate {
            text: i18n("Display mode")
            model: ["Icon Only", "Text Only", "Text and Icon"]
            onCurrentIndexChanged: {
                root.displayChanged(currentIndex) //TODO only when save is pressed
                manager.setDisplayMode(root.index, currentIndex)
            }
        }
        FormCard.FormTextFieldDelegate {
            id: textField
            label: i18n("Text")
            text: root.text
            onTextChanged: {
                //TODO only when saved
                //manager.setText(root.index, text)
            }
        }
    }

    standardButtons: QQC2.Dialog.Save | QQC2.Dialog.Cancel
}
