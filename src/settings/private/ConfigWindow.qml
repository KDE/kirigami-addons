// SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-FileCopyrightText: 2021 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-FileCopyrightText: 2021 Marco Martin <mart@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQml
import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.delegates as Delegates
import org.kde.kirigamiaddons.settings

Kirigami.ApplicationWindow {
    id: root

    required property string defaultModule
    required property list<ConfigurationModule> modules

    // Do not use Map, it crashes very frequently
    property var pageCache: Object.create(null)
    property ConfigurationModule currentModule: null

    ConfigurationSearch {
        id: configurationSearch
        modules: root.modules
        pageCache: root.pageCache
        pageParent: root.contentItem
        currentPage: root.pageStack.currentItem
        filterText: searchField.text
        onResultAccepted: module => {
            const hadFocus = searchField.activeFocus;
            root.openModule(module);
            // Newly created pages take the focus.
            if (hadFocus) {
                searchField.forceActiveFocus();
            }
        }
    }

    // On macOS, a window-modal window with a transient parent is presented as a
    // sheet, which doesn't have a title bar or a close button. Application
    // modality is used instead: the window is then presented as a regular window,
    // while the parent window is still blocked from being interacted with.
    modality: Qt.platform.os === "osx" ? Qt.ApplicationModal : Qt.WindowModal

    pageStack {
        columnView.columnWidth: Kirigami.Units.gridUnit * 13

        popHiddenPages: true

        globalToolBar {
            style: Kirigami.ApplicationHeaderStyle.ToolBar
            showNavigationButtons: root.pageStack.depth > 1 ? Kirigami.ApplicationHeaderStyle.ShowBackButton : Kirigami.ApplicationHeaderStyle.NoNavigationButtons
        }
    }

    contentItem.Keys.onEscapePressed: root.close()

    globalDrawer: Kirigami.OverlayDrawer {
        id: drawer
        edge: Qt.application.layoutDirection === Qt.RightToLeft ? Qt.RightEdge : Qt.LeftEdge

        modal: false
        Kirigami.OverlayZStacking.layer: Kirigami.OverlayZStacking.Drawer
        z: Kirigami.OverlayZStacking.z
        drawerOpen: true
        width: Kirigami.Units.gridUnit * 13
        Kirigami.Theme.colorSet: Kirigami.Theme.View
        Kirigami.Theme.inherit: false

        leftPadding: 0
        rightPadding: 0
        topPadding: 0
        bottomPadding: 0

        contentItem: ColumnLayout {
            spacing: 0

            QQC2.ToolBar {
                Layout.fillWidth: true
                Layout.preferredHeight: pageStack.globalToolBar.preferredHeight

                visible: !Kirigami.Settings.isMobile

                Kirigami.SearchField {
                    id: searchField
                    autoAccept: false
                    onAccepted: configurationSearch.acceptFirstResult()
                    Keys.onDownPressed: listview.focusResult(0)
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        right: parent.right
                    }
                }
            }

            QQC2.ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ListView {
                    id: listview

                    property bool initDone: false

                    function focusResult(index: int): void {
                        if (index < 0) {
                            searchField.forceActiveFocus(Qt.BacktabFocusReason);
                        } else if (index < count) {
                            positionViewAtIndex(index, ListView.Contain);
                            itemAtIndex(index)?.forceActiveFocus(Qt.TabFocusReason);
                        }
                    }

                    currentIndex: configurationSearch.filteredModules.indexOf(root.currentModule)

                    onWidthChanged: if (!initDone) {
                        let module = getModuleByName(defaultModule);
                        if (module) {
                            root.pageStack.push(pageForModule(module));
                            root.currentModule = module;
                        } else {
                            root.pageStack.push(pageForModule(modules[0]));
                            root.currentModule = modules[0];
                            if (root.pageStack.currentItem.title.length === 0) {
                                root.pageStack.currentItem.title = modules[0].text;
                            }
                        }
                        initDone = true;
                    }
                    model: configurationSearch.filteredModules
                    delegate: Delegates.RoundedItemDelegate {
                        id: settingDelegate

                        required property int index
                        required property ConfigurationModule modelData

                        text: modelData?.text
                        icon.name: modelData?.icon.name
                        icon.source: modelData?.icon.source
                        checked: root.currentModule === settingDelegate.modelData

                        Keys.onUpPressed: listview.focusResult(index - 1)
                        Keys.onDownPressed: listview.focusResult(index + 1)
                        Keys.onReturnPressed: clicked()
                        Keys.onEnterPressed: clicked()

                        onClicked: root.openModule(modelData)
                    }
                }
            }
        }
    }

    function openModule(module: ConfigurationModule): void {
        if (root.currentModule === module) {
            return;
        }
        const page = pageForModule(module);

        while (root.pageStack.length > 1) {
            root.pageStack.pop(null);
        }
        root.pageStack.replace(page);

        root.currentModule = module;
        if (root.pageStack.currentItem.title.length === 0) {
            root.pageStack.currentItem.title = module.text;
        }
    }

    function pageForModule(module: ConfigurationModule, parent = root.contentItem): var {
        if (pageCache[module.moduleId]) {
            return pageCache[module.moduleId];
        } else {
            const component = module.page();
            if (!component) {
                console.error("Unable to create component for moduleId", module.moduleId);
                return null;
            }

            if (component.status !== Component.Ready) {
                console.error(`Unable to create component for moduleId: "${module.moduleId}". Error: ${component.errorString()}`);
                return null;
            }

            const page = component.createObject(parent, module.initialProperties());
            if (!page) {
                return null;
            }
            if (page.title.length === 0) {
                page.title = module.text;
            }
            pageCache[module.moduleId] = page;
            return page;
        }
    }

    function getModuleByName(moduleId: string): ConfigurationModule {
        return modules.find(module => module.moduleId == moduleId) ?? null;
    }
}
