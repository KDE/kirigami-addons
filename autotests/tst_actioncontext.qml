/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtTest
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.actions
import org.kde.kirigamiaddons.actions as KirigamiActions
import org.kde.kirigamiaddons.actions.labs as KirigamiActionsLabs
import Qt.labs.platform as Labs

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

    KirigamiActionsLabs.NativeMenuItem {
        id: aboutMenuItem
        actionName: "open_about_page"
    }

    KirigamiActionsLabs.NativeMenuItem {
        id: preferencesMenuItem
        actionName: "options_configure"
    }

    KirigamiActionsLabs.NativeMenuItem {
        id: quitMenuItem
        actionName: "file_quit"
    }

    ActionGroup {
        id: viewModes
        exclusive: true
    }

    KirigamiActions.Application {
        id: application
    }

    ActionCollection {
        id: actionCollection
        application: application
        menus: [
            ActionMenu {
                id: fileMenu
                name: "file"
                text: "File"

                ActionMenu.Action {
                    name: "single_page"
                }
                ActionMenu.Separator {}

                menus: [
                    ActionMenu {
                        name: "recent"
                        actions: ["recent_one"]
                    }
                ]
            },
            ActionMenu {
                name: "file"
                actions: ["continuous_page"]

                menus: [
                    ActionMenu {
                        name: "recent"
                        actions: ["recent_two"]
                    }
                ]
            }
        ]

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
            id: recentOne
            name: "recent_one"
        }

        ActionData {
            id: recentTwo
            name: "recent_two"
        }

        ActionData {
            id: action
            name: "test_action"
            action: primaryAction
            contexts: [childContext, highPriorityContext]
        }
    }

    ActionCollection {
        id: dynamicCollection
        name: "dynamic"

        menus: [
            ActionMenu {
                id: dynamicMenu
                name: "tools"
                text: "Tools"
                actions: ["dynamic_action"]
            },
            ActionMenu {
                name: "file"
                actions: ["missing_action"]
            }
        ]

        ActionData {
            id: dynamicAction
            name: "dynamic_action"
            text: "Dynamic action"
        }
    }

    ActionMenuPopup {
        id: fileMenuPopup
        menu: fileMenu
    }

    ActionMenuBar {
        id: fileMenuBar
        application: application
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

        function test_actionMenuMergesContributions() {
            compare(fileMenu.mergedActions, ["single_page", "continuous_page"]);
            compare(fileMenu.mergedItems, [
                { type: "action", name: "single_page" },
                { type: "separator" },
                { type: "action", name: "continuous_page" },
            ]);
            compare(fileMenu.mergedMenus.length, 1);
            compare(fileMenu.mergedMenus[0].mergedActions, ["recent_one", "recent_two"]);
        }

        function test_actionMenuPopupResolvesActions() {
            compare(fileMenuPopup.generatedActions.length, 4);
            compare(fileMenuPopup.generatedActions[0].fromQAction, singlePage);
            compare(fileMenuPopup.generatedActions[1].separator, true);
            compare(fileMenuPopup.generatedActions[2].fromQAction, continuousPage);
            compare(fileMenuPopup.generatedActions[3].children[0].fromQAction, recentOne);
            compare(fileMenuPopup.generatedActions[3].children[1].fromQAction, recentTwo);
        }

        function test_actionMenuBarMergesMenus() {
            compare(fileMenuBar.resolvedCollections().length, 2);
            tryCompare(fileMenuBar, "count", 1);
            compare(fileMenuBar.menuAt(0).title, "File");
        }

        function test_dynamicCollectionAndActionUpdates() {
            compare(fileMenuBar.count, 1);

            dynamicCollection.application = application;
            tryCompare(fileMenuBar, "count", 2);
            compare(fileMenuBar.menuAt(0).count, 4);
            compare(fileMenuBar.menuAt(1).title, "Tools");
            tryCompare(fileMenuBar.menuAt(1).itemAt(0), "text", "Dynamic action");

            dynamicAction.text = "Updated action";
            tryCompare(fileMenuBar.menuAt(1).itemAt(0), "text", "Updated action");
            dynamicAction.enabled = false;
            tryCompare(fileMenuBar.menuAt(1).itemAt(0), "enabled", false);

            dynamicMenu.name = "file";
            tryCompare(fileMenuBar, "count", 1);
            tryCompare(fileMenuBar.menuAt(0), "count", 5);

            dynamicMenu.name = "tools";
            tryCompare(fileMenuBar, "count", 2);
        }

        function test_nativeMenuItemRoles() {
            compare(aboutMenuItem.role, Labs.MenuItem.AboutRole);
            compare(preferencesMenuItem.role, Labs.MenuItem.PreferencesRole);
            compare(quitMenuItem.role, Labs.MenuItem.QuitRole);
        }
    }
}
