/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as Controls
import QtTest
import "../src/formcard/private" as Private

Item {
    id: root

    width: 400
    height: 300

    readonly property string fixturePath: Qt.resolvedUrl("data/pathcompletion").toString().replace("file://", "")

    Controls.TextField {
        id: fileField
        width: 300
    }

    Private.FormPathCompletion {
        id: fileCompletion
        textField: fileField
        includeFiles: true
        nameFilters: ["*.txt"]
    }

    Controls.TextField {
        id: folderField
        y: 60
        width: 300
    }

    Private.FormPathCompletion {
        id: folderCompletion
        textField: folderField
    }

    TestCase {
        name: "FormPathCompletion"
        when: windowShown

        function cleanup(): void {
            fileCompletion.closePopup();
            folderCompletion.closePopup();
            fileField.text = "";
            folderField.text = "";
        }

        function test_fileSuggestions(): void {
            fileField.text = root.fixturePath + "/alpha";
            fileField.forceActiveFocus();
            fileCompletion.updateSuggestions();
            tryCompare(fileCompletion, "hintCount", 2);
            tryCompare(fileCompletion, "popupVisible", true);

            fileCompletion.selectFirstSuggestion(true);
            compare(fileField.text, root.fixturePath + "/alpha-dir/");
            tryCompare(fileCompletion, "hintCount", 1);

            fileField.text = root.fixturePath + "/alpha-file";
            fileCompletion.updateSuggestions();
            tryCompare(fileCompletion, "hintCount", 1);
            fileCompletion.selectFirstSuggestion(false);
            compare(fileField.text, root.fixturePath + "/alpha-file.txt");
            tryCompare(fileCompletion, "popupVisible", false);

            fileField.text = root.fixturePath + "/missing";
            fileCompletion.updateSuggestions();
            tryCompare(fileCompletion, "hintCount", 0);
        }

        function test_folderSuggestions(): void {
            folderField.text = root.fixturePath + "/alpha";
            folderField.forceActiveFocus();
            folderCompletion.updateSuggestions();
            tryCompare(folderCompletion, "hintCount", 1);
            tryCompare(folderCompletion, "popupVisible", true);

            folderCompletion.selectFirstSuggestion(false);
            compare(folderField.text, root.fixturePath + "/alpha-dir");
            tryCompare(folderCompletion, "popupVisible", false);

            folderCompletion.updateSuggestions();
            compare(folderCompletion.hintCount, 0);
        }
    }
}
