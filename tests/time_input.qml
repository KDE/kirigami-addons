/*
 *   SPDX-FileCopyrightText: 2019 David Edmundson <davidedmundson@kde.org>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.20 as Kirigami
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
