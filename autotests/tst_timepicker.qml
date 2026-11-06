// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtTest
import QtQuick.Controls as QQC2
import org.kde.kirigamiaddons.dateandtime as DateTime

TestCase {
    id: testCase
    name: "TimePicker"
    width: 600
    height: 400
    visible: true
    when: windowShown

    readonly property bool isAmPm: Qt.locale().timeFormat().toLowerCase().includes("ap")

    Component {
        id: pickerComponent
        DateTime.TimePicker {}
    }

    function test_initialTime_data() {
        return [
            { tag: "midnight", hours: 0, minutes: 0 },
            { tag: "noon", hours: 12, minutes: 30 },
            { tag: "evening", hours: 23, minutes: 59 }
        ];
    }

    function test_initialTime(data) {
        const picker = createTemporaryObject(pickerComponent, testCase, {
            hours: data.hours, minutes: data.minutes
        });
        verify(picker);
        const hours = findChild(picker, "hoursInput");
        const minutes = findChild(picker, "minutesInput");
        compare(hours.text, picker.formatNumber(isAmPm ? (data.hours % 12 || 12) : data.hours));
        compare(minutes.text, picker.formatNumber(data.minutes));
        verify(hours.acceptableInput);
        verify(minutes.acceptableInput);
        compare(findChild(picker, "amButton").checked, data.hours < 12);
        compare(findChild(picker, "pmButton").checked, data.hours >= 12);
        verify(hours.visible);
        verify(minutes.visible);
    }

    function test_validation_data() {
        return [
            { tag: "hour-noon", field: "hoursInput", text: "12", acceptable: true },
            { tag: "hour-single-digit", field: "hoursInput", text: "9", acceptable: true },
            { tag: "hour-midnight", field: "hoursInput", text: "00", acceptable: !isAmPm },
            { tag: "hour-24-hour", field: "hoursInput", text: "23", acceptable: !isAmPm },
            { tag: "hour-out-of-range", field: "hoursInput", text: "24", acceptable: false },
            { tag: "minute-out-of-range", field: "minutesInput", text: "60", acceptable: false },
            { tag: "minute-last", field: "minutesInput", text: "59", acceptable: true },
            { tag: "incomplete", field: "hoursInput", text: "", acceptable: false }
        ];
    }

    function test_validation(data) {
        const picker = createTemporaryObject(pickerComponent, testCase);
        verify(picker);
        const input = findChild(picker, data.field);
        input.text = data.text;
        compare(input.acceptableInput, data.acceptable);
    }
}
