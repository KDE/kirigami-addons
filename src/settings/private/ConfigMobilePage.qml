/*
 * SPDX-FileCopyrightText: 2011-2014 Sebastian Kügler <sebas@kde.org>
 * SPDX-FileCopyrightText: 2021 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigamiaddons.private
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kirigamiaddons.settings

FormCard.FormCardPage {
    id: root

    required property string defaultModule
    required property list<ConfigurationModule> modules
    required property Kirigami.ApplicationWindow window

    // Do not use Map, it crashes very frequently
    property var pageCache: Object.create(null)

    ConfigurationSearch {
        id: configurationSearch
        modules: root.modules
        pageCache: root.pageCache
        pageParent: root
        currentPage: root.window.pageStack.layers.currentItem === root ? null : root.window.pageStack.layers.currentItem
        filterText: searchField.text
        onResultAccepted: module => root.openModule(module)
    }

    property bool initDone: false

    title: I18n.i18nc("@title", "Settings")

    // The layers are not busy when the push of this page is not animated.
    Component.onCompleted: Qt.callLater(root.openDefaultModule)

    Connections {
        target: root.window.pageStack.layers

        function onBusyChanged(): void {
            root.openDefaultModule();
        }
    }

    function openDefaultModule(): void {
        if (root.initDone || root.window.pageStack.layers.busy) {
            return;
        }
        root.initDone = true;
        const module = root.getModuleByName(root.defaultModule);
        const page = module ? root.pageForModule(module) : null;
        if (page) {
            root.window.pageStack.layers.push(page);
        }
    }

    // search bar
    FormCard.FormCard {
        Layout.fillWidth: true
        Layout.topMargin: Kirigami.Units.gridUnit

        FormCard.AbstractFormDelegate {
            Layout.fillWidth: true
            background: null

            topPadding: Kirigami.Units.smallSpacing
            bottomPadding: Kirigami.Units.smallSpacing

            contentItem: Kirigami.SearchField {
                id: searchField
                Layout.fillWidth: true
                autoAccept: false
                background: null
                onAccepted: configurationSearch.acceptFirstResult()
                Keys.onDownPressed: nextItemInFocusChain(true)?.forceActiveFocus(Qt.TabFocusReason)
            }
        }
    }

    Repeater {
        model: {
            let filteredCategories = new Array();

            for (const module of configurationSearch.filteredModules) {
                const category = filteredCategories.find((category) => category.name === module.category);
                if (category) {
                    category.modules.push(module);
                } else {
                    filteredCategories.push({
                        name: module.category,
                        modules: [module],
                    });
                }
            }
            return filteredCategories;
        }

        ColumnLayout {
            id: categoryDelegate

            required property var modelData

            spacing: 0

            FormCard.FormHeader {
                title: categoryDelegate.modelData.name === "_main_category" ? root.title : modelData.name
            }

            // settings categories
            FormCard.FormCard {
                id: settingsCard

                autoSeparators: true

                Repeater {
                    model: categoryDelegate.modelData.modules
                    delegate: FormCard.AbstractFormDelegate {
                        id: moduleDelegate

                        required property ConfigurationModule modelData

                        Keys.onUpPressed: nextItemInFocusChain(false)?.forceActiveFocus(Qt.BacktabFocusReason)
                        Keys.onDownPressed: nextItemInFocusChain(true)?.forceActiveFocus(Qt.TabFocusReason)
                        Keys.onReturnPressed: clicked()
                        Keys.onEnterPressed: clicked()

                        onClicked: root.openModule(moduleDelegate.modelData)

                        contentItem: RowLayout {
                            Kirigami.Icon {
                                source: moduleDelegate.modelData.icon.name
                                Layout.rightMargin: Kirigami.Units.largeSpacing
                                implicitWidth: Kirigami.Units.iconSizes.medium
                                implicitHeight: Kirigami.Units.iconSizes.medium
                            }

                            Controls.Label {
                                Layout.fillWidth: true
                                text: moduleDelegate.modelData.text
                                elide: Text.ElideRight
                            }

                            Kirigami.Icon {
                                Layout.alignment: Qt.AlignRight
                                source: "arrow-right"
                                implicitWidth: Math.round(Kirigami.Units.iconSizes.small * 0.75)
                                implicitHeight: Math.round(Kirigami.Units.iconSizes.small * 0.75)
                            }
                        }
                    }
                }
            }

        }
    }

    FormCard.FormCard {
        Layout.topMargin: Kirigami.Units.gridUnit
        visible: configurationSearch.noResults

        FormCard.FormPlaceholderMessageDelegate {
            text: configurationSearch.indexing
                ? I18n.i18nc("@info:placeholder", "Searching…")
                : I18n.i18nc("@info:placeholder", "No matching settings")
        }
    }

    function openModule(module: ConfigurationModule): void {
        root.window.pageStack.layers.push(pageForModule(module));
    }

    function pageForModule(module: ConfigurationModule, parent = root): var {
        if (pageCache[module.moduleId]) {
            return pageCache[module.moduleId];
        } else {
            const component = module.page();
            if (!component) {
                console.error("Unable to create component for moduleId", module.moduleId);
                return null;
            }
            if (component.status !== Component.Ready) {
                console.error(component.errorString());
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
