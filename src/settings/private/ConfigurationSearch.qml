// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kirigamiaddons.formcard.templates as FormTemplates
import org.kde.kirigamiaddons.settings
import org.kde.kirigamiaddons.settings.private

QtObject {
    id: root

    required property list<ConfigurationModule> modules
    required property var pageCache
    required property Item pageParent
    property Item currentPage
    property string filterText
    property string searchText
    property ConfigurationModule loadingModule: null
    property Component loadingComponent: null
    property var incubator: null

    signal resultAccepted(module: ConfigurationModule)

    onFilterTextChanged: {
        root.acceptPending = false;
        if (filterText.trim().length === 0) {
            queryTimer.stop();
            searchText = "";
        } else {
            queryTimer.restart();
        }
    }

    readonly property Timer queryTimer: Timer {
        interval: 150
        onTriggered: root.applyFilterText()
    }

    function applyFilterText(): void {
        queryTimer.stop();
        searchText = filterText.trim();
    }

    property bool acceptPending: false
    readonly property bool indexing: root.searchText.length > 0
        && (root.pendingModules.length > 0 || root.loadingModule !== null)

    // More results can still appear while indexing.
    readonly property bool noResults: root.searchText.length > 0 && root.filteredModules.length === 0

    // Deferred so the results include the last indexed page.
    onIndexingChanged: Qt.callLater(root.emitAcceptedResult)

    // Results only contain indexed pages, so wait for the indexing to finish.
    function acceptFirstResult(): void {
        root.applyFilterText();
        root.acceptPending = true;
        root.emitAcceptedResult();
    }

    function emitAcceptedResult(): void {
        if (!root.acceptPending || root.indexing) {
            return;
        }
        root.acceptPending = false;
        if (root.filteredModules.length > 0) {
            root.resultAccepted(root.filteredModules[0]);
        }
    }

    property var indexedPages: Object.create(null)
    property var pageIndexes: Object.create(null)
    readonly property list<ConfigurationModule> pendingModules: root.modules.filter(module =>
        module.visible && module.searchable && !(module.moduleId in root.indexedPages))

    // Views recreate all their delegates on model changes, so only update when needed.
    readonly property list<ConfigurationModule> filteredModules: root.stableFilteredModules
    property list<ConfigurationModule> stableFilteredModules

    onMatchingModulesChanged: {
        if (!root.sameObjects(root.stableFilteredModules, root.matchingModules)) {
            root.stableFilteredModules = root.matchingModules;
        }
    }

    Component.onCompleted: root.stableFilteredModules = root.matchingModules

    readonly property list<ConfigurationModule> matchingModules: {
        const pattern = root.searchText;
        return root.modules.filter(module => {
            if (!module.visible) {
                return false;
            }
            if (pattern.length === 0) {
                return true;
            }
            const page = root.indexedPages[module.moduleId];
            const index = root.pageIndexes[module.moduleId];
            return module.searchable && page && !root.isAboutPage(page)
                && (Helper.matches(pattern, module.text) || index?.items.some(item => root.matchesItem(item, pattern)));
        });
    }

    onModulesChanged: {
        for (const index of Object.values(root.pageIndexes)) {
            index.destroy();
        }
        root.pageIndexes = Object.create(null);
        root.indexedPages = Object.create(null);
    }

    readonly property list<Item> matchingItems: {
        if (root.searchText.length === 0 || root.isAboutPage(root.currentPage)) {
            return [];
        }
        const module = root.modules.find(module => module.visible && module.searchable
            && root.indexedPages[module.moduleId] === root.currentPage);
        const index = module ? root.pageIndexes[module.moduleId] : null;
        return index ? index.items.filter(item => root.matchesItem(item, root.searchText)) : [];
    }

    readonly property Component pageIndexComponent: Component {
        QtObject {
            required property Item page
            readonly property list<Item> items: page instanceof FormCard.FormCardPage && !root.isAboutPage(page)
                ? root.findSearchableItems(page.cards) : []
        }
    }

    property list<Item> highlights

    onMatchingItemsChanged: {
        const highlightedItems = root.highlights.map(highlight => highlight?.parent ?? null);
        if (root.sameObjects(highlightedItems, root.matchingItems)) {
            return;
        }
        for (const highlight of root.highlights) {
            if (highlight) {
                highlight.destroy();
            }
        }
        root.highlights = root.matchingItems.map(item => root.highlightComponent.createObject(item));
    }

    readonly property Component highlightComponent: Component {
        Rectangle {
            objectName: "settingsSearchHighlight"
            anchors.fill: parent
            z: 1
            color: "transparent"
            radius: Kirigami.Units.cornerRadius
            border.width: 2
            border.color: Kirigami.Theme.highlightColor
            Accessible.ignored: true
        }
    }

    // Keep indexed pages hidden until the page stack takes ownership of them.
    readonly property Item loadingParent: Item {
        parent: root.pageParent
        visible: false
    }

    property Item lastFocusItem: null

    // Pages (e.g. ScrollablePage) can call forceActiveFocus() while being created.
    readonly property Connections focusConnections: Connections {
        target: root.loadingParent.Window.window
        function onActiveFocusItemChanged(): void {
            const item = root.loadingParent.Window.activeFocusItem;
            if (!root.isLoadingItem(item)) {
                root.lastFocusItem = item;
            } else if (root.lastFocusItem) {
                root.lastFocusItem.forceActiveFocus();
            }
        }
    }

    function isLoadingItem(item: Item): bool {
        for (let ancestor = item; ancestor; ancestor = ancestor.parent) {
            if (ancestor === root.loadingParent) {
                return true;
            }
        }
        return false;
    }

    readonly property Timer indexingTimer: Timer {
        interval: 1
        repeat: true
        running: root.searchText.length > 0 && root.pendingModules.length > 0 && !root.loadingModule

        onTriggered: {
            const module = root.pendingModules[0];
            if (root.pageCache[module.moduleId]) {
                root.indexPage(module, root.pageCache[module.moduleId]);
                return;
            }
            root.loadingModule = module;
            root.loadingComponent = module.page();
            root.incubatePage();
        }
    }

    readonly property Connections componentConnections: Connections {
        target: root.loadingComponent
        function onStatusChanged(): void {
            root.incubatePage();
        }
    }

    function indexPage(module: ConfigurationModule, page: Item): void {
        if (page) {
            // The user may have opened the module while it was being incubated.
            const cachedPage = root.pageCache[module.moduleId];
            if (cachedPage && cachedPage !== page) {
                page.destroy();
                page = cachedPage;
            } else {
                if (page.title.length === 0) {
                    page.title = module.text;
                }
                root.pageCache[module.moduleId] = page;
            }
        }
        const pages = Object.assign(Object.create(null), root.indexedPages);
        pages[module.moduleId] = page;
        if (page) {
            const indexes = Object.assign(Object.create(null), root.pageIndexes);
            indexes[module.moduleId] = root.pageIndexComponent.createObject(root, { page });
            root.pageIndexes = indexes;
        }
        root.indexedPages = pages;
    }

    function incubatePage(): void {
        if (!root.loadingModule || root.incubator || root.loadingComponent?.status === Component.Loading) {
            return;
        }
        if (!root.loadingComponent || root.loadingComponent.status === Component.Error) {
            console.error("Unable to load settings module", root.loadingModule.moduleId, root.loadingComponent?.errorString());
            root.indexPage(root.loadingModule, null);
            root.loadingModule = null;
            root.loadingComponent = null;
            return;
        }

        const module = root.loadingModule;
        const incubator = root.loadingComponent.incubateObject(root.loadingParent, module.initialProperties(), Qt.Asynchronous);
        root.incubator = incubator;
        const complete = () => {
            if (incubator.status === Component.Loading) {
                return;
            }
            incubator.onStatusChanged = null;
            root.indexPage(module, incubator.status === Component.Ready ? incubator.object : null);
            root.incubator = null;
            root.loadingModule = null;
            root.loadingComponent = null;
        };
        incubator.onStatusChanged = complete;
        complete();
    }

    function isAboutPage(item: Item): bool {
        return item instanceof FormCard.AboutPage || item instanceof FormCard.AboutKDEPage;
    }

    function sameObjects(a: var, b: var): bool {
        return a.length === b.length && a.every((object, i) => object === b[i]);
    }

    function findSearchableItems(cards: list<QtObject>): list<Item> {
        const matches = [];
        for (const card of cards) {
            if (card instanceof FormTemplates.FormCard) {
                for (const delegate of card.delegates) {
                    if (delegate instanceof Item) {
                        root.collectSearchableItems(delegate, matches);
                    }
                }
            } else if (card instanceof FormTemplates.FormHeader || card instanceof FormCard.FormSectionText) {
                matches.push(card);
            }
        }
        return matches;
    }

    function collectSearchableItems(item: Item, matches: var): void {
        if (!item) {
            return;
        }

        if (item instanceof FormCard.AbstractFormDelegate
            || item instanceof FormCard.FormCheckDelegate
            || item instanceof FormCard.FormRadioDelegate
            || item instanceof FormCard.FormSwitchDelegate
            || item instanceof FormTemplates.FormHeader
            || item instanceof FormCard.FormSectionText) {
            // Stop at delegates so editable values and control internals are not indexed.
            matches.push(item);
            return;
        }

        // Use children rather than visibleChildren: unopened pages are hidden.
        for (const child of item.children) {
            root.collectSearchableItems(child, matches);
        }
    }

    function matchesItem(item: Item, pattern: string): bool {
        if (item instanceof FormTemplates.FormHeader) {
            return Helper.matches(pattern, item.title);
        }
        // For editable fields, text is the value rather than the label.
        const label = item.label !== undefined ? item.label : item.text;
        return Helper.matches(pattern, label ?? "")
            || Helper.matches(pattern, item.description ?? "")
            || Helper.matches(pattern, item.explanation ?? "")
            || (item instanceof FormCard.FormRadioSelectorDelegate
                && item.actions.some(action => Helper.matches(pattern, action.text)));
    }
}
