/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtTest
import org.kde.kirigamiaddons.dateandtime as DateTime

Item {
    id: root
    width: 400
    height: 400

    DateTime.DatePicker {
        id: picker
        anchors.fill: parent
    }

    TestCase {
        name: "DatePickerNavTest"
        when: windowShown

        function init() {
            picker.selectedDate.dateTime = new Date(2024, 5, 15);
        }

        function test_prevNextMonth() {
            picker.nextMonth();
            compare(picker.selectedDate.month, 7);
            compare(picker.selectedDate.year, 2024);

            picker.prevMonth();
            picker.prevMonth();
            compare(picker.selectedDate.month, 5);
        }

        function test_prevNextYear() {
            picker.nextYear();
            compare(picker.selectedDate.year, 2025);
            picker.prevYear();
            compare(picker.selectedDate.year, 2024);
        }

        function test_prevNextDecade() {
            picker.nextDecade();
            compare(picker.selectedDate.year, 2034);
            picker.prevDecade();
            compare(picker.selectedDate.year, 2024);
        }

        function test_goToday() {
            picker.goToday();
            compare(picker.selectedDate.isToday, true);
        }

        function test_yearBoundaryMonthNav() {
            picker.selectedDate.dateTime = new Date(2024, 0, 10); // January
            picker.prevMonth();
            compare(picker.selectedDate.year, 2023);
            compare(picker.selectedDate.month, 12);
        }

        function test_dayClampingAcrossMonths() {
            // Jan 31 -> prevMonth should land in December (31 days), not roll over.
            picker.selectedDate.dateTime = new Date(2024, 0, 31);
            picker.prevMonth();
            compare(picker.selectedDate.year, 2023);
            compare(picker.selectedDate.month, 12);
        }
    }
}
