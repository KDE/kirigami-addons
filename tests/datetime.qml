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

                QQC2.Button {
                    text: "set to now"
                    onClicked: dateInput.selectedDate = new Date()
                }

                Addon.TimeInput {
                    id: timeInput
                    Kirigami.FormData.label: "Time"
                    onValueChanged: console.log(value)
                }

                QQC2.Button {
                    text: "Set to now"
                    onClicked: {
                        timeInput.value = new Date();
                    }
                }
            }
        }
    }
}
