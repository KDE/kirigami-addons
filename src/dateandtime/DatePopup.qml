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
     * Emitted when the user cancells the popup
     * @deprecated Use rejected instead.
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

    /**
     * This property holds whether the date popup will automatically select a date
     * on selection or has a "Select" button.
     *
     * By default, this is false.
     */
    property bool autoAccept: false

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

        onDatePicked: (pickedDate) => {
            if (autoAccept) {
                root.value = pickedDate;
                root.accepted();
            }
        }
    }

    footer: QQC2.DialogButtonBox {
        id: box

        visible: !autoAccept

        leftPadding: Kirigami.Units.mediumSpacing
        rightPadding: Kirigami.Units.mediumSpacing
        bottomPadding: Kirigami.Units.mediumSpacing

        QQC2.Button {
            text: i18ndc("kirigami-addons6", "@action:button", "Cancel")
            icon.name: "dialog-cancel"
            onClicked: {
                root.cancelled()
                root.rejected()
                root.close()
            }

            QQC2.DialogButtonBox.buttonRole: QQC2.DialogButtonBox.RejectRole
        }

        QQC2.Button {
            text: i18ndc("kirigami-addons6", "@action:button", "Select")
            icon.name: "dialog-ok-apply"

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
