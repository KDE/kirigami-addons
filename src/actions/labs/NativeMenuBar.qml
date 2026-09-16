// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import Qt.labs.platform as Labs

import org.kde.kirigamiaddons.actions as KirigamiActions

/*!
   \qmltype NativeMenuBar
   \inqmlmodule org.kde.kirigamiaddons.actions.labs
   \brief An experimental native menu bar generated from all action collections.

   This API is experimental and may change without notice.

   NativeMenuBar combines menus with the same name from all action collections
   belonging to the application. Actions retain their state, icons, shortcuts,
   and trigger handlers.

   \qml
   import org.kde.kirigamiaddons.actions as KirigamiActions
   import org.kde.kirigamiaddons.actions.labs as KirigamiActionsLabs

   KirigamiActionsLabs.NativeMenuBar {
       application: root.application
   }
   \endqml
   \since 1.14.0
 */
Labs.MenuBar {
    id: root

    property KirigamiActions.AbstractKirigamiApplication application: null
    property QtObject collection: null
    property var generatedMenus: []
    property var generatedItems: []

    function resolvedCollections(): list<QtObject> {
        return application ? application.actionCollections() : (collection ? [collection] : []);
    }

    function clearMenus(): void {
        generatedItems.forEach(item => item.destroy());
        generatedMenus.forEach(menu => {
            root.removeMenu(menu);
            menu.destroy();
        });
        generatedItems = [];
        generatedMenus = [];
    }

    function populateMenu(menuData, target): void {
        menuData.mergedItems.forEach(itemData => {
            if (itemData.type === "separator") {
                target.addSeparator();
                return;
            }

            const resolvedAction = itemData.action;
            if (!resolvedAction) {
                return;
            }
            const item = nativeItemComponent.createObject(target, {
                actionName: itemData.name,
                actionObject: resolvedAction,
            });
            target.addItem(item);
            generatedItems.push(item);
        });

        menuData.mergedMenus.forEach(childMenuData => {
            const submenu = menuComponent.createObject(target, {
                title: childMenuData.text,
            });
            target.addMenu(submenu);
            populateMenu(childMenuData, submenu);
        });
    }

    function rebuild(): void {
        clearMenus();
        const collections = resolvedCollections();
        const menuNames = [];
        collections.forEach(actionCollection => {
            actionCollection.menus.forEach(menuData => {
                if (menuNames.includes(menuData.name)) {
                    return;
                }
                menuNames.push(menuData.name);
                const menu = menuComponent.createObject(root, {
                    title: menuData.text,
                });
                root.addMenu(menu);
                generatedMenus.push(menu);
                populateMenu(menuData, menu);
            });
        });
    }

    Component {
        id: nativeItemComponent

        NativeMenuItem {
            application: root.application
        }
    }

    Component {
        id: menuComponent

        Labs.Menu {}
    }

    Connections {
        target: root.collection
        function onMenusChanged(): void {
            root.rebuild();
        }
    }

    Connections {
        target: root.application
        function onActionCollectionsChanged(): void {
            root.rebuild();
        }
    }

    Component.onCompleted: Qt.callLater(() => Qt.callLater(root.rebuild))
}
