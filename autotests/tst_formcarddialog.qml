// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import QtTest
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

Item {
    id: root

    width: 640
    height: 480

    property int delegateCount: 0

    Kirigami.ApplicationWindow {
        id: window

        width: 640
        height: 480
        visible: true

        FormCard.FormCardDialog {
            id: dialog

            parent: window.Controls.Overlay.overlay
            autoSeparators: true

            Repeater {
                id: delegates
                model: root.delegateCount

                Rectangle {
                    required property int index

                    Layout.fillWidth: true
                    implicitHeight: 20 + index * 12
                }
            }
        }
    }

    function separators(): list<Item> {
        const result = [];
        const visit = item => {
            for (const child of item.children) {
                if (child.objectName === "automaticSeparator") {
                    result.push(child);
                }
                visit(child);
            }
        };
        visit(dialog.contentItem);
        return result;
    }

    TestCase {
        name: "FormCardDialogAutoSeparators"
        when: windowShown

        function test_separators() {
            dialog.open();
            tryCompare(dialog, "opened", true);

            root.delegateCount = 1;
            compare(root.separators().length, 0);

            root.delegateCount = 3;
            compare(root.separators().length, 2);
            compare(root.separators()[0].above, delegates.itemAt(0));
            compare(root.separators()[0].below, delegates.itemAt(1));
            compare(root.separators()[1].above, delegates.itemAt(1));
            compare(root.separators()[1].below, delegates.itemAt(2));

            // Separators sit in the gap between delegates.
            tryVerify(() => delegates.itemAt(1).y > 0);
            for (let i = 0; i < root.separators().length; ++i) {
                const separator = root.separators()[i];
                const above = delegates.itemAt(i);
                const below = delegates.itemAt(i + 1);
                verify(separator.y >= above.y + above.height);
                verify(separator.y + separator.height <= below.y);
            }

            delegates.itemAt(1).visible = false;
            compare(root.separators().length, 1);
            compare(root.separators()[0].above, delegates.itemAt(0));
            compare(root.separators()[0].below, delegates.itemAt(2));

            dialog.autoSeparators = false;
            compare(root.separators().length, 0);
            dialog.autoSeparators = true;
            compare(root.separators().length, 1);

            delegates.itemAt(1).visible = true;
            root.delegateCount = 0;
            dialog.close();
        }
    }
}
