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

import QtQuick 2.0
import QtQuick.Controls 2.5
import org.kde.kirigamiaddons.dateandtime 0.1

/**
 * TimeInput is a single line time editor.
 */
TextField
{
    id: timeInput

    /**
     * This property holds the desired time format.
     */
    property string format: Qt.locale().timeFormat(Locale.ShortFormat)

    /**
     * This property holds the current time value.
     */
    property date value: new Date()

    // The text field acts as a time input field.
    inputMethodHints: Qt.ImhTime

    validator: TimeInputValidator {
        id: timeValidator
        format: timeInput.format
    }

    onEditingFinished: textToValue()
    onValueChanged: valueToText()

    function textToValue() {
        const locale = Qt.locale();
        timeInput.value = Date.fromLocaleTimeString(locale, timeInput.text, timeInput.format);
    }

    function valueToText() {
        const locale = Qt.locale();
        timeInput.text = timeInput.value.toLocaleTimeString(locale, timeInput.format);
    }

    Component.onCompleted: valueToText()
}
