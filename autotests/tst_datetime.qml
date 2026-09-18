/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtTest
import org.kde.kirigamiaddons.dateandtime as DateTime

Item {
    id: root

    property DateTime.DateTime emptyDateTime
    property DateTime.DateTime dt

    TestCase {
        name: "DateTimeTest"

        function init() {
            dt.dateTime = new Date(2024, 2, 15, 10, 30, 45);
        }

        function test_defaultIsInvalid() {
            compare(root.emptyDateTime.isValid, false);
        }

        function test_componentAccessors() {
            compare(dt.isValid, true);
            compare(dt.year, 2024);
            compare(dt.month, 3);
            compare(dt.day, 15);
            compare(dt.hour, 10);
            compare(dt.minute, 30);
            compare(dt.second, 45);
        }

        function test_writingAFieldSticks() {
            dt.year = 2025;
            compare(dt.year, 2025);
            compare(dt.month, 3);
            compare(dt.day, 15);

            dt.hour = 23;
            compare(dt.hour, 23);
            compare(dt.minute, 30);
        }

        function test_timeZoneIsReadable() {
            verify(dt.timeZone !== undefined);
        }

        function test_addHelpersReturnANewValue() {
            dt.dateTime = new Date(2024, 0, 31, 0, 0, 0);

            const plusOneDay = dt.addDays(1);
            compare(plusOneDay.day, 1);
            compare(plusOneDay.month, 2);

            compare(dt.day, 31);
            compare(dt.month, 1);
        }

        function test_isToday() {
            compare(DateTime.DateTimeFactory.now().isToday, true);
            compare(dt.isToday, false);
        }

        function test_isCurrentMonthAndYear() {
            compare(DateTime.DateTimeFactory.now().isCurrentMonth, true);
            compare(DateTime.DateTimeFactory.now().isCurrentYear, true);
            compare(dt.isCurrentMonth, false);
            compare(dt.isCurrentYear, false);
        }

        function test_shortDate() {
            verify(!dt.shortDate.includes("2024"));
            verify(dt.shortDate.length > 0);
        }

        function test_factoryNow() {
            compare(DateTime.DateTimeFactory.now().isValid, true);
        }

        function test_factoryFromDateTime() {
            const fromFactory = DateTime.DateTimeFactory.fromDateTime(new Date(2024, 2, 15, 10, 30, 45));
            compare(fromFactory.year, 2024);
            compare(fromFactory.month, 3);
            compare(fromFactory.day, 15);
        }

        function test_toLocaleDateString() {
            compare(dt.toLocaleDateString("yyyy"), "2024");
        }

        function test_startOfDay() {
            const startOfDay = dt.startOfDay();
            compare(startOfDay.day, dt.day);
            compare(startOfDay.hour, 0);
            compare(startOfDay.minute, 0);
        }

        function test_startOfEndOfMonthAndYear() {
            compare(dt.startOfMonth().day, 1);
            compare(dt.startOfMonth().month, dt.month);

            compare(dt.endOfMonth().day, 31); // dt is in March
            compare(dt.endOfYear().month, 12);
            compare(dt.endOfYear().day, 31);
        }

        function test_factoryInvalid() {
            compare(DateTime.DateTimeFactory.invalid().isValid, false);
        }

        function test_infiniteCalendarViewModelUsesDateTime() {
            const model = infiniteCalendarViewModelComponent.createObject(root, {
                currentDate: dt
            });

            compare(model.currentDate.year, 2024);
            compare(model.currentDate.month, 3);
            compare(model.currentDate.day, 15);

            model.minimumDate = dt.addYears(-1);
            compare(model.minimumDate.year, 2023);

            model.destroy();
        }
    }

    Component {
        id: infiniteCalendarViewModelComponent
        DateTime.InfiniteCalendarViewModel {}
    }
}
