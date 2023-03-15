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
 *
 * ```qml
 * MobileForm.FormCard {
 *     contentItem: ColumnLayout {
 *         spacing: 0
 *
 *         MobileForm.FormCardHeader {
 *             title: "Information"
 *         }
 *
 *         MobileForm.FormTextFieldDelegate {
 *             label: "Account name"
 *         }
 *
 *         MobileForm.FormTextFieldDelegate {
 *             label: "Password"
 *             statusMessage: "Password incorrect"
 *             status: Kirigami.MessageType.Error
 *             echoMode: TextInput.Password
 *             text: "666666666"
 *         }
 *
 *         MobileForm.FormTextFieldDelegate {
 *             label: "Password"
 *             statusMessage: "Password match"
 *             text: "4242424242"
 *             status: Kirigami.MessageType.Positive
 *             echoMode: TextInput.Password
 *         }
 *     }
 * }
 * ```
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
     * This property holds the inputMethodHints of the internal TextField
     */
    property alias inputMethodHints: textField.inputMethodHints

    /**
     * This property holds the placeholderText of the internal TextField
     */
    property alias placeholderText: textField.placeholderText

    /**
     * This property holds the current status of the text field.
     *
     * Depending on the status of the textField the statusMessage property will look different
     *
     * Accepted values:
     * - Kirigami.MessageType.Information
     * - Kirigami.MessageType.Positive
     * - Kirigami.MessageType.Warning
     * - Kirigami.MessageType.Error
     */
    property var status: Kirigami.MessageType.Information

    /**
     * This property holds the current status message of the text field.
     */
    property string statusMessage: ""

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

    focusPolicy: Qt.NoFocus // supplied by text field

    onClicked: textField.forceActiveFocus()
    background: Item {}

    contentItem: ColumnLayout {
        Label {
            text: label
            Layout.fillWidth: true
        }
        TextField {
            id: textField
            Accessible.description: label
            Layout.fillWidth: true
            placeholderText: root.placeholderText
            text: root.text
            onTextChanged: root.text = text
            onAccepted: root.accepted()
            onEditingFinished: root.editingFinished()
            onTextEdited: root.textEdited()
        }

        Kirigami.InlineMessage {
            id: formErrorHandler
            visible: root.statusMessage.length > 0
            Layout.topMargin: visible ? Kirigami.Units.smallSpacing : 0
            Layout.fillWidth: true
            text: root.statusMessage
            type: root.status
        }
    }
}

