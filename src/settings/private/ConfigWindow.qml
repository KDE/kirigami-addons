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

                leftPadding: 3
                rightPadding: 3
                topPadding: 3
                bottomPadding: 3

                visible: !Kirigami.Settings.isMobile

                contentItem: Kirigami.SearchField {
                    Layout.fillWidth: true
                    onTextChanged: listview.filterText = text.toLowerCase();
                }
            }

            QQC2.ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ListView {
                    id: listview

                    property string filterText: ""
                    property bool initDone: false

                    currentIndex: -1

                    onWidthChanged: if (!initDone) {
                        let module = getModuleByName(defaultModule);
                        if (module) {
                            root.pageStack.push(pageForModule(module));
                            listview.currentIndex = modules.findIndex(module => module.moduleId == defaultModule);
                        } else {
                            root.pageStack.push(pageForModule(modules[0]));
                            listview.currentIndex = 0;
                            if (root.pageStack.currentItem.title.length === 0) {
                                root.pageStack.currentItem.title = modules[0].text;
                            }
                        }
                        initDone = true;
                    }
                    model: {
                        const isFiltering = filterText.length !== 0;
                        let filteredModules = [];
                        for (const module of root.modules) {
                            const modulePassesFilter = module.text.toLowerCase().includes(filterText);
                            if (module.visible && (isFiltering ? modulePassesFilter : true)) {
                                filteredModules.push(module);
                            }
                        }
                        return filteredModules;
                    }
                    delegate: Delegates.RoundedItemDelegate {
                        id: settingDelegate

                        required property int index
                        required property ConfigurationModule modelData

                        text: modelData.text
                        icon.name: modelData.icon.name
                        icon.source: modelData.icon.source
                        checked: ListView.view.currentIndex === settingDelegate.index

                        onClicked: {
                            const page = pageForModule(modelData);
                            if (ListView.view.currentIndex === settingDelegate.index) {
                                return;
                            }
                            root.pageStack.replace(page);

                            ListView.view.currentIndex = settingDelegate.index;
                            if (root.pageStack.currentItem.title.length === 0) {
                                root.pageStack.currentItem.title = text;
                            }
                        }
                    }
                }
            }
        }
    }

    function pageForModule(module: ConfigurationModule): var {
        if (pageCache[module.moduleId]) {
            return pageCache[module.moduleId];
        } else {
            const component = module.page();
            if (!component) {
                console.error("Unable to create component for moduleId", module.moduleId);
                return null;
            }

            if (component.status === Component.Error) {
                console.error(`Unable to create component for moduleId: "${module.moduleId}". Error: ${component.errorString()}`);
                return null;
            }

            const page = component.createObject(root, module.initialProperties());
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
