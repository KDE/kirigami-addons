/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtTest
import org.kde.kirigamiaddons.dateandtime as DateTime

Item {
    id: root

    DateTime.TimePopup {
        id: popup
    }

    TestCase {
        name: "TimePopupTest"

        function init() {
            popup.value = new Date(2024, 2, 15, 10, 30, 0);
        }

        function test_legacyValueSyncsToDateTime() {
            compare(popup.dateTime.isValid, true);
            compare(popup.dateTime.hour, 10);
            compare(popup.dateTime.minute, 30);
        }

        function test_editingDateTimeSyncsBackToLegacyValue() {
            popup.dateTime.hour = 18;
            popup.dateTime.minute = 45;

            compare(popup.value.getHours(), 18);
            compare(popup.value.getMinutes(), 45);
        }
    }
}
