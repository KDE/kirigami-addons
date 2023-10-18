// SPDX-FileCopyrightText: 2019 David Edmundson <davidedmundson@kde.org>
// SPDX-FileCopyrightText: 2021 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.19 as Kirigami
import org.kde.kirigamiaddons.components 1.0 as Components
import './private/' as P

/**
 * A popup that prompts the user to select a date
 */
QQC2.Dialog {
    id: root

    /**
     * @brief The current date and time selected by the user.
     */
    property date value: new Date()

    /**
     * Emitted when the user accepts the dialog.
     * The selected date is available from the selectedDate property.
     */
    signal accepted()

    /**
     * Emitted when the user cancells the popup
     */
    signal cancelled()

    /**
     * This property holds the minimum date (inclusive) that the user can select.
     *
     * By default, no limit is applied to the date selection.
     */
    property date minimumDate

    /**
     * This property holds the maximum date (inclusive) that the user can select.
     *
     * By default, no limit is applied to the date selection.
     */
    property date maximumDate

    padding: 0
    topPadding: undefined
    leftPadding: undefined
    rightPadding: undefined
    bottomPadding: undefined
    verticalPadding: undefined
    horizontalPadding: undefined

    header: null

    contentItem: P.DatePicker {
        id: datePicker
        selectedDate: root.value
        minimumDate: root.minimumDate
        maximumDate: root.maximumDate
        focus: true
    }

    footer: Components.MessageDialogButtonBox {
        id: box

        Components.MessageDialogButton {
            text: i18ndc("kirigami-addons", "@action:button", "Cancel")
            icon.name: "dialog-cancel"
            buttonBox: box
            onClicked: {
                root.cancelled()
                root.close()
            }

            QQC2.DialogButtonBox.buttonRole: QQC2.DialogButtonBox.RejectRole
        }

        Components.MessageDialogButton {
            text: i18ndc("kirigami-addons", "@action:button", "Select")
            icon.name: "dialog-ok-apply"
            buttonBox: box

            onClicked: {
                root.value = datePicker.selectedDate;
                root.accepted()
                root.close()
            }

            QQC2.DialogButtonBox.buttonRole: QQC2.DialogButtonBox.AcceptRole
        }
    }

    background: Components.DialogRoundedBackground {}

    // black background, fades in and out
    QQC2.Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.3)

        // the opacity of the item is changed internally by QQuickPopup on open/close
        Behavior on opacity {
            OpacityAnimator {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
    }
}
