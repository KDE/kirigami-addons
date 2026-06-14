/*
 * SPDX-FileCopyrightText: 2026 Sandro Andrade <sandroandrade@kde.org>
 *
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtTest
import org.kde.kirigami.platform as Platform
import org.kde.kirigamiaddons.onboarding

Item {
    id: root

    width: 480
    height: 420

    property bool aboutToShowCalled: false
    property bool hideCalled: false
    property bool additionalDataCreated: false

    Item {
        id: viewTheme

        readonly property color backgroundColor: Platform.Theme.backgroundColor
        readonly property color disabledTextColor: Platform.Theme.disabledTextColor
        readonly property color highlightColor: Platform.Theme.highlightColor
        readonly property color textColor: Platform.Theme.textColor
        readonly property real frameContrast: Platform.Theme.frameContrast

        Platform.Theme.colorSet: Platform.Theme.Tooltip
        Platform.Theme.inherit: false
    }

    Component {
        id: additionalDataComponent

        Item {
            implicitHeight: 10
            implicitWidth: 10

            Component.onCompleted: root.additionalDataCreated = true
        }
    }

    Binding {
        target: Onboarding
        property: "additionalDataComponent"
        value: additionalDataComponent
    }

    Item {
        id: defaultSource

        width: parent.width
        height: 70

        Onboarding.isSource: true

        Rectangle {
            id: disabledStartTarget

            x: 10
            y: 10
            width: 40
            height: 30

            Onboarding.enabled: false
            Onboarding.texts: ["Disabled start target"]
        }

        Rectangle {
            id: firstTarget

            x: 70
            y: 10
            width: 50
            height: 40

            Onboarding.texts: ["First target"]
            Onboarding.additionalData: ({
                video: "first-target-video",
                videoCaption: "first-target-caption",
            })
        }
    }

    Item {
        id: navigationSource

        y: 80
        width: parent.width
        height: 70

        Onboarding.isSource: true
        Onboarding.sourceGroups: ["navigation"]

        Rectangle {
            id: navigationFirstTarget

            x: 10
            y: 10
            width: 40
            height: 30

            Onboarding.groups: ["navigation"]
            Onboarding.texts: ["First navigation target"]
        }

        Rectangle {
            id: disabledNavigationTarget

            x: 70
            y: 10
            width: 40
            height: 30

            Onboarding.enabled: false
            Onboarding.groups: ["navigation"]
            Onboarding.texts: ["Disabled navigation target"]
        }

        Rectangle {
            id: navigationSecondTarget

            x: 130
            y: 10
            width: 60
            height: 50

            Onboarding.groups: ["navigation"]
            Onboarding.texts: ["Second navigation target"]
        }
    }

    Item {
        id: callbackSource

        y: 160
        width: parent.width
        height: 70

        Onboarding.isSource: true
        Onboarding.sourceGroups: ["callback"]

        Rectangle {
            id: callbackTarget

            x: 20
            y: 20
            width: 70
            height: 40

            Onboarding.groups: ["callback"]
            Onboarding.texts: ["Callback target"]
            Onboarding.onAboutToShow: root.aboutToShowCalled = true
            Onboarding.onHide: root.hideCalled = true
        }
    }

    Item {
        id: declarationOrderSource

        y: 240
        width: parent.width
        height: 70

        Onboarding.isSource: true
        Onboarding.sourceGroups: ["declaration"]

        Rectangle {
            id: declaredFirstTarget

            x: 30
            y: 10
            width: 45
            height: 25

            Onboarding.groups: ["declaration"]
            Onboarding.texts: ["Declared first"]
        }

        Rectangle {
            id: declaredSecondTarget

            x: 95
            y: 10
            width: 55
            height: 35

            Onboarding.groups: ["declaration"]
            Onboarding.texts: ["Declared second"]
        }
    }

    Item {
        id: subComponentSource

        y: 320
        width: parent.width
        height: 70

        Onboarding.isSource: true
        Onboarding.sourceGroups: ["subcomponent"]

        QQC2.SpinBox {
            id: subComponentSpinBox

            x: 20
            y: 10
            width: 80

            up.indicator.Onboarding.groups: ["subcomponent"]
            up.indicator.Onboarding.texts: ["SpinBox up indicator"]
            down.indicator.Onboarding.groups: ["subcomponent"]
            down.indicator.Onboarding.texts: ["SpinBox down indicator"]
        }

        Rectangle {
            id: subComponentFollowingTarget

            x: 120
            y: 10
            width: 40
            height: 30

            Onboarding.groups: ["subcomponent"]
            Onboarding.texts: ["Following target"]
        }
    }

    Item {
        id: multiGroupSource

        x: 260
        y: 80
        width: 160
        height: 70

        Onboarding.isSource: true
        Onboarding.sourceGroups: ["multi", "advanced"]

        Rectangle {
            id: multiGroupTarget

            x: 10
            y: 10
            width: 50
            height: 30

            Onboarding.groups: ["multi", "advanced"]
            Onboarding.texts: ["Multi target", "Advanced target"]
        }
    }

    Item {
        id: ancestorMovementSource

        x: 260
        y: 160
        width: 160
        height: 70

        Onboarding.isSource: true
        Onboarding.sourceGroups: ["ancestor"]

        Item {
            id: movingAncestor

            x: 20
            width: parent.width
            height: parent.height

            Rectangle {
                id: ancestorMovementTarget

                x: 10
                y: 10
                width: 50
                height: 30

                Onboarding.groups: ["ancestor"]
                Onboarding.texts: ["Ancestor movement target"]
            }
        }
    }

    Item {
        id: additionalDataOnlySource

        x: 260
        y: 240
        width: 160
        height: 70

        Onboarding.isSource: true
        Onboarding.sourceGroups: ["dataonly"]

        Rectangle {
            id: additionalDataOnlyTarget

            x: 10
            y: 10
            width: 50
            height: 30

            Onboarding.groups: ["dataonly"]
            Onboarding.additionalData: ({
                video: "data-only-video",
                videoCaption: "data-only-caption",
            })
        }
    }

    Item {
        id: duplicateSourceA

        Onboarding.isSource: true
        Onboarding.sourceGroups: ["duplicate"]
    }

    Item {
        id: duplicateSourceB

        Onboarding.isSource: true
        Onboarding.sourceGroups: ["duplicate"]
    }

    Item {
        id: boundsSource

        width: root.width
        height: root.height

        Onboarding.isSource: true
        Onboarding.sourceGroups: ["bounds"]

        Rectangle {
            id: topEdgeTarget

            x: 2
            y: 2
            width: 40
            height: 30

            Onboarding.groups: ["bounds"]
            Onboarding.texts: ["Top edge target"]
        }

        Rectangle {
            id: bottomEdgeTarget

            x: parent.width - width - 2
            y: parent.height - height - 2
            width: 40
            height: 30

            Onboarding.groups: ["bounds"]
            Onboarding.texts: ["Bottom edge target"]
        }
    }

    SignalSpy {
        id: aboutToStartSpy

        target: Onboarding
        signalName: "aboutToStart"
    }

    SignalSpy {
        id: finishedSpy

        target: Onboarding
        signalName: "finished"
    }

    TestCase {
        name: "OnboardingTests"
        when: windowShown

        function init() {
            Onboarding.stop();
            aboutToStartSpy.clear();
            finishedSpy.clear();
            root.aboutToShowCalled = false;
            root.hideCalled = false;
            root.additionalDataCreated = false;
        }

        function test_start_selects_first_enabled_default_group_item() {
            Onboarding.start();

            compare(aboutToStartSpy.count, 1);
            tryCompare(Onboarding, "active", true);
            compare(Onboarding.source, defaultSource);
            compare(defaultSource.layer.enabled, true);
            tryCompare(Onboarding, "currentIndex", 1);
            tryCompare(Onboarding, "currentItem", firstTarget.Onboarding);
            compare(Onboarding.currentText, "First target");
            compare(Onboarding.currentItem.additionalData.video, "first-target-video");
            compare(Onboarding.currentItem.additionalData.videoCaption, "first-target-caption");
            tryCompare(Onboarding, "width", firstTarget.width + 2 * Onboarding.padding);
            tryCompare(Onboarding, "height", firstTarget.height + 2 * Onboarding.padding);
        }

        function test_stop_resets_state_and_source_layer() {
            Onboarding.start();
            tryCompare(Onboarding, "active", true);

            Onboarding.stop();

            compare(Onboarding.active, false);
            compare(defaultSource.layer.enabled, false);
            compare(Onboarding.currentIndex, -1);
            compare(Onboarding.currentItem, null);
            compare(finishedSpy.count, 1);
        }

        function test_next_and_previous_skip_disabled_items() {
            Onboarding.start("navigation");
            tryCompare(Onboarding, "currentItem", navigationFirstTarget.Onboarding);

            Onboarding.next();
            tryCompare(Onboarding, "currentItem", navigationSecondTarget.Onboarding);

            Onboarding.previous();
            tryCompare(Onboarding, "currentItem", navigationFirstTarget.Onboarding);
        }

        function test_keyboard_navigation_and_escape() {
            Onboarding.start("navigation");
            tryCompare(Onboarding, "currentItem", navigationFirstTarget.Onboarding);

            keyClick(Qt.Key_Right);
            tryCompare(Onboarding, "currentItem", navigationSecondTarget.Onboarding);

            keyClick(Qt.Key_Left);
            tryCompare(Onboarding, "currentItem", navigationFirstTarget.Onboarding);

            keyClick(Qt.Key_Escape);
            tryCompare(Onboarding, "active", false);
            compare(finishedSpy.count, 1);
        }

        function test_cancel_button_emits_finished_once() {
            Onboarding.start("bounds");
            tryCompare(Onboarding, "currentItem", topEdgeTarget.Onboarding);

            const cancelButton = findChild(root, "onboardingCancelButton");
            verify(cancelButton);
            verify(cancelButton.visible);

            mouseClick(cancelButton);

            tryCompare(Onboarding, "active", false);
            compare(finishedSpy.count, 1);

            Onboarding.stop();
            compare(finishedSpy.count, 1);
        }

        function test_tooltip_uses_view_colors_and_covers_content() {
            Onboarding.start();
            tryCompare(Onboarding, "currentItem", firstTarget.Onboarding);

            const toolTip = findChild(root, "onboardingToolTip");
            const background = findChild(root, "onboardingToolTipBackground");
            const label = findChild(root, "onboardingToolTipLabel");
            const separator = findChild(root, "onboardingNavigationSeparator");
            const cancelButton = findChild(root, "onboardingCancelButton");
            verify(toolTip);
            verify(background);
            verify(label);
            verify(separator);
            verify(cancelButton);

            tryCompare(background, "width", toolTip.width);
            tryCompare(background, "height", toolTip.height);
            verify(background.width >= toolTip.contentItem.width + toolTip.leftPadding + toolTip.rightPadding);
            verify(background.height >= toolTip.contentItem.height + toolTip.topPadding + toolTip.bottomPadding);
            compare(background.color, viewTheme.backgroundColor);
            compare(background.border.color, Platform.ColorUtils.linearInterpolation(viewTheme.backgroundColor, viewTheme.textColor, viewTheme.frameContrast));
            compare(label.color, viewTheme.textColor);
            compare(cancelButton.icon.color, viewTheme.textColor);
            compare(separator.color, background.border.color);
        }

        function test_tooltip_stays_inside_source_at_vertical_and_horizontal_edges() {
            Onboarding.start("bounds");
            tryCompare(Onboarding, "currentItem", topEdgeTarget.Onboarding);

            const toolTip = findChild(root, "onboardingToolTip");
            verify(toolTip);
            tryVerify(() => toolTip.width > 0 && toolTip.height > 0);
            wait(500);

            verify(toolTip.x + toolTip.parent.x >= toolTip.margins);
            verify(toolTip.x + toolTip.parent.x + toolTip.width <= boundsSource.width - toolTip.margins);
            verify(toolTip.y + toolTip.parent.y >= toolTip.margins);
            verify(toolTip.y + toolTip.parent.y + toolTip.height <= boundsSource.height - toolTip.margins);
            verify(toolTip.y >= toolTip.parent.height);

            Onboarding.next();
            tryCompare(Onboarding, "currentItem", bottomEdgeTarget.Onboarding);
            wait(500);

            verify(toolTip.x + toolTip.parent.x >= toolTip.margins);
            verify(toolTip.x + toolTip.parent.x + toolTip.width <= boundsSource.width - toolTip.margins);
            verify(toolTip.y + toolTip.parent.y >= toolTip.margins);
            verify(toolTip.y + toolTip.parent.y + toolTip.height <= boundsSource.height - toolTip.margins);
            verify(toolTip.y + toolTip.height <= 0);
        }

        function test_on_about_to_show_callback_runs_before_target_lookup() {
            Onboarding.start("callback");

            tryCompare(Onboarding, "active", true);
            tryCompare(root, "aboutToShowCalled", true);
            tryCompare(Onboarding, "width", callbackTarget.width + 2 * Onboarding.padding);
        }

        function test_on_hide_callback_runs_when_current_item_is_hidden() {
            Onboarding.start("callback");
            tryCompare(Onboarding, "currentItem", callbackTarget.Onboarding);

            Onboarding.stop();
            tryCompare(root, "hideCalled", true);
        }

        function test_declaration_order_is_used() {
            Onboarding.start("declaration");
            tryCompare(Onboarding, "currentItem", declaredFirstTarget.Onboarding);

            Onboarding.next();
            tryCompare(Onboarding, "currentItem", declaredSecondTarget.Onboarding);
        }

        function test_sub_component_attached_onboarding_item_can_be_highlighted_in_declaration_order() {
            Onboarding.start("subcomponent");

            let indicator = subComponentSpinBox.down.indicator;
            let mappedPosition = indicator.mapToItem(subComponentSource, 0, 0);
            tryCompare(Onboarding, "currentItem", indicator.Onboarding);
            tryCompare(Onboarding, "x", mappedPosition.x - indicator.Onboarding.padding);
            tryCompare(Onboarding, "y", mappedPosition.y - indicator.Onboarding.padding);
            tryCompare(Onboarding, "width", indicator.width + 2 * indicator.Onboarding.padding);
            tryCompare(Onboarding, "height", indicator.height + 2 * indicator.Onboarding.padding);

            Onboarding.next();
            indicator = subComponentSpinBox.up.indicator;
            mappedPosition = indicator.mapToItem(subComponentSource, 0, 0);
            tryCompare(Onboarding, "currentItem", indicator.Onboarding);
            tryCompare(Onboarding, "x", mappedPosition.x - indicator.Onboarding.padding);
            tryCompare(Onboarding, "y", mappedPosition.y - indicator.Onboarding.padding);
            tryCompare(Onboarding, "width", indicator.width + 2 * indicator.Onboarding.padding);
            tryCompare(Onboarding, "height", indicator.height + 2 * indicator.Onboarding.padding);

            Onboarding.next();
            tryCompare(Onboarding, "currentItem", subComponentFollowingTarget.Onboarding);
        }

        function test_additional_data_component_is_created() {
            Onboarding.start();

            tryCompare(Onboarding, "active", true);
            tryCompare(root, "additionalDataCreated", true);
        }

        function test_additional_data_only_step_participates() {
            Onboarding.start("dataonly");

            tryCompare(Onboarding, "active", true);
            tryCompare(Onboarding, "currentItem", additionalDataOnlyTarget.Onboarding);
            compare(Onboarding.currentText, "");
            compare(Onboarding.currentItem.additionalData.video, "data-only-video");
            compare(Onboarding.currentItem.additionalData.videoCaption, "data-only-caption");
        }

        function test_same_source_can_start_multiple_groups_with_different_texts() {
            Onboarding.start("multi");
            tryCompare(Onboarding, "currentItem", multiGroupTarget.Onboarding);
            compare(Onboarding.currentText, "Multi target");

            Onboarding.start("advanced");
            tryCompare(Onboarding, "currentItem", multiGroupTarget.Onboarding);
            compare(Onboarding.currentText, "Advanced target");
            compare(Onboarding.source, multiGroupSource);
        }

        function test_geometry_updates_when_target_ancestor_moves() {
            movingAncestor.x = 20;

            Onboarding.start("ancestor");
            tryCompare(Onboarding, "currentItem", ancestorMovementTarget.Onboarding);
            tryCompare(Onboarding, "x", 30 - Onboarding.padding);

            movingAncestor.x = 60;
            tryCompare(Onboarding, "x", 70 - Onboarding.padding);
        }

        function test_unknown_group_logs_warning_and_does_not_start() {
            ignoreWarning(/Onboarding: no source declares group "missing"/);

            Onboarding.start("missing");

            compare(Onboarding.active, false);
            compare(aboutToStartSpy.count, 0);
        }

        function test_duplicate_group_logs_warning_and_does_not_start() {
            ignoreWarning(/Onboarding: multiple sources declare group "duplicate"/);

            Onboarding.start("duplicate");

            compare(Onboarding.active, false);
            compare(aboutToStartSpy.count, 0);
        }
    }
}
