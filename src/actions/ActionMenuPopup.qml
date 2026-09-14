// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as KirigamiComponents

/*! 
    \qmltype ActionMenuPopup
    \inqmlmodule org.kde.kirigamiaddons.actions
    \brief Presents an ActionMenu as a convergent menu popup.

    The menu keeps its items backed by the original QAction instances. Consequently action
    state, shortcuts and trigger handlers remain owned by ActionData.

    Menus with the same name contribute to the same logical menu through
    ActionMenu.mergedActions. Nested ActionMenu objects become submenus.
    On desktop this is a traditional menu; on mobile it is a bottom drawer.

    \qml
    KirigamiActions.ActionMenu {
        id: fileMenu
        name: "file"
        text: i18nc("@title:menu", "File")
        actions: ["open", "save"]
    }

    KirigamiActions.ActionMenuPopup {
        menu: fileMenu
    }
    \endqml

    \since 1.8.0
 */
Item {
    id: root

    required property QtObject menu
    property alias displayMode: contextMenu.displayMode
    readonly property alias opened: contextMenu.opened
    property var generatedActions: []

    function createItem(actionMenu, itemData) {
        if (itemData.type === "separator") {
            return actionComponent.createObject(root, { separator: true });
        }
        const resolvedAction = itemData.action;
        return resolvedAction ? actionComponent.createObject(root, {
            fromQAction: resolvedAction,
        }) : null;
    }

    function createSubmenu(actionMenu) {
        const action = actionComponent.createObject(root, {
            text: actionMenu.text,
        });
        action.icon.name = actionMenu.iconName;
        action.children = actionMenu.mergedItems.map(item => createItem(actionMenu, item)).filter(item => item);
        actionMenu.mergedMenus.forEach(childMenu => action.children.push(createSubmenu(childMenu)));
        return action;
    }

    function rebuild(): void {
        generatedActions.forEach(action => action.destroy());
        generatedActions = [];
        if (!menu) {
            return;
        }

        const actions = menu.mergedItems.map(item => createItem(menu, item)).filter(item => item);
        menu.mergedMenus.forEach(childMenu => actions.push(createSubmenu(childMenu)));
        generatedActions = actions;
    }

    function popup(parent = null, position = null): void {
        contextMenu.popup(parent, position);
    }

    function close(): void {
        contextMenu.close();
    }

    Component {
        id: actionComponent

        Kirigami.Action {}
    }

    Connections {
        target: root.menu
        function onMergedActionsChanged(): void {
            root.rebuild();
        }
        function onMergedItemsChanged(): void {
            root.rebuild();
        }
        function onMergedMenusChanged(): void {
            root.rebuild();
        }
    }

    Connections {
        target: root.menu?.collection
        function onInserted(): void {
            root.rebuild();
        }
        function onActionsChanged(): void {
            root.rebuild();
        }
    }

    Component.onCompleted: Qt.callLater(root.rebuild)

    KirigamiComponents.ConvergentContextMenu {
        id: contextMenu
        actions: root.generatedActions
    }
}
