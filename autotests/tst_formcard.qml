/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as Controls
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

    FormCard.FormSliderDelegate {
        id: sliderDelegate

        y: 120
        width: 300
        label: "Opacity"
        from: 0
        to: 1
        stepSize: 0.1
        valueText: `${Math.round(value * 100)}%`
        leading: Item { implicitWidth: 20; implicitHeight: 20 }
        trailing: Item { implicitWidth: 20; implicitHeight: 20 }
    }

    SignalSpy {
        id: sliderMovedSpy
        target: sliderDelegate
        signalName: "moved"
    }

    FormCard.FormGridContainer {
        id: grid

        QtObject {
            property string description: "A non-visual child"
        }

        Item {
            objectName: "nonControlChild"
        }

        FormCard.FormButtonDelegate {
            id: firstGridDelegate
        }

        Controls.Switch {
            id: secondGridDelegate
        }
    }

    Controls.Button {
        id: explicitGridDelegate
    }

    FormCard.FormGridContainer {
        id: explicitGrid

        delegates: [explicitGridDelegate]
    }

    FormCard.FormGridContainer {
        id: dynamicGrid
    }

    Component {
        id: dynamicGridDelegate

        Controls.Button {}
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

    TestCase {
        name: "FormGridContainerChildren"
        when: windowShown

        function test_controlChildren() {
            compare(grid.delegates.length, 2);
            compare(grid.delegates[0], firstGridDelegate);
            compare(grid.delegates[1], secondGridDelegate);
            compare(grid.hasDelegates, true);
        }

        function test_explicitDelegates() {
            compare(explicitGrid.delegates.length, 1);
            compare(explicitGrid.delegates[0], explicitGridDelegate);

            dynamicGridDelegate.createObject(explicitGrid);
            compare(explicitGrid.delegates.length, 1);
            compare(explicitGrid.delegates[0], explicitGridDelegate);
        }

        function test_controlsAddedAfterConstruction() {
            compare(dynamicGrid.delegates.length, 0);

            const first = dynamicGridDelegate.createObject(dynamicGrid);
            const second = dynamicGridDelegate.createObject(dynamicGrid);
            tryCompare(dynamicGrid.delegates, "length", 2);
            compare(dynamicGrid.delegates[0], first);
            compare(dynamicGrid.delegates[1], second);
            compare(dynamicGrid.hasDelegates, true);
        }
    }

    TestCase {
        name: "FormSliderDelegate"
        when: windowShown

        function test_valueAndUserMovement() {
            const slider = findChild(sliderDelegate, "formSlider");
            verify(slider !== null);
            verify(slider.width < sliderDelegate.width - 40);

            sliderMovedSpy.clear();
            sliderDelegate.value = 0.4;
            compare(sliderDelegate.valueText, "40%");
            compare(sliderMovedSpy.count, 0);

            slider.forceActiveFocus();
            keyClick(Qt.Key_Right);
            verify(Math.abs(sliderDelegate.value - 0.5) < 0.00001);
            compare(sliderMovedSpy.count, 1);
            compare(sliderDelegate.valueText, "50%");
        }
    }
}
