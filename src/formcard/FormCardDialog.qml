// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

pragma ComponentBehavior: Bound

import org.kde.kirigamiaddons.components as Components
import org.kde.kirigamiaddons.formcard.templates as T

import "private" as Private

/*!
   \qmltype FormCardDialog
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A dialog designed to use FormCard delegates as its content.

   \qml
   import org.kde.kirigamiaddons.formcard as FormCard
   import QtQuick.Controls

   FormCard.FormCardDialog {
       title: "Add Thingy"
       autoSeparators: true

       standardButtons: Dialog.Ok | Dialog.Cancel
       FormCard.FormTextFieldDelegate {
           label: i18nc("@label:textbox Notebook name", "Name:")
       }

       FormCard.FormButtonDelegate {
           text: i18nc("@action:button", "Color")
           icon.name: "color-picker"
       }

       FormCard.FormButtonDelegate {
           text: i18nc("@action:button", "Icon")
           icon.name: "preferences-desktop-emoticons"
       }
   }
   \endqml

   \image formcarddialog.png

   \since 1.1.0
 */
T.FormCardDialog {
    _horizontalContentPadding: Private.FormCardUnits.horizontalPadding
    _verticalContentPadding: Private.FormCardUnits.verticalPadding

    background: Components.DialogRoundedBackground {}
}
