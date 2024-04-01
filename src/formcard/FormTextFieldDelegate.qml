/*
 * Copyright 2022 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

/**
 * @brief A Form delegate that corresponds to a text field.
 *
 * ```qml
 *
 * FormCard.FormHeader {
 *     title: "Information"
 * }
 *
 * FormCard.FormCard {
 *     FormCard.FormTextFieldDelegate {
 *         label: "Account name"
 *     }
 *
 *     FormCard.FormTextFieldDelegate {
 *         label: "Password"
 *         statusMessage: "Password incorrect"
 *         status: Kirigami.MessageType.Error
 *         echoMode: TextInput.Password
 *         text: "666666666"
 *     }
 *
 *     FormCard.FormTextFieldDelegate {
 *         label: "Password"
 *         statusMessage: "Password match"
 *         text: "4242424242"
 *         status: Kirigami.MessageType.Positive
 *         echoMode: TextInput.Password
 *     }
 * }
 * ```
 *
 * @since KirigamiAddons 0.11.0
 *
 * @inherit AbstractFormDelegate
 */
AbstractFormDelegate {
    id: root

    /**
     * @brief A label containing primary text that appears above and
     * to the left the text field.
     */
    required property string label

    /**
     * @brief set the maximum length of the text inside the TextField if maxLength > 0
     */
    property alias maximumLength: textField.maximumLength

    /**
     * @brief This hold the activeFocus state of the internal TextField.
    */
    property alias fieldActiveFocus: textField.activeFocus

    /**
     * @brief This hold the `readOnly` state of the internal TextField.
     */
    property alias readOnly: textField.readOnly

    /**
     * @brief This property holds the `echoMode` of the internal TextField.
     *
     * This consists of how the text inside the text field will be
     * displayed to the user.
     *
     * @see <a href="https://doc.qt.io/qt-6/qml-qtquick-textinput.html#echoMode-prop">TextInput.echoMode</a>
     */
    property alias echoMode: textField.echoMode

    /**
     * @brief This property holds the `inputMethodHints` of the
     * internal TextField.
     *
     * This consists of hints on the expected content or behavior of
     * the text field, be it sensitive data, in a date format, or whether
     * the characters will be hidden, for example.
     *
     * @see <a href="https://doc.qt.io/qt-6/qml-qtquick-textinput.html#inputMethodHints-prop">TextInput.inputMethodHints</a>
     */
    property alias inputMethodHints: textField.inputMethodHints

    /**
     * @brief This property holds the `placeholderText` of the
     * internal TextField.
     *
     * This consists of secondary text shown by default on the text field
     * if no text has been written in it.
     */
    property alias placeholderText: textField.placeholderText

    /**
     * @brief This property holds the `validator` of the internal TextField.
     */
    property alias validator: textField.validator

    /**
     * @brief This property holds the `acceptableInput` of the internal TextField.
     */
    property alias acceptableInput: textField.acceptableInput

    /**
     * @brief This property holds the current status message type of
     * the text field.
     *
     * This consists of an inline message with a colorful background
     * and an appropriate icon.
     *
     * The status property will affect the color of ::statusMessage used.
     *
     * Accepted values:
     * - `Kirigami.MessageType.Information` (blue color)
     * - `Kirigami.MessageType.Positive` (green color)
     * - `Kirigami.MessageType.Warning` (orange color)
     * - `Kirigami.MessageType.Error` (red color)
     *
     * default: `Kirigami.MessageType.Information` if ::statusMessage is set,
     * nothing otherwise.
     *
     * @see Kirigami.MessageType
     */
    property var status: Kirigami.MessageType.Information

    /**
     * @brief This property holds the current status message of
     * the text field.
     *
     * If this property is not set, no ::status will be shown.
     */
    property string statusMessage: ""

    /**
     * @This signal is emitted when the Return or Enter key is pressed.
     *
     * Note that if there is a validator or inputMask set on the text input,
     * the signal will only be emitted if the input is in an acceptable
     * state.
     */
    signal accepted();

    /**
     * @brief This signal is emitted when the Return or Enter key is pressed
     * or the text input loses focus.
     *
     * Note that if there is a validator or inputMask set on the text input
     * and enter/return is pressed, this signal will only be emitted if
     * the input follows the inputMask and the validator returns an
     * acceptable state.
     */
    signal editingFinished();

    /**
     * @brief This signal is emitted whenever the text is edited.
     *
     * Unlike textChanged(), this signal is not emitted when the text
     * is changed programmatically, for example, by changing the
     * value of the text property or by calling ::clear().
     */
    signal textEdited();

    /**
     * @brief Clears the contents of the text input and resets partial
     * text input from an input method.
     */
    function clear() {
        textField.clear();
    }

    /**
     * Inserts text into the TextInput at position.
     */
    function insert(position: int, text: string) {
        textField.insert(position, text);
    }

    onActiveFocusChanged: { // propagate focus to the text field
        if (activeFocus) {
            textField.forceActiveFocus();
        }
    }

    onClicked: textField.forceActiveFocus()
    background: null
    Accessible.role: Accessible.EditableText

    contentItem: ColumnLayout {
        spacing: Kirigami.Units.smallSpacing
        RowLayout {
            spacing: Kirigami.Units.largeSpacing
            Label {
                Layout.fillWidth: true
                text: label
                elide: Text.ElideRight
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                wrapMode: Text.Wrap
                maximumLineCount: 2
                Accessible.ignored: true
            }
            Label {
                TextMetrics {
                    id: metrics
                    text: label(root.maximumLength, root.maximumLength)
                    font: Kirigami.Theme.smallFont

                    function label(current: int, maximum: int): string {
                        return i18nc("@label %1 is current text length, %2 is maximum length of text field", "%1/%2", current, maximum)
                    }
                }
                // 32767 is the default value for TextField.maximumLength
                visible: root.maximumLength < 32767
                text: metrics.label(textField.text.length, root.maximumLength)
                font: Kirigami.Theme.smallFont
                color: textField.text.length === root.maximumLength
                    ? Kirigami.Theme.neutralTextColor
                    : Kirigami.Theme.textColor
                horizontalAlignment: Text.AlignRight

                Layout.margins: Kirigami.Units.smallSpacing
                Layout.preferredWidth: metrics.advanceWidth
            }
        }
        TextField {
            id: textField
            Accessible.name: root.label
            Layout.fillWidth: true
            placeholderText: root.placeholderText
            text: root.text
            onTextChanged: root.text = text
            onAccepted: root.accepted()
            onEditingFinished: root.editingFinished()
            onTextEdited: root.textEdited()
            activeFocusOnTab: false
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

