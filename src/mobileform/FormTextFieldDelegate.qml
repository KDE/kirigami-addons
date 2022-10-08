/*
 * Copyright 2022 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

/**
 * Form delegate that corresponds to a text label.
 */
AbstractFormDelegate {
    id: root

    /**
     * This propery holds the label that appears above the textField.
     */
    required property string label

    /**
     * This property holds the echoMode of the internal TextField
     */
    property alias echoMode: textField.echoMode

    /**
     * This signal is emitted when the Return or Enter key is pressed. Note that if there
     * is a validator or inputMask set on the text input, the signal will only be emitted
     * if the input is in an acceptable state.
     */
    signal accepted();

    /**
     * This signal is emitted when the Return or Enter key is pressed or the text input
     * loses focus. Note that if there is a validator or inputMask set on the text input
     * and enter/return is pressed, this signal will only be emitted if the input follows
     * the inputMask and the validator returns an acceptable state.
     */
    signal editingFinished();

    /**
     * This signal is emitted whenever the text is edited. Unlike textChanged(), this signal
     * is not emitted when the text is changed programmatically, for example, by changing the
     * value of the text property or by calling clear().
     */
    signal textEdited();

    /**
     * Clears the contents of the text input and resets partial text input from an input method.
     */
    function clear() {
        textField.clear();
    }

    Layout.fillWidth: true

    onClicked: textField.forceActiveFocus()

    contentItem: ColumnLayout {
        Label {
            text: label
            Layout.fillWidth: true
        }
        TextField {
            id: textField
            Accessible.description: label.text
            Layout.fillWidth: true
            onTextChanged: root.text = text
            onAccepted: root.accepted()
            onEditingFinished: root.editingFinished()
            onTextEdited: root.textEdited()
        }
    }
}

