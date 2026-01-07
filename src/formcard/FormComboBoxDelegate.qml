/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.delegates as Delegates
import org.kde.kirigamiaddons.components as Components

/*!
   \qmltype FormComboBoxDelegate
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A Form delegate that corresponds to a ComboBox.

   This component is used for individual settings that can have multiple
   possible values shown in a vertical list, typically defined in a model.

   Many of its properties require familiarity with ComboBox.

   Use the inherited \l {AbstractButton::text} {AbstractButton.text} property to define
   the main text of the combobox.

   If you need a purely on/off toggle, use a FormSwitchDelegate instead.

   If you need an on/off/tristate toggle, use a FormCheckDelegate instead.

   If you need multiple toggles instead of multiple values for the same
   setting, consider using a FormRadioDelegate.

   \since 0.11.0

   \sa AbstractButton
   \sa FormSwitchDelegate
   \sa FormCheckDelegate
   \sa FormRadioDelegate
 */
AbstractFormDelegate {
    id: controlRoot

    /*!
       \brief This signal is emitted when the item at \a index is activated
       by the user.
     */
    signal activated(int index)

    /*!
       \brief This signal is emitted when the Return or Enter key is pressed
       while an editable combo box is focused.

       \sa editable
     */
    signal accepted()

    /*!
       \brief A label that contains secondary text that appears under the
       inherited text property.

       This provides additional information shown in a faint gray color.

       This is supposed to be a short text and the API user should avoid
       making it longer than two lines.
       \default ""
     */
    property string description: ""

    /*!
       \qmlproperty var currentValue
       \brief This property holds the \l {ComboBox::currentValue} {currentValue} of the internal ComboBox.
     */
    property alias currentValue: combobox.currentValue

    /*!
       \qmlproperty string currentText
       \brief This property holds the \l {ComboBox::currentText} {currentText} of the internal ComboBox.
       \sa displayText
     */
    property alias currentText: combobox.currentText

    /*!
       \brief This property holds the \l {ComboBox::model} {model} providing data for the ComboBox.
       \sa displayText
       \sa {https://doc.qt.io/qt-6/qtquick-modelviewsdata-modelview.html} {Models and Views in QtQuick}
     */
    property var model

    /*!
       \qmlproperty int count
       \brief This property holds the \l {ComboBox::count} {count} of the internal ComboBox.
       \since 1.4.0
     */
    property alias count: combobox.count

    /*!
       \qmlproperty string textRole
       \brief This property holds the \l {ComboBox::textRole} {textRole} of the internal ComboBox.
     */
    property alias textRole: combobox.textRole

    /*!
       \qmlproperty string valueRole
       \brief This property holds the \l {ComboBox::valueRole} {valueRole} of the internal ComboBox.
     */
    property alias valueRole: combobox.valueRole

    /*!
       \qmlproperty int currentIndex
       \brief This property holds the \l {ComboBox::currentIndex} {currentIndex} of the internal ComboBox.

       Default: \c -1 when the model has no data, \c 0 otherwise
     */
    property alias currentIndex: combobox.currentIndex

    /*!
       \qmlproperty int highlightedIndex
       \brief This property holds the \l {ComboBox::highlightedIndex} {highlightedIndex} of the internal ComboBox.
     */
    property alias highlightedIndex: combobox.highlightedIndex

    /*!
       \qmlproperty string displayText
       \brief This property holds the \l {ComboBox::displayText} {displayText} of the internal ComboBox.

       This can be used to slightly modify the text to be displayed in the combobox, for instance, by adding a string with the currentText.
     */
    property alias displayText: combobox.displayText

    /*!
       \qmlproperty bool editable
       \brief This property holds the \l {ComboBox::editable} {editable} property of the internal ComboBox.

       This turns the combobox editable, allowing the user to specify
       existing values or add new ones.

       Use this only when displayMode is set to
       FormComboBoxDelegate.ComboBox.
     */
    property alias editable: combobox.editable

    /*!
       \qmlproperty string editText
       \brief This property holds the \l {ComboBox::editText} {editText} property of the internal ComboBox.
     */
    property alias editText: combobox.editText

    /*!
     *       \brief This property holds an item that will be displayed after the
     *       delegate's contents.
     *
     *       \default null
     *       \since 1.11.0
     */
    property var trailing: null

    enum DisplayMode {
        ComboBox,
        Dialog,
        Page
    }

    /*!
       \brief This property holds what display mode the delegate should show as.

       Set this property to the desired DisplayMode.

       On mobile, displayMode defaults to \c FormComboBoxDelegate.Dialog.

       \default FormComboBoxDelegate.ComboBox

       \value FormComboBoxDelegate.ComboBox
              A standard ComboBox component containing a vertical list of values.
       \value FormComboBoxDelegate.Dialog
              A button with similar appearance to a ComboBox that, when clicked,
              shows a \l OverlaySheet {Kirigami.OverlaySheet} at the middle of the window
              containing a vertical list of values.
       \value FormComboBoxDelegate.Page
              A button with similar appearance to a ComboBox that, when clicked,
              shows a \l ScrollablePage {Kirigami.ScrollablePage} in a new window containing a
              vertical list of values.
     */
    property int displayMode: Kirigami.Settings.isMobile ? FormComboBoxDelegate.Dialog : FormComboBoxDelegate.ComboBox

    /*!
       \brief The delegate component to use as entries in the ComboBox display mode.
     */
    property Component comboBoxDelegate: Delegates.RoundedItemDelegate {
        required property var model
        required property int index

        implicitWidth: ListView.view ? ListView.view.width : Kirigami.Units.gridUnit * 16
        text: model[controlRoot.textRole]
        highlighted: controlRoot.highlightedIndex === index
    }

    /*!
       \brief The delegate component to use as entries for each value in the dialog and page display mode.
     */
    property Component dialogDelegate: Delegates.RoundedItemDelegate {
        required property var model
        required property int index

        implicitWidth: ListView.view ? ListView.view.width : Kirigami.Units.gridUnit * 16
        text: model[controlRoot.textRole]

        Layout.topMargin: index == 0 ? Math.round(Kirigami.Units.smallSpacing / 2) : 0

        onClicked: {
            controlRoot.currentIndex = index;
            controlRoot.activated(index);
            controlRoot.closeDialog();
        }
    }

    /*!
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
       \since 1.5.0
     */
    property var status: Kirigami.MessageType.Information

    /*!
       \brief This property holds the current status message of
       the text field.

       If this property is not set, no status will be shown.

       \since 1.5.0
     */
    property string statusMessage: ""

    /*!
       \brief Closes the dialog or layer.

       This function can be used when reimplementing the page or dialog.
     */
    function closeDialog() {
        if (_selectionPageItem) {
            _selectionPageItem.closeDialog();
            _selectionPageItem = null;
        }

        if (_selectionDialogItem) {
            _selectionDialogItem.close();
        }
    }

    property var _selectionPageItem: null
    property var _selectionDialogItem: null
    property real __indicatorMargin: controlRoot.indicator && controlRoot.indicator.visible && controlRoot.indicator.width > 0 ? controlRoot.spacing + indicator.width + controlRoot.spacing : 0

    leftPadding: horizontalPadding + (!controlRoot.mirrored ? 0 : __indicatorMargin)
    rightPadding: horizontalPadding + (controlRoot.mirrored ? 0 : __indicatorMargin)


    // use connections instead of onClicked on root, so that users can supply
    // their own behaviour.
    Connections {
        target: controlRoot
        function onClicked() {
            if (controlRoot.displayMode === FormComboBoxDelegate.Dialog) {
                controlRoot._selectionDialogItem = controlRoot.dialog.createObject();
                controlRoot._selectionDialogItem.open();
            } else if (controlRoot.displayMode === FormComboBoxDelegate.Page) {
                controlRoot._selectionPageItem = controlRoot.QQC2.ApplicationWindow.window.pageStack.pushDialogLayer(page)
            } else {
                combobox.popup.open();
                combobox.forceActiveFocus(Qt.PopupFocusReason);
            }
        }
    }

    /*!
       \brief The dialog component used for the ComboBox.

       This property allows to override the internal dialog
       with a custom component.
     */
    property Component dialog: QQC2.Dialog {
        id: dialog

        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        z: Kirigami.OverlayZStacking.z

        title: controlRoot.text
        implicitWidth: Math.min(parent.width - Kirigami.Units.gridUnit * 2, Kirigami.Units.gridUnit * 22)
        parent: controlRoot.QQC2.Overlay.overlay
        background: Components.DialogRoundedBackground {}

        implicitHeight: Math.min(
            Math.max(implicitBackgroundHeight + topInset + bottomInset,
                     contentHeight + topPadding + bottomPadding
                     + (implicitHeaderHeight > 0 ? implicitHeaderHeight + spacing : 0)
                     + (implicitFooterHeight > 0 ? implicitFooterHeight + spacing : 0)),
            parent.height - Kirigami.Units.gridUnit * 2)

        onClosed: destroy();

        modal: true
        focus: true
        padding: 0

        header: Kirigami.Heading {
            text: dialog.title
            elide: QQC2.Label.ElideRight
            leftPadding: Kirigami.Units.largeSpacing
            rightPadding: Kirigami.Units.largeSpacing
            topPadding: Kirigami.Units.largeSpacing
            bottomPadding: Kirigami.Units.largeSpacing
        }

        contentItem: ColumnLayout {
            spacing: 0

            Kirigami.Separator {
                visible: !listView.atYBeginning
                Layout.fillWidth: true
            }

            QQC2.ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Layout.margins: 2

                Component.onCompleted: if (background) {
                    background.visible = false;
                }

                ListView {
                    id: listView

                    clip: true
                    model: controlRoot.model
                    delegate: controlRoot.dialogDelegate
                    currentIndex: controlRoot.currentIndex
                    onCurrentIndexChanged: controlRoot.currentIndex = currentIndex
                }
            }

            Kirigami.Separator {
                visible: controlRoot.editable
                Layout.fillWidth: true
            }

            QQC2.TextField {
                visible: controlRoot.editable
                onTextChanged: controlRoot.editText = text;
                Layout.fillWidth: true
            }
        }
    }

    /*!
       \brief The page component used for the ComboBox, if applicable.

       This property allows to override the internal
       \l ScrollablePage {Kirigami.ScrollablePage} with a custom component.
     */
    property Component page: Kirigami.ScrollablePage {
        title: controlRoot.text

        ListView {
            spacing: 0
            model: controlRoot.model
            delegate: controlRoot.dialogDelegate

            footer: QQC2.TextField {
                visible: controlRoot.editable
                onTextChanged: controlRoot.editText = text;
                Layout.fillWidth: true
            }
        }
    }

    function indexOfValue(value) {
        return combobox.indexOfValue(value);
    }

    focusPolicy: displayMode === FormComboBoxDelegate.ComboBox ? Qt.NoFocus : Qt.StrongFocus
    Accessible.description: description
    Accessible.onPressAction: controlRoot.clicked()

    // Only have the mouse hover feedback if the combobox is the whole delegate itself
    background: displayMode === FormComboBoxDelegate.ComboBox ? null : selectableBackground
    FormDelegateBackground { id: selectableBackground; control: controlRoot }

    contentItem: ColumnLayout {
        spacing: Kirigami.Units.smallSpacing

        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            QQC2.Label {
                Layout.fillWidth: true
                text: controlRoot.text
                elide: Text.ElideRight
                color: controlRoot.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                wrapMode: Text.Wrap
                maximumLineCount: 2
                Accessible.ignored: true
            }

            QQC2.Label {
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: Kirigami.Units.smallSpacing
                color: Kirigami.Theme.disabledTextColor
                text: controlRoot.displayText
                visible: controlRoot.displayMode === FormComboBoxDelegate.Dialog || controlRoot.displayMode === FormComboBoxDelegate.Page
            }

            FormArrow {
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                direction: Qt.DownArrow
                visible: controlRoot.displayMode === FormComboBoxDelegate.Dialog || controlRoot.displayMode === FormComboBoxDelegate.Page
            }

            LayoutItemProxy {
                target: controlRoot.trailing
                visible: Kirigami.Settings.isMobile
            }
        }

        RowLayout {
            id: innerRow

            spacing: Kirigami.Units.smallSpacing

            Layout.fillWidth: true

            QQC2.ComboBox {
                id: combobox
                focusPolicy: controlRoot.displayMode === FormComboBoxDelegate.ComboBox ? Qt.StrongFocus : Qt.NoFocus
                model: controlRoot.model
                visible: controlRoot.displayMode == FormComboBoxDelegate.ComboBox
                delegate: controlRoot.comboBoxDelegate
                currentIndex: controlRoot.currentIndex
                onActivated: index => controlRoot.activated(index)
                onAccepted: controlRoot.accepted()
                popup.contentItem.clip: true
                Layout.fillWidth: true
            }

            LayoutItemProxy {
                target: controlRoot.trailing
                visible: !Kirigami.Settings.isMobile
            }
        }

        QQC2.Label {
            visible: controlRoot.description !== ""
            Layout.fillWidth: true
            text: controlRoot.description
            color: Kirigami.Theme.disabledTextColor
            wrapMode: Text.Wrap
            Accessible.ignored: true
        }

        Kirigami.InlineMessage {
            visible: controlRoot.statusMessage.length > 0
            Layout.topMargin: visible ? Kirigami.Units.smallSpacing : 0
            Layout.fillWidth: true
            text: controlRoot.statusMessage
            type: controlRoot.status
        }
    }
}

