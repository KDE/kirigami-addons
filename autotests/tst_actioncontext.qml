/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtTest
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.actions

Item {
    id: root

    ActionContext {
        id: context
    }

    ActionContext {
        id: childContext
        parentContext: context
    }

    ActionContext {
        id: highPriorityContext
        active: false
        priority: 20
    }

    Kirigami.Action {
        id: primaryAction
    }

    ActionGroup {
        id: viewModes
        exclusive: true
    }

    ActionCollection {
        ActionData {
            id: singlePage
            name: "single_page"
            checkable: true
            actionGroup: viewModes
        }

        ActionData {
            id: continuousPage
            name: "continuous_page"
            checkable: true
            actionGroup: viewModes
        }

        ActionData {
            id: action
            name: "test_action"
            action: primaryAction
            contexts: [childContext, highPriorityContext]
        }
    }

    TestCase {
        name: "ActionContextTest"

        function test_activeState() {
            compare(context.active, true);
            compare(context.contextActive, true);
            compare(childContext.contextActive, true);
            compare(action.contextActive, true);
            compare(action.activeContext, childContext);
            compare(action.enabled, true);
            compare(action.visible, true);
        }

        function test_contextDisablesAction() {
            context.active = false;
            tryCompare(action, "contextActive", false);
            compare(action.enabled, false);
            compare(action.visible, false);

            context.active = true;
            tryCompare(action, "contextActive", true);
            compare(action.enabled, true);
            compare(action.visible, true);
        }

        function test_parentContext() {
            childContext.active = false;
            tryCompare(childContext, "contextActive", false);
            compare(action.contextActive, false);

            childContext.active = true;
            tryCompare(childContext, "contextActive", true);
            compare(action.contextActive, true);

            context.active = false;
            tryCompare(childContext, "contextActive", false);
            compare(action.contextActive, false);
            context.active = true;
        }

        function test_baseStateIsRestored() {
            action.enabled = false;
            action.visible = false;
            context.active = false;
            tryCompare(action, "contextActive", false);

            context.active = true;
            tryCompare(action, "contextActive", true);
            compare(action.enabled, false);
            compare(action.visible, false);

            action.enabled = true;
            action.visible = true;
        }

        function test_priority() {
            context.priority = 10;
            childContext.priority = 20;
            highPriorityContext.priority = 30;
            highPriorityContext.active = true;
            compare(action.activeContext, highPriorityContext);

            highPriorityContext.priority = 5;
            compare(action.activeContext, childContext);

            highPriorityContext.active = false;
            childContext.priority = 0;
            context.priority = 0;
        }

        function test_contextPolicies() {
            action.contextEnabled = false;
            action.contextVisible = false;
            context.active = false;
            tryCompare(action, "contextActive", false);
            compare(action.enabled, true);
            compare(action.visible, true);

            action.contextEnabled = true;
            action.contextVisible = true;
            tryCompare(action, "enabled", false);
            compare(action.visible, false);
            context.active = true;
        }

        function test_primaryActionStateBridge() {
            context.active = false;
            tryCompare(primaryAction, "enabled", false);
            tryCompare(primaryAction, "visible", false);

            context.active = true;
            tryCompare(primaryAction, "enabled", true);
            tryCompare(primaryAction, "visible", true);
        }

        function test_actionGroup() {
            singlePage.checked = true;
            continuousPage.checked = true;
            compare(singlePage.checked, false);
            compare(continuousPage.checked, true);
        }
    }
}
