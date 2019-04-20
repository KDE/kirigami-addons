/*
    Copyright (C) 2019 Volker Krause <vkrause@kde.org>

    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU Library General Public License as published by
    the Free Software Foundation; either version 2 of the License, or (at your
    option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Library General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
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
                    onValueChanged: console.log(value)
                }

                Addon.TimePicker {
                    id: timeInput
                    Kirigami.FormData.label: "Time"
                    // TODO value changes
                }

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
