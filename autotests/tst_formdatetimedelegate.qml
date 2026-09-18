/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtTest
import org.kde.kirigamiaddons.formcard as FormCard

Item {
    id: root

    FormCard.FormDateTimeDelegate {
        id: delegate
    }

    TestCase {
        name: "FormDateTimeDelegateTest"

        function init() {
            delegate.value = new Date(2024, 2, 15, 10, 30, 0);
        }

        function test_legacyValueSyncsToDateTime() {
            compare(delegate.dateTime.isValid, true);
            compare(delegate.dateTime.year, 2024);
            compare(delegate.dateTime.month, 3);
            compare(delegate.dateTime.day, 15);
            compare(delegate.dateTime.hour, 10);
            compare(delegate.dateTime.minute, 30);
        }

        function test_editingDateTimeSyncsBackToLegacyValue() {
            delegate.dateTime.year = 2030;
            delegate.dateTime.hour = 18;

            compare(delegate.value.getFullYear(), 2030);
            compare(delegate.value.getMonth(), 2); // JS Date months are 0-indexed
            compare(delegate.value.getDate(), 15);
            compare(delegate.value.getHours(), 18);
        }

        function test_initialValueSyncsToInitialDateTime() {
            delegate.initialValue = new Date(2020, 0, 1, 9, 0, 0);
            compare(delegate.initialDateTime.year, 2020);
            compare(delegate.initialDateTime.month, 1);
            compare(delegate.initialDateTime.day, 1);

            delegate.initialDateTime.year = 2021;
            compare(delegate.initialValue.getFullYear(), 2021);
        }

        function test_minimumAndMaximumDateSyncToDateTime() {
            delegate.minimumDate = new Date(2024, 0, 1);
            delegate.maximumDate = new Date(2024, 11, 31);

            compare(delegate.minimumDateTime.year, 2024);
            compare(delegate.minimumDateTime.month, 1);
            compare(delegate.maximumDateTime.month, 12);
            compare(delegate.maximumDateTime.day, 31);
        }
    }
}
