/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtTest
import "../src/formcard" as FormCard

Item {
    id: root

    width: 400
    height: 400

    property int delegateCount: 0
    property int middleExtraHeight: 0

    FormCard.FormCard {
        id: card

        width: 300
        autoSeparators: true

        Repeater {
            id: delegates
            model: root.delegateCount

            Rectangle {
                required property int index

                Layout.fillWidth: true
                Layout.preferredHeight: implicitHeight
                implicitHeight: 20 + index * 12 + (index === 1 ? root.middleExtraHeight : 0)
            }
        }
    }

    function separators() {
        return card.children[0].children.filter(item => item.objectName === "automaticSeparator");
    }

    TestCase {
        name: "FormCardAutoSeparators"
        when: windowShown

        function test_repeaterChanges() {
            root.delegateCount = 1;
            compare(root.separators().length, 0);

            root.delegateCount = 3;
            compare(root.separators().length, 2);
            compare(root.separators()[0].above, delegates.itemAt(0));
            compare(root.separators()[0].below, delegates.itemAt(1));
            compare(root.separators()[1].above, delegates.itemAt(1));
            compare(root.separators()[1].below, delegates.itemAt(2));
            wait(50);
            compare(delegates.itemAt(0).height, 20);
            compare(delegates.itemAt(1).height, 32);
            compare(delegates.itemAt(2).height, 44);
            for (let i = 0; i < root.separators().length; ++i) {
                const separator = root.separators()[i];
                const above = delegates.itemAt(i);
                const below = delegates.itemAt(i + 1);
                verify(separator.height > 0);
                compare(separator.y, above.parent.y + above.y + above.height);
                compare(below.y - above.y - above.height, separator.height);
            }

            root.middleExtraHeight = 17;
            wait(50);
            compare(delegates.itemAt(1).height, 49);
            compare(root.separators()[1].y, delegates.itemAt(1).parent.y + delegates.itemAt(1).y + delegates.itemAt(1).height);
            root.middleExtraHeight = 0;

            root.delegateCount = 1;
            compare(root.separators().length, 0);
        }

        function test_visibilityAndToggle() {
            root.delegateCount = 3;
            delegates.itemAt(1).visible = false;
            compare(root.separators().length, 1);
            compare(root.separators()[0].above, delegates.itemAt(0));
            compare(root.separators()[0].below, delegates.itemAt(2));

            card.autoSeparators = false;
            compare(root.separators().length, 0);
            card.autoSeparators = true;
            compare(root.separators().length, 1);

            delegates.itemAt(1).visible = true;
            root.delegateCount = 0;
        }
    }
}
