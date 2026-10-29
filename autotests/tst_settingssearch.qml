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

    Settings.ConfigurationModule {
        id: appearance
        moduleId: "appearance"
        text: "Appearance"
        page: () => appearancePage
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
    }

    Settings.ConfigurationModule {
        id: aboutKDE
        moduleId: "aboutkde"
        text: "About KDE"
        page: () => aboutKDEPage
    }

    Private.ConfigurationSearch {
        id: search
        modules: [appearance, account, hidden, aboutKDE]
        pageParent: root
        pageCache: root.pageCache
    }

    Component {
        id: aboutKDEPage
        FormCard.AboutKDEPage { Component.onCompleted: root.createdPages++ }
    }

    Component {
        id: appearancePage

        FormCard.FormCardPage {
            Component.onCompleted: root.createdPages++

            FormCard.FormCard {
                FormCard.FormTextFieldDelegate {
                    label: "Font size"
                    description: "Adjust the interface lettering"
                }
            }
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
            }
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
            compare(search.filteredModules.length, 3);
            compare(root.createdPages, 0);
            search.filterText = "font size";
            tryCompare(root, "createdPages", 3);
            tryVerify(() => search.indexedPages.aboutkde !== undefined);
            compare(search.filteredModules.length, 1);
            compare(search.filteredModules[0], appearance);
        }

        function cleanup(): void {
            search.filterText = "";
            search.currentPage = null;
        }

        function searchFor(query: string): void {
            search.filterText = query;
            tryCompare(search, "searchText", query.trim());
        }

        function test_discovery_data(): list<var> {
            return [
                { tag: "module", query: "account", module: account },
                { tag: "label", query: "font size", module: appearance },
                { tag: "description", query: "lettering", module: appearance },
            ];
        }

        function test_discovery(data): void {
            searchFor(data.query);
            compare(search.filteredModules.length, 1);
            compare(search.filteredModules[0], data.module);
        }

        function test_excluded_data(): list<var> {
            return [
                { tag: "value", query: "zzzsecretvaluezzz" },
                { tag: "hidden module", query: "hidden" },
                { tag: "about page", query: "KDE" },
            ];
        }

        function test_excluded(data): void {
            searchFor(data.query);
            compare(search.filteredModules.length, 0);
            tryCompare(search, "indexing", false);
            compare(search.noResults, true);
        }

        function test_noResults(): void {
            searchFor("");
            compare(search.noResults, false);
            searchFor("account");
            compare(search.noResults, false);
        }

        function test_acceptFirstResult(): void {
            acceptedSpy.clear();
            search.filterText = "font size";
            search.acceptFirstResult();
            tryCompare(acceptedSpy, "count", 1);
            compare(acceptedSpy.signalArguments[0][0], appearance);
        }

        function test_highlights(): void {
            search.currentPage = root.pageCache.appearance;
            searchFor("font size");
            compare(search.highlights.length, 1);
            compare(search.highlights[0].parent, search.matchingItems[0]);
            search.filterText = "";
            compare(search.highlights.length, 0);
        }
    }
}
