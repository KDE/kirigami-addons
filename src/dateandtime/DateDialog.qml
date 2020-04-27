/*
 *  SPDX-FileCopyrightText: 2020 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.5
import org.kde.kirigami 2.4 as Kirigami

import org.kde.kirigamiaddons.dateandtime 0.1 as KDT

Item {
    signal datePicked(date theDate)

    function open() {

        console.log("Succulent")

        if (Qt.platform.os === "android") {
            KDT.AndroidUtils.showDatePicker()
//             KDT.AndroidUtils.datePickerFinished.connect((accepted, date)=> console.log("oh boi"))
        } else {
            dialog.open()
        }
    }

//     onClicked: {
//         if (_isAndroid) {
//             _androidUtils.showDatePicker()
//         } else {
//             dialog.open()
//         }
//     }

    KDT.Fuck {
        onFoo: console.log("Here's a fuck")
    }

     Connections {
        target: KDT.AndroidUtils
        onDatePickerFinished: console.log("oh fucksing fucks")
        function onDatePickerFinished(succ, date) {
            console.log("I'm done")
            datePicked(date)
        }

        onFoo: console.log("wtse fuck?")
    }

    Dialog {
        id: dialog
        anchors.centerIn: Overlay.overlay
        height: Kirigami.Units.gridUnit * 6
        contentItem: KDT.DateInput {
            id: picker
        }

        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: datePicked(picker.selectedDate)
    }
}

