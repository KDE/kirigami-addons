// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami

/*! 
    \qmltype ActionMenuBar
    \inqmlmodule org.kde.kirigamiaddons.actions
    \brief Presents all ActionCollections belonging to an application as a menu bar.

    The menu bar uses the ActionMenu declarations from an ActionCollection.
    Contributions with the same menu name are merged, and named actions keep
    their original QAction state and trigger handlers.

    \qml
    KirigamiActions.ActionMenuBar {
        application: root.application
    }
    \endqml

    \since 1.8.0
 */
QQC2.MenuBar {
    id: root

    property QtObject application: null
    property QtObject collection: null
    property var topMenus: []
    property var generatedActions: []

    function resolvedCollections() {
        return application ? application.actionCollections() : (collection ? [collection] : []);
    }

    function clearMenus(): void {
        generatedActions.forEach(action => action.destroy());
        topMenus.forEach(menu => {
            root.removeMenu(menu);
            menu.destroy();
        });
        generatedActions = [];
        topMenus = [];
    }

    function populateMenu(menuData, target): void {
        menuData.mergedItems.forEach(itemData => {
            if (itemData.type === "separator") {
                target.addItem(separatorComponent.createObject(target));
                return;
            }
            const resolvedAction = itemData.action;
            if (!resolvedAction) {
                return;
            }
            const item = itemComponent.createObject(target, {
                action: actionComponent.createObject(root, {
                    fromQAction: resolvedAction,
                }),
            });
            target.addItem(item);
            generatedActions.push(item.action);
        });

        menuData.mergedMenus.forEach(childMenuData => {
            const submenu = menuComponent.createObject(target, {
                title: childMenuData.text,
            });
            submenu.icon.name = childMenuData.iconName;
            target.addMenu(submenu);
            populateMenu(childMenuData, submenu);
        });
    }

    function appendMenu(menuData): void {
        const menu = menuComponent.createObject(root, {
            title: menuData.text,
        });
        menu.icon.name = menuData.iconName;
        root.addMenu(menu);
        topMenus.push(menu);
        populateMenu(menuData, menu);
    }

    function rebuild(): void {
        clearMenus();
        const collections = resolvedCollections();
        if (collections.length === 0) {
            return;
        }

        const menuEntries = [];
        const menuNames = [];
        collections.forEach(actionCollection => {
            actionCollection.menus.forEach(menuData => {
                if (menuData.menuBarVisible && !menuNames.includes(menuData.name)) {
                    menuNames.push(menuData.name);
                    menuEntries.push({
                        name: menuData.name,
                        data: menuData,
                    });
                }
            });
        });

        const standardMenuOrder = ["file", "edit", "view"];
        const lastMenuOrder = ["settings", "help"];
        menuEntries.sort((first, second) => {
            const firstIndex = standardMenuOrder.indexOf(first.name);
            const secondIndex = standardMenuOrder.indexOf(second.name);
            const firstLastIndex = lastMenuOrder.indexOf(first.name);
            const secondLastIndex = lastMenuOrder.indexOf(second.name);
            const firstOrder = firstIndex >= 0 ? firstIndex
                : firstLastIndex >= 0 ? standardMenuOrder.length + 1 + firstLastIndex
                : standardMenuOrder.length;
            const secondOrder = secondIndex >= 0 ? secondIndex
                : secondLastIndex >= 0 ? standardMenuOrder.length + 1 + secondLastIndex
                : standardMenuOrder.length;
            return firstOrder - secondOrder;
        });
        menuEntries.forEach(entry => appendMenu(entry.data));
    }

    Component {
        id: actionComponent

        Kirigami.Action {}
    }

    Component {
        id: itemComponent

        QQC2.MenuItem {}
    }

    Component {
        id: separatorComponent

        QQC2.MenuSeparator {}
    }

    Component {
        id: menuComponent

        QQC2.Menu {}
    }

    Connections {
        target: root.collection
        function onMenusChanged(): void {
            root.rebuild();
        }
        function onChanged(): void {
            root.rebuild();
        }
    }

    Connections {
        target: root.application
        function onActionCollectionsChanged(): void {
            root.rebuild();
        }
        function onObjectNameChanged(): void {
            root.rebuild();
        }
    }

    Component.onCompleted: Qt.callLater(() => Qt.callLater(root.rebuild))
}
