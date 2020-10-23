/*
    SPDX-FileCopyrightText: 2019 Volker Krause <vkrause@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1 as QQC2
import org.kde.kirigami 2.5 as Kirigami
import org.kde.kirigamiaddons.dateandtime 0.1 as Addon

Kirigami.ApplicationWindow {
    title: "Date & Time Test"
    pageStack.initialPage: dateTimePage

    Component {
        id: dateTimePage
        Kirigami.Page {
            Kirigami.FormLayout {
                anchors.fill: parent
                Addon.DateInput {
                    id: dateInput
                    Kirigami.FormData.label: "Date"
                    onSelectedDateChanged: console.log(selectedDate)
                }


//                 Addon.TimeLabel {
//                 }

//                 Addon.TimePicker {
//                     id: timeInput
//                     Kirigami.FormData.label: "Time"
//                     // TODO value changes
//                 }

                // TODO date/time combined

                Addon.TimeZoneTable {
                    Kirigami.FormData.label: "Timezone"
                }

                QQC2.Button {
                    text: "Set to now"
                    onClicked: {
                        dateInput.value = new Date();
                        // TODO update timeInput
                    }
                }
            }
        }
    }
}
