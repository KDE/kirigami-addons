// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtTest
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kirigamiaddons.settings as Settings
import org.kde.kirigamiaddons.settings.private as Private

Item {
    id: root

    width: 640
    height: 480

    property int createdPages: 0
    property var pageCache: Object.create(null)
    property string dynamicLabel: "Initial label"
    property bool loadExtra: false

    Settings.ConfigurationModule {
        id: appearance
        moduleId: "appearance"
        text: "Appearance"
        page: () => appearancePage
        initialProperties: () => ({ fieldLabel: "Font size" })
    }

    Settings.ConfigurationModule {
        id: account
        moduleId: "account"
        text: "Account"
        page: () => accountPage
    }

    Settings.ConfigurationModule {
        id: hidden
        moduleId: "hidden"
        text: "Hidden module"
        visible: false
        page: () => appearancePage
        initialProperties: () => ({ fieldLabel: "Hidden setting" })
    }

    Settings.ConfigurationModule {
        id: excluded
        moduleId: "excluded"
        text: "Excluded module"
        searchable: false
        page: () => appearancePage
        initialProperties: () => ({ fieldLabel: "Excluded setting" })
    }

    Settings.ConfigurationModule {
        id: about
        moduleId: "about"
        text: "About Application"
        page: () => aboutPage
    }

    Settings.ConfigurationModule {
        id: aboutKDE
        moduleId: "aboutkde"
        text: "About KDE"
        page: () => aboutKDEPage
    }

    Private.ConfigurationSearch {
        id: search
        modules: [appearance, account, hidden, excluded, about, aboutKDE]
        pageParent: root
        pageCache: root.pageCache
    }

    TextInput {
        id: focusField
    }

    Settings.ConfigurationModule {
        id: focusModule
        moduleId: "focus"
        text: "Focus"
        page: () => focusPage
    }

    Private.ConfigurationSearch {
        id: focusSearch
        modules: [focusModule]
        pageParent: root
        pageCache: Object.create(null)
    }

    Component {
        id: focusPage
        // ScrollablePage calls forceActiveFocus() when created.
        FormCard.FormCardPage {
            FormCard.FormCard {
                FormCard.FormSwitchDelegate { text: "Focus setting" }
            }
        }
    }

    Component {
        id: aboutPage
        FormCard.AboutPage { Component.onCompleted: root.createdPages++ }
    }

    Component {
        id: aboutKDEPage
        FormCard.AboutKDEPage { Component.onCompleted: root.createdPages++ }
    }

    Component {
        id: appearancePage

        FormCard.FormCardPage {
            id: appearanceSettingsPage
            required property string fieldLabel
            Component.onCompleted: root.createdPages++

            FormCard.FormHeader { title: "Typography" }
            FormCard.FormCard {
                FormCard.FormTextFieldDelegate {
                    label: appearanceSettingsPage.fieldLabel
                    description: "Adjust the interface lettering"
                    text: "zzzeditedvaluezzz"
                }
                FormCard.FormSwitchDelegate { text: "Use dark colors" }
                FormCard.FormSwitchDelegate {
                    text: "Continue reading where you last left off"
                    description: "If checked, the Home timeline will begin where you last read. The position in the timeline is shared with other clients."
                }
                FormCard.FormSwitchDelegate {
                    text: "Auto-update timelines"
                    description: "If checked, Tokodon will automatically update certain timelines as new posts come in."
                }
                FormCard.FormCheckDelegate { text: "Enable animations" }
                FormCard.FormRadioDelegate { text: "Compact spacing" }
                FormCard.FormButtonDelegate { text: root.dynamicLabel }
                Repeater {
                    model: ["Accent color"]
                    FormCard.FormButtonDelegate {
                        required property string modelData
                        text: modelData
                    }
                }
                Loader {
                    active: root.loadExtra
                    sourceComponent: FormCard.FormButtonDelegate { text: "Deferred setting" }
                }
            }
            FormCard.FormSectionText { text: "Restart to apply changes" }
        }
    }

    Component {
        id: accountPage

        FormCard.FormCardPage {
            Component.onCompleted: root.createdPages++
            FormCard.FormCard {
                FormCard.FormPasswordFieldDelegate {
                    label: "Password"
                    text: "zzzsecretvaluezzz"
                }
                FormCard.FormTextAreaDelegate {
                    label: "Biography"
                    text: "zzzpersonalvaluezzz"
                }
            }
        }
    }

    Component {
        id: freshSearchComponent
        Private.ConfigurationSearch {
            modules: [focusModule]
            pageParent: root
            pageCache: Object.create(null)
        }
    }

    Component {
        id: spyComponent
        SignalSpy {
            signalName: "resultAccepted"
        }
    }

    SignalSpy {
        id: acceptedSpy
        target: search
        signalName: "resultAccepted"
    }

    TestCase {
        name: "SettingsSearch"
        when: windowShown

        function initTestCase(): void {
            compare(search.filteredModules.length, 5);
            compare(root.createdPages, 0);
            search.filterText = "FONT SIZE";
            compare(root.createdPages, 0);
            tryCompare(root, "createdPages", 4);
            tryVerify(() => search.indexedPages.aboutkde !== undefined);
            compare(search.filteredModules.length, 1);
            compare(search.filteredModules[0], appearance);
            compare(root.pageCache.appearance.visible, false);
            compare(root.pageCache.account.visible, false);
        }

        function cleanup(): void {
            search.filterText = "";
            search.currentPage = null;
            root.dynamicLabel = "Initial label";
            root.loadExtra = false;
        }

        function searchFor(query: string): void {
            search.filterText = query;
            tryCompare(search, "searchText", query.trim());
        }

        function test_discovery_data(): list<var> {
            return [
                { tag: "module", query: "APPEAR", module: appearance },
                { tag: "label", query: "font size", module: appearance },
                { tag: "description", query: "lettering", module: appearance },
                { tag: "header", query: "typography", module: appearance },
                { tag: "switch", query: "dark colors", module: appearance },
                { tag: "check", query: "animations", module: appearance },
                { tag: "radio", query: "compact spacing", module: appearance },
                { tag: "repeater", query: "accent color", module: appearance },
                { tag: "section", query: "restart", module: appearance },
                { tag: "password label", query: "password", module: account },
                { tag: "text area label", query: "biography", module: account },
                { tag: "trim", query: "  font size  ", module: appearance },
            ];
        }

        function test_discovery(data): void {
            searchFor(data.query);
            compare(search.filteredModules.length, 1);
            compare(search.filteredModules[0], data.module);
            compare(root.createdPages, 4);
        }

        function test_excludedValues_data(): list<var> {
            return [
                { tag: "password", query: "zzzsecretvaluezzz" },
                { tag: "text field", query: "zzzeditedvaluezzz" },
                { tag: "text area", query: "zzzpersonalvaluezzz" },
                { tag: "hidden module", query: "hidden" },
                { tag: "excluded module", query: "excluded" },
                { tag: "about title", query: "About" },
                { tag: "about content", query: "KDE" },
                { tag: "scattered letters", query: "fntsz" },
            ];
        }

        function test_excludedValues(data): void {
            searchFor(data.query);
            compare(search.filteredModules.length, 0);
        }

        function test_liveLabel(): void {
            searchFor("Updated setting");
            compare(search.filteredModules.length, 0);
            root.dynamicLabel = "Updated setting";
            compare(search.filteredModules.length, 1);
            compare(search.filteredModules[0], appearance);
        }

        function test_acceptFirstResult(): void {
            acceptedSpy.clear();
            search.filterText = "font size";
            search.acceptFirstResult();
            tryCompare(acceptedSpy, "count", 1);
            compare(acceptedSpy.signalArguments[0][0], appearance);

            // Typing again while the pages are indexed cancels the pending accept.
            const freshSearch = createTemporaryObject(freshSearchComponent, root);
            const freshSpy = createTemporaryObject(spyComponent, root, { target: freshSearch });
            freshSearch.filterText = "focus";
            freshSearch.acceptFirstResult();
            verify(freshSearch.indexing);
            freshSearch.filterText = "focus setting";
            tryVerify(() => freshSearch.indexedPages.focus !== undefined);
            wait(50);
            compare(freshSpy.count, 0);
        }

        function test_indexingKeepsFocus(): void {
            focusField.forceActiveFocus();
            verify(focusField.activeFocus);
            focusSearch.filterText = "focus setting";
            tryVerify(() => focusSearch.indexedPages.focus !== undefined);
            compare(focusSearch.filteredModules.length, 1);
            verify(focusField.activeFocus);
        }

        function test_stableResults(): void {
            searchFor("font size");
            search.currentPage = root.pageCache.appearance;
            const highlight = search.highlights[0];
            let modelChanges = 0;
            const countChange = () => modelChanges++;
            search.filteredModulesChanged.connect(countChange);
            root.dynamicLabel = "Unrelated label";
            search.filteredModulesChanged.disconnect(countChange);
            compare(modelChanges, 0);
            compare(search.highlights[0], highlight);
        }

        function test_deferredContent(): void {
            searchFor("Deferred setting");
            compare(search.filteredModules.length, 0);
            root.loadExtra = true;
            tryVerify(() => search.filteredModules.length === 1);
            compare(search.filteredModules[0], appearance);
        }

        function test_pageReuse(): void {
            const page = search.indexedPages.appearance;
            compare(page, root.pageCache.appearance);
            page.parent = root;
            compare(page.visible, true);
            searchFor("font size");
            compare(search.filteredModules[0], appearance);
            compare(root.createdPages, 4);
        }

        function test_highlights(): void {
            search.currentPage = root.pageCache.appearance;
            searchFor("font size");
            compare(search.matchingItems.length, 1);
            compare(search.highlights.length, 1);
            compare(search.highlights[0].parent, search.matchingItems[0]);
            compare(search.matchingItems[0].label, "Font size");

            search.currentPage = root.pageCache.account;
            compare(search.highlights.length, 0);
            searchFor("password");
            compare(search.highlights.length, 1);
            compare(search.highlights[0].parent.label, "Password");
            search.filterText = "";
            compare(search.highlights.length, 0);
        }

        function test_aboutNeverHighlighted(): void {
            search.currentPage = root.pageCache.aboutkde;
            searchFor("KDE");
            compare(search.matchingItems.length, 0);
            compare(search.highlights.length, 0);
        }

        function test_colorDoesNotMatchScatteredLetters(): void {
            search.currentPage = root.pageCache.appearance;
            searchFor("color");
            compare(search.matchingItems.length, 2);
            compare(search.matchingItems[0].text, "Use dark colors");
            compare(search.matchingItems[1].text, "Accent color");
            compare(search.highlights.length, 2);
        }
    }
}
