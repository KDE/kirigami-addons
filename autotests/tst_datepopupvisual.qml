/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtTest
import org.kde.kirigamiaddons.dateandtime as DateTime

Item {
    id: root

    QQC2.ApplicationWindow {
        id: window
        width: 480
        height: 640
        visible: true
    }

    Component {
        id: popupComponent
        DateTime.DatePopup {}
    }

    property var popup: null

    // findChild() doesn't reach Repeater-generated delegates.
    function findByObjectName(item: Item, name: string): Item {
        if (!item || !item.children) {
            return null;
        }
        for (let i = 0; i < item.children.length; i++) {
            const child = item.children[i];
            if (child.objectName === name) {
                return child;
            }
            const found = root.findByObjectName(child, name);
            if (found) {
                return found;
            }
        }
        return null;
    }

    TestCase {
        name: "DatePopupVisualTest"
        when: windowShown

        function findDay(dateString: string): Item {
            const monthPathView = findChild(root.popup, "monthPathView");
            const grid = monthPathView.currentItem.item;
            return root.findByObjectName(grid, "day-" + dateString);
        }

        // GridLayout hasn't necessarily positioned its children yet even once
        // the day exists, so a click right after can miss.
        function clickDay(dateString: string): void {
            tryVerify(() => findDay(dateString) !== null);
            wait(300);
            mouseClick(findDay(dateString));
        }

        function clickButton(objectName: string): void {
            tryVerify(() => findChild(root.popup, objectName) !== null);
            wait(300);
            mouseClick(findChild(root.popup, objectName));
        }

        function init(): void {
            root.popup = popupComponent.createObject(window.contentItem, {
                dateTime: DateTime.DateTimeFactory.fromDateTime(new Date(2024, 5, 15)),
            });
        }

        function cleanup(): void {
            if (root.popup) {
                root.popup.destroy();
                root.popup = null;
            }
        }

        function test_opensAndRenders(): void {
            root.popup.open();
            tryCompare(root.popup, "opened", true);

            const image = grabImage(root.popup.background);
            compare(image.width > 0, true);
            compare(image.height > 0, true);
        }

        function test_clickingADayUpdatesSelection(): void {
            root.popup.open();
            tryCompare(root.popup, "opened", true);

            clickDay("2024-6-20");

            compare(root.popup.contentItem.selectedDate.day, 20);
            compare(root.popup.contentItem.selectedDate.month, 6);
        }

        function test_selectButtonAccepts(): void {
            root.popup.open();
            tryCompare(root.popup, "opened", true);
            clickDay("2024-6-20");

            let acceptedCount = 0;
            const onAccepted = () => acceptedCount++;
            root.popup.accepted.connect(onAccepted);

            clickButton("selectButton");

            tryCompare(root.popup, "opened", false);
            compare(acceptedCount, 1);
            compare(root.popup.dateTime.day, 20);
            compare(root.popup.value.getDate(), 20);
        }

        function test_cancelButtonRejects(): void {
            root.popup.open();
            tryCompare(root.popup, "opened", true);

            let cancelledCount = 0;
            const onCancelled = () => cancelledCount++;
            root.popup.cancelled.connect(onCancelled);

            clickButton("cancelButton");

            tryCompare(root.popup, "opened", false);
            compare(cancelledCount, 1);
            compare(root.popup.dateTime.day, 15);
        }
    }
}
