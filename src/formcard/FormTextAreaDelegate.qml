/*
 * Copyright 2022 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

/*!
   \qmltype FormTextAreaDelegate
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A Form delegate that corresponds to a text area.

   \qml
   FormCard.FormHeader {
       title: "Information"
   }

   FormCard.FormCard {
       FormCard.FormTextAreaDelegate {
           label: "Account name"
       }
   }
   \endqml

   \since 0.11.0
 */
AbstractFormDelegate {
    id: root

    /*!
       \brief A label containing primary text that appears above and
       to the left the text field.
     */
    required property string label

    /*!
       \brief A label containing secondary text that appears under the
       inherited text property.

       This provides additional information shown in a faint gray color.

       \default ""
       \since 1.12.0
     */
    property string description: ""

    /*!
       \brief The maximum length of the text inside the TextArea if maxLength > 0.
       \default -1
     */
    property int maximumLength: -1

    /*!
       \qmlproperty bool fieldActiveFocus
       \brief This hold the \l {Item::activeFocus} {activeFocus} state of the internal TextArea.
     */
    property alias fieldActiveFocus: textArea.activeFocus

    /*!
       \qmlproperty bool readOnly
       \brief This hold the \l {TextEdit::readOnly} {readOnly} state of the internal TextArea.
     */
    property alias readOnly: textArea.readOnly

    /*!
       \qmlproperty enumeration inputMethodHints
       \brief This property holds the \l {TextEdit::inputMethodHints} {inputMethodHints} of the
       internal TextArea.

       This consists of hints on the expected content or behavior of
       the text field, be it sensitive data, in a date format, or whether
       the characters will be hidden, for example.

       \sa {TextInput::inputMethodHints} {TextInput.inputMethodHints}
     */
    property alias inputMethodHints: textArea.inputMethodHints

    /*!
       \qmlproperty string placeholderText
       \brief This property holds the \l {TextArea::placeholderText} {placeholderText} of the
       internal TextArea.

       This consists of secondary text shown by default on the text field
       if no text has been written in it.
     */
    property alias placeholderText: textArea.placeholderText

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

       default: Kirigami.MessageType.Information if statusMessage is set,
       nothing otherwise.

       \sa Kirigami.MessageType
     */
    property var status: Kirigami.MessageType.Information

    /*!
       \brief This property holds the current status message of
       the text field.

       If this property is not set, no status will be shown.
       \default ""
     */
    property string statusMessage: ""

    /*!
       \brief This signal is emitted when the Return or Enter key is pressed
       or the text input loses focus.

       Note that if there is a validator or inputMask set on the text input
       and enter/return is pressed, this signal will only be emitted if
       the input follows the inputMask and the validator returns an
       acceptable state.
     */
    signal editingFinished();

    /*!
       \brief Clears the contents of the text input and resets partial
       text input from an input method.
     */
    function clear() {
        textArea.clear();
    }

    /*!
       Inserts \a text into the TextInput at \a position.
     */
    function insert(position: int, text: string): void {
        textArea.insert(position, text);
    }

    onActiveFocusChanged: { // propagate focus to the text field
        if (activeFocus) {
            textArea.forceActiveFocus();
        }
    }

    onClicked: textArea.forceActiveFocus()
    background: null
    Accessible.role: Accessible.EditableText

    contentItem: ColumnLayout {
        spacing: Kirigami.Units.smallSpacing

        RowLayout {
            spacing: Kirigami.Units.largeSpacing

            Label {
                text: label
                elide: Text.ElideRight
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                wrapMode: Text.Wrap
                maximumLineCount: 2

                Accessible.ignored: true
                Layout.fillWidth: true
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
                visible:root.maximumLength != -1
                text: metrics.label(textArea.text.length, root.maximumLength)
                font: Kirigami.Theme.smallFont
                color: textArea.text.length === root.maximumLength
                    ? Kirigami.Theme.neutralTextColor
                    : Kirigami.Theme.textColor
                horizontalAlignment: Text.AlignRight

                Layout.margins: Kirigami.Units.smallSpacing
                Layout.preferredWidth: metrics.advanceWidth
            }
        }

        TextArea {
            id: textArea

            placeholderText: root.placeholderText
            text: root.text
            onTextChanged: root.text = text
            onEditingFinished: root.editingFinished()
            activeFocusOnTab: false
            wrapMode: TextEdit.Wrap

            Accessible.name: root.label
            Layout.fillWidth: true
        }

        Kirigami.InlineMessage {
            id: formErrorHandler

            visible: root.statusMessage.length > 0
            text: root.statusMessage
            type: root.status

            Layout.topMargin: visible ? Kirigami.Units.smallSpacing : 0
            Layout.fillWidth: true
        }

        Label {
            id: internalDescriptionItem

            Layout.fillWidth: true
            text: root.description
            color: Kirigami.Theme.disabledTextColor
            visible: root.description !== ""
            wrapMode: Text.Wrap
        }
    }
}

