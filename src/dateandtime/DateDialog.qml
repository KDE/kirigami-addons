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
        if (Qt.platform.os === "android") {
            KDT.AndroidUtils.showDatePicker()
        } else {
            dialog.open()
        }
    }

     Connections {
        target: Qt.platform.os === "android" ? KDT.AndroidUtils : dummy
        onDatePickerFinished: (accepted, newDate) => {
            if (accepted) {
                datePicked(newDate)
            }
        }
    }

    // Dummy for AndroidUtils object when not on Android
    Item {
        id: dummy
        signal datePickerFinished(bool accepted, date theDate)
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
