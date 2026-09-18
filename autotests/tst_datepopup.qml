/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtTest
import org.kde.kirigamiaddons.dateandtime as DateTime

Item {
    id: root

    DateTime.DatePopup {
        id: popup
    }

    TestCase {
        name: "DatePopupTest"

        function init() {
            popup.value = new Date(2024, 2, 15);
        }

        function test_legacyValueSyncsToDateTime() {
            compare(popup.dateTime.isValid, true);
            compare(popup.dateTime.year, 2024);
            compare(popup.dateTime.month, 3);
            compare(popup.dateTime.day, 15);
        }

        function test_editingDateTimeSyncsBackToLegacyValue() {
            popup.dateTime.year = 2030;
            popup.dateTime.day = 20;

            compare(popup.value.getFullYear(), 2030);
            compare(popup.value.getMonth(), 2); // JS Date months are 0-indexed
            compare(popup.value.getDate(), 20);
        }

        function test_minimumAndMaximumDateSyncToDateTime() {
            popup.minimumDate = new Date(2024, 0, 1);
            popup.maximumDate = new Date(2024, 11, 31);

            compare(popup.minimumDateTime.year, 2024);
            compare(popup.minimumDateTime.month, 1);
            compare(popup.maximumDateTime.month, 12);
            compare(popup.maximumDateTime.day, 31);
        }
    }
}
