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
    signal timePicked(date theTime)

    function open() {
        if (Qt.platform.os === "android") {
            KDT.AndroidUtils.showTimePicker()
        } else {
            dialog.open()
        }
    }

     Connections {
        target: Qt.platform.os === "android" ? KDT.AndroidUtils : dummy
        onTimePickerFinished: (accepted, newTime) => {
            if (accepted) {
                timePicked(newTime)
            }
        }
    }

    // Dummy for AndroidUtils object when not on Android
    QtObject {
        id: dummy
        signal timePickerFinished(bool accepted, date theTime)
    }

    Dialog {
        id: dialog
        anchors.centerIn: Overlay.overlay
        contentItem: KDT.TimePicker {
            id: picker
            implicitWidth: Kirigami.Units.gridUnit * 16
            implicitHeight: implicitWidth
        }

        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: {
            var time = new Date();
            time.setMinutes(picker.minutes)
            time.setHours(picker.hours)

            timePicked(time)
        }
    }
}
