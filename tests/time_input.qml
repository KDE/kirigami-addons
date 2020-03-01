/*
 *   Copyright 2019 David Edmundson <davidedmundson@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1 as QQC2
import org.kde.kirigami 2.5 as Kirigami
import org.kde.kirigamiaddons.dateandtime 0.1 as Addon

Rectangle {
    ColumnLayout {
        ColumnLayout {
            Addon.TimeInput {
                id: timeInput
            }
            Text {
                text: 'Text: ' + timeInput.text
            }
            Text {
                text: 'Value: ' + timeInput.value
            }
            Text {
                text: 'Acceptable input: ' + timeInput.acceptableInput
            }
        }
        ColumnLayout {
            Addon.TimeInput {
                id: timeInput2
                format: 'hh.mm.ss'

                // I'm from the future and we still don't have flying cars... FTW???
                value: new Date('2042-10-10T22:24:25')

                onValueChanged: console.log('value has changed', value)
            }
            Text {
                text: 'Text: ' + timeInput2.text
            }
            Text {
                text: 'Value: ' + timeInput2.value
            }
            Text {
                text: 'Acceptable input: ' + timeInput2.acceptableInput
            }
        }
    }
}
