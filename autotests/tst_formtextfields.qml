// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtTest
import org.kde.kirigamiaddons.formcard as FormCard

Item {
    id: root
    width: 400
    height: 300
    property string modelText
    Component {
        id: textComponent
        FormCard.FormTextFieldDelegate {
            width: root.width
            label: "Text"
            text: root.modelText
        }
    }
    Component {
        id: passwordComponent
        FormCard.FormPasswordFieldDelegate {
            width: root.width
            label: "Password"
            text: root.modelText
        }
    }
    TestCase {
        name: "FormFieldBindings"
        when: windowShown
        function test_bindingSurvivesEditing_data(): list<var> {
            return [
                { tag: "text", component: textComponent },
                { tag: "password", component: passwordComponent }
            ];
        }
        function test_bindingSurvivesEditing(data: var): void {
            root.modelText = "Initial";
            const field = createTemporaryObject(data.component, root);
            verify(!!field, "Component exists");
            compare(field.text, "Initial");
            root.modelText = "Updated";
            tryCompare(field, "text", "Updated");
            field.forceActiveFocus();
            tryCompare(field, "fieldActiveFocus", true);
            field.selectAll();
            keySequence("A");
            tryCompare(field, "text", "a");
            root.modelText = "After typing";
            tryCompare(field, "text", "After typing");
            field.clear();
            compare(field.text, "");
            field.insert(0, "Inserted");
            compare(field.text, "Inserted");
            root.modelText = "After inserting";
            tryCompare(field, "text", "After inserting");
        }
    }
}
