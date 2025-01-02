// SPDX-FileCopyrightText: 2018 Aleix Pol Gonzalez <aleixpol@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

QQC2.Menu {
    id: root

    property alias actions: actionsInstantiator.model

    required property Component submenuComponent
    property Component itemDelegate: ActionMenuItem {}
    property Component separatorDelegate: QQC2.MenuSeparator {
        property T.Action action
        visible: !(action instanceof Kirigami.Action) || action.visible
    }
    property Component loaderDelegate: Loader {
        property T.Action action
    }
    property T.Action parentAction
    property T.MenuItem parentItem

    visible: !(parentAction instanceof Kirigami.Action) || parentAction.visible

    Instantiator {
        id: actionsInstantiator

        active: root.visible
        delegate: QtObject {
            id: delegate

            required property T.Action modelData
            readonly property T.Action action: modelData

            property QtObject item: null
            property bool isSubMenu: false

            Component.onCompleted: {
                const isKirigamiAction = delegate.action instanceof Kirigami.Action;
                if (!isKirigamiAction || delegate.action.children.length === 0) {
                    if (isKirigamiAction && delegate.action.separator) {
                        item = root.separatorDelegate.createObject(null, { action: delegate.action });
                    } else if (action.displayComponent) {
                        item = root.loaderDelegate.createObject(null, {
                            actions: delegate.action,
                            sourceComponent: action.displayComponent,
                        });
                    } else {
                        item = root.itemDelegate.createObject(null, { action: delegate.action });
                    }
                    root.addItem(item);
                } else if (root.submenuComponent) {
                    item = root.submenuComponent.createObject(null, {
                        parentAction: delegate.action,
                        title: delegate.action.text,
                        actions: delegate.action.children,
                        submenuComponent: root.submenuComponent,
                    });

                    if (item.visible) {
                        root.insertMenu(root.count, item);
                        item.parentItem = root.contentData[root.contentData.length - 1];
                        item.parentItem.icon = delegate.action.icon;
                        isSubMenu = true;
                    }
                }
            }

            Component.onDestruction: {
                if (isSubMenu) {
                    root.removeMenu(item);
                } else {
                    root.removeItem(item);
                }
                item.destroy();
            }
        }
    }
}
