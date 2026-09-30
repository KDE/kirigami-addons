// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtTest
import QtQuick.Controls as Controls
import org.kde.kirigamiaddons.formcard as FormCard

Item {
    id: root
    width: 600
    height: 600
    property bool modelChecked: false
    property int modelIndex: 0
    property string modelText: "Initial"
    property url modelUrl
    property color modelColor: "#ff0000"
    property date modelDate: new Date(2025, 0, 15)

    Component {
        id: switchComponent
        FormCard.FormSwitchDelegate {
            width: root.width
            text: "Switch"
            checked: root.modelChecked
        }
    }
    Component {
        id: radioComponent
        FormCard.FormRadioDelegate {
            width: root.width
            text: "Radio"
            checked: root.modelChecked
        }
    }
    Component {
        id: comboComponent
        FormCard.FormComboBoxDelegate {
            width: root.width
            text: "Choice"
            model: ["First", "Second", "Third"]
            currentIndex: root.modelIndex
            editable: true
            editText: root.modelText
        }
    }
    Component {
        id: fileComponent
        FormCard.FormFileDelegate {
            width: root.width
            label: "File"
            selectedFile: root.modelUrl
        }
    }
    Component {
        id: folderComponent
        FormCard.FormFolderDelegate {
            width: root.width
            label: "Folder"
            selectedFolder: root.modelUrl
        }
    }
    Component {
        id: colorComponent
        FormCard.FormColorDelegate {
            width: root.width
            color: root.modelColor
        }
    }
    Component {
        id: dateComponent
        FormCard.FormDateTimeDelegate {
            width: root.width
            value: root.modelDate
            popupParent: root
            resettable: true
            initialValue: new Date(2025, 0, 15)
            dateTimeDisplay: FormCard.FormDateTimeDelegate.Date
        }
    }
    TestCase {
        name: "FormDelegateBindings"
        when: windowShown

        function init(): void {
            root.modelChecked = false;
            root.modelIndex = 0;
            root.modelText = "Initial";
            root.modelUrl = "";
            root.modelColor = "#ff0000";
            root.modelDate = new Date(2025, 0, 15);
        }
        function test_checkedBindingSurvivesToggle_data(): list<var> {
            return [
                { tag: "switch", component: switchComponent },
                { tag: "radio", component: radioComponent }
            ];
        }
        function test_checkedBindingSurvivesToggle(data: var): void {
            const field = createTemporaryObject(data.component, root);
            verify(!!field, "Component exists");
            const control = findChild(field, "checkControl");
            verify(!!control, "Object exists");
            compare(field.checked, false);
            root.modelChecked = true;
            tryCompare(control, "checked", true);
            root.modelChecked = false;
            tryCompare(control, "checked", false);
            mouseClick(control);
            tryCompare(field, "checked", true);
            root.modelChecked = true;
            root.modelChecked = false;
            tryCompare(field, "checked", false);
            tryCompare(control, "checked", false);
        }
        function test_comboSelectionPreservesBinding(): void {
            const field = createTemporaryObject(comboComponent, root);
            verify(!!field, "Component exists");
            const dialog = createTemporaryObject(field.dialog, root);
            verify(!!dialog, "Component exists");
            dialog.open();
            const list = findChild(dialog, "selectionList");
            verify(!!list, "Object exists");
            tryVerify(() => list.itemAtIndex(1) !== null);
            mouseClick(list.itemAtIndex(1));
            tryCompare(field, "currentText", "Second");
            root.modelIndex = 2;
            tryCompare(field, "currentText", "Third");
        }
        function test_comboEditPreservesBinding_data(): list<var> {
            return [{ tag: "dialog", mode: "dialog" }, { tag: "page", mode: "page" }];
        }
        function test_comboEditPreservesBinding(data: var): void {
            const field = createTemporaryObject(comboComponent, root);
            verify(!!field, "Component exists");
            const dialog = createTemporaryObject(field[data.mode], root);
            verify(!!dialog, "Component exists");
            if (data.mode === "dialog") {
                dialog.open();
            } else {
                dialog.width = root.width;
                dialog.height = root.height;
            }
            const input = findChild(dialog, "editTextField");
            verify(!!input, "Object exists");
            compare(input.text, "First");
            root.modelText = "Updated";
            tryCompare(input, "text", "Updated");
            input.forceActiveFocus();
            tryCompare(input, "activeFocus", true);
            input.selectAll();
            keySequence("A");
            tryCompare(field, "editText", "a");
            root.modelText = "After editing";
            tryCompare(field, "editText", "After editing");
            tryCompare(input, "text", "After editing");
            if (data.mode === "dialog") {
                dialog.close();
            }
        }
        function test_pathSelectionPreservesBinding_data(): list<var> {
            return [
                { tag: "file", component: fileComponent, path: "data/pathcompletion/alpha-file.txt", property: "selectedFile", method: "checkFile" },
                { tag: "folder", component: folderComponent, path: "data/pathcompletion/alpha-dir", property: "selectedFolder", method: "checkFolder" }
            ];
        }
        function test_pathSelectionPreservesBinding(data: var): void {
            const field = createTemporaryObject(data.component, root);
            verify(!!field, "Component exists");
            const input = findChild(field, "pathField");
            verify(!!input, "Object exists");
            const selected = Qt.resolvedUrl(data.path).toString();
            input.text = selected.replace("file://", "");
            input[data.method]();
            compare(field[data.property].toString(), selected);
            root.modelUrl = Qt.resolvedUrl("data/pathcompletion");
            tryCompare(field, data.property, root.modelUrl);
        }
        function test_colorSelectionPreservesBinding(): void {
            const field = createTemporaryObject(colorComponent, root);
            verify(!!field, "Component exists");
            const dialog = findChild(field, "colorDialog");
            verify(!!dialog, "Object exists");
            dialog.color = "#00ff00";
            dialog.accepted();
            compare(field.color, "#00ff00");
            root.modelColor = "#0000ff";
            tryCompare(field, "color", "#0000ff");
        }
        function test_dateSelectionPreservesBinding_data(): list<var> {
            return [{ tag: "existing-date", invalid: false }, { tag: "unset-date", invalid: true }];
        }
        function test_dateSelectionPreservesBinding(data: var): void {
            if (data.invalid) {
                root.modelDate = new Date(NaN);
            }
            const field = createTemporaryObject(dateComponent, root);
            verify(!!field, "Component exists");
            const button = findChild(field, "dateButton");
            verify(!!button, "Object exists");
            mouseClick(button);
            const popup = findChild(root, "datePopup");
            verify(!!popup, "Object exists");
            popup.value = new Date(2025, 1, 20);
            popup.accept();
            tryCompare(field, "value", new Date(2025, 1, 20));
            root.modelDate = new Date(2026, 2, 10);
            tryCompare(field, "value", root.modelDate);
        }
        function test_dateResetPreservesBinding(): void {
            const field = createTemporaryObject(dateComponent, root);
            verify(!!field, "Component exists");
            const button = findChild(field, "dateButton");
            verify(!!button, "Object exists");
            mouseClick(button);
            const popup = findChild(root, "datePopup");
            verify(!!popup, "Object exists");
            const reset = popup.footer.standardButton(Controls.DialogButtonBox.Reset);
            verify(!!reset, "Object exists");
            mouseClick(reset);
            tryVerify(() => isNaN(field.value.valueOf()));
            root.modelDate = new Date(2026, 2, 10);
            tryCompare(field, "value", root.modelDate);
        }
    }
}
