/*
 * Copyright 2022 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

/*!
   \qmltype FormPasswordFieldDelegate
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A Form delegate that corresponds to a password field.

   \qml
   FormCard.FormHeader {
       title: "Information"
   }

   FormCard.FormCard {
       FormCard.FormTextFieldDelegate {
           label: "Account name"
       }

       FormCard.FormPasswordFieldDelegate {
           label: "Password"
           statusMessage: "Password incorrect"
           status: Kirigami.MessageType.Error
           text: "666666666"
       }

       FormCard.FormPasswordFieldDelegate {
           label: "Password repeat"
           statusMessage: "Password match"
           text: "4242424242"
           status: Kirigami.MessageType.Positive
           echoMode: TextInput.Password
       }
   }
   \endqml

   \since 0.11.0
 */
AbstractFormDelegate {
    id: root

    /*!
       \brief A label containing primary text that appears above and
       to the left of the text field.
     */
    required property string label

    /*!
       \qmlproperty int maximumLength
       \brief The maximum length of the text inside the TextField if maxLength > 0.
     */
    property alias maximumLength: textField.maximumLength

    /*!
       \qmlproperty bool fieldActiveFocus
       \brief This hold the \l {Item::activeFocus} {activeFocus} state of the internal TextField.
    */
    property alias fieldActiveFocus: textField.activeFocus

    /*!
       \qmlproperty bool readOnly
       \brief This hold the \l {TextInput::readOnly} {readOnly} state of the internal TextField.
     */
    property alias readOnly: textField.readOnly

    /*!
       \qmlproperty enumeration echoMode
       \brief This property holds the \l {TextInput::echoMode} {echoMode} of the internal TextField.

       This consists of how the text inside the text field will be
       displayed to the user.

       \sa {TextInput::echoMode} {TextInput.echoMode}
     */
    property alias echoMode: textField.echoMode

    /*!
       \qmlproperty enumeration inputMethodHints
       \brief This property holds the \l {TextInput::inputMethodHints} {inputMethodHints} of the
       internal TextField.

       This consists of hints on the expected content or behavior of
       the text field, be it sensitive data, in a date format, or whether
       the characters will be hidden, for example.

       \sa {TextInput::inputMethodHints} {TextInput.inputMethodHints}
     */
    property alias inputMethodHints: textField.inputMethodHints

    /*!
       \qmlproperty string placeholderText
       \brief This property holds the \l {TextInput::placeholderText} {placeholderText} of the
       internal TextField.

       This consists of secondary text shown by default on the text field
       if no text has been written in it.
     */
    property alias placeholderText: textField.placeholderText

    /*!
       \qmlproperty Validator validator
       \brief This property holds the \l {TextInput::validator} {validator} of the internal TextField.
     */
    property alias validator: textField.validator

    /*!
       \qmlproperty bool acceptableInput
       \brief This property holds the \l {TextInput::acceptableInput} {acceptableInput} of the internal TextField.
     */
    property alias acceptableInput: textField.acceptableInput

    /*!
       \qmlproperty var status
       \brief This property holds the current status message type of
       the text field.

       This consists of an inline message with a colorful background
       and an appropriate icon.

       The status property will affect the color of statusMessage used.

       Accepted values:
       \value Kirigami.MessageType.Information (blue color)
       \value Kirigami.MessageType.Positive (green color)
       \value Kirigami.MessageType.Warning (orange color)
       \value Kirigami.MessageType.Error (red color)

       Default: Kirigami.MessageType.Information if statusMessage is set,
       nothing otherwise.

       \sa Kirigami.MessageType
     */
    property var status: Kirigami.MessageType.Information

    /*!
       \brief This property holds the current status message of
       the text field.

       If this property is not set, no \l status will be shown.
       \default ""
     */
    property string statusMessage: ""

    /*!
       \brief This property holds whether the password quality is shown.

       This allows users to see whether their password is secure when choosing
       a new password.
       \default false
     */
    property bool showPasswordQuality: false

    /*!
       \brief This signal is emitted when the Return or Enter key is pressed.

       Note that if there is a \l validator or \l {TextInput::inputMask} {inputMask} set on the text input,
       the signal will only be emitted if the input is in an acceptable
       state.
     */
    signal accepted();

    /*!
       \brief This signal is emitted when the Return or Enter key is pressed
       or the text input loses focus.

       Note that if there is a \l validator or \l {TextInput::inputMask} {inputMask} set on the text input
       and enter/return is pressed, this signal will only be emitted if
       the input follows the inputMask and the validator returns an
       acceptable state.
     */
    signal editingFinished();

    /*!
       \brief This signal is emitted whenever the text is edited.

       Unlike textChanged(), this signal is not emitted when the text
       is changed programmatically, for example, by changing the
       value of the text property or by calling clear().
     */
    signal textEdited();

    /*!
       \brief Clears the contents of the text input and resets partial
       text input from an input method.
     */
    function clear(): void {
        textField.clear();
    }

    /*!
       Inserts \a text into the TextInput at \a position.
     */
    function insert(position: int, text: string): void {
        textField.insert(position, text);
    }

    /*!
       Causes all text to be selected.
       \since 1.4.0
     */
    function selectAll(): void {
        textField.selectAll();
    }

    /*!
       Causes the text from \a start to \a end to be selected.
       \since 1.4.0
     */
    function select(start: int, end: int): void {
        textField.select(start, end);
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
            }
            Label {
                TextMetrics {
                    id: metrics
                    text: label(root.maximumLength, root.maximumLength)
                    font: Kirigami.Theme.smallFont

                    function label(current: int, maximum: int): string {
                        return i18ndc("kirigami-addons6", "@label %1 is current text length, %2 is maximum length of text field", "%1/%2", current, maximum)
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

        Kirigami.PasswordField {
            id: textField
            Accessible.description: label
            Layout.fillWidth: true
            placeholderText: root.placeholderText
            text: root.text
            onTextChanged: root.text = text
            onAccepted: root.accepted()
            onEditingFinished: root.editingFinished()
            onTextEdited: root.textEdited()
            activeFocusOnTab: false
        }

        Loader {
            active: root.showPasswordQuality
            Layout.fillWidth: true
            sourceComponent: RowLayout {
                spacing: 2

                PasswordHealth {
                    id: passwordHealth
                    password: textField.text
                }

                Repeater {
                    model: 4

                    Rectangle {
                        id: rect

                        required property int index

                        height: Kirigami.Units.smallSpacing

                        radius: 1

                        color: switch (passwordHealth.quality) {
                        case PasswordHealth.Bad:
                        case PasswordHealth.Poor:
                            return Kirigami.Theme.negativeBackgroundColor;
                        case PasswordHealth.Weak:
                            return Kirigami.Theme.neutralBackgroundColor;
                        case PasswordHealth.Good:
                        case PasswordHealth.Excellent:
                            return Kirigami.Theme.positiveBackgroundColor;
                        }

                        Layout.fillWidth: true

                        Rectangle {
                            height: Kirigami.Units.smallSpacing
                            width: {
                                const maxEntropy = 100;
                                const entropy = Math.min(passwordHealth.entropy, maxEntropy);
                                if (entropy > (index + 1) * (maxEntropy / 4)) {
                                    return parent.width;
                                } else if (entropy < (index) * (maxEntropy / 4)) {
                                    return 0;
                                }
                                const percent = entropy / maxEntropy;
                                return Math.max(0, parent.width * (percent * 4 - index))
                            }

                            radius: 1

                            color: switch (passwordHealth.quality) {
                            case PasswordHealth.Bad:
                            case PasswordHealth.Poor:
                                return Kirigami.Theme.negativeTextColor;
                            case PasswordHealth.Weak:
                                return Kirigami.Theme.neutralTextColor;
                            case PasswordHealth.Good:
                            case PasswordHealth.Excellent:
                                return Kirigami.Theme.positiveTextColor;
                            }
                        }
                    }
                }
            }
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

