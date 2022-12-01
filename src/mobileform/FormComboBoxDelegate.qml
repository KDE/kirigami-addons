/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

/**
 * Form delegate that corresponds to a combobox.
 */
AbstractFormDelegate {
    id: controlRoot

    /**
     * This signal is emitted when the item at index is activated by the user.
     */
    signal activated(int index)

    /**
     * This property holds the secondary text that appears under the main text.
     * This provides additional information about the delegate.
     *
     * This is supposed to be a short text and user of this API should avoid to make
     * it longer than two lines.
     */
    property string description: ""

    /**
     * This property holds the value of the current item in the combobox.
     */
    property alias currentValue: combobox.currentValue

    /**
     * This property holds the text of the current item in the combobox.
     */
    property alias currentText: combobox.currentText

    /**
     * This property holds the model providing data for the combobox.
     */
    property var model

    /**
     * This property holds the textRole of the internal combobox.
     */
    property alias textRole: combobox.textRole

    /**
     * This property holds the valueRole of the internal combobox.
     */
    property alias valueRole: combobox.valueRole

    /**
     * This property holds the currentIndex of the internal combobox.
     */
    property alias currentIndex: combobox.currentIndex

    /**
     * This property holds the highlightedIndex of the internal combobox.
     */
    property alias highlightedIndex: combobox.highlightedIndex

    /**
     * This property holds the displayText of the internal combobox.
     */
    property alias displayText: combobox.displayText

    enum DisplayMode {
        ComboBox,
        Dialog,
        Page
    }

    /** 
     * This property holds what display mode the delegate should show in.
     * Possible values:
     * - FormComboBoxDelegate.ComboBox - Show a classic combobox component in the delegate.
     * - FormComboBoxDelegate.Dialog - Have the full delegate be clickable and open a dialog to select values.
     * - FormComboBoxDelegate.Page - Have the full delegate be clickable and open a page in a seperate layers to select values.
     */
    property int displayMode: Kirigami.Settings.isMobile ? FormComboBoxDelegate.Dialog : FormComboBoxDelegate.ComboBox

    /**
     * The delegate component to use as entries in the combobox display mode.
     */
    property Component comboBoxDelegate: QQC2.ItemDelegate {
        implicitWidth: ListView.view ? ListView.view.width : Kirigami.Units.gridUnit * 16
        text: controlRoot.textRole ? (Array.isArray(controlRoot.model) ? modelData[controlRoot.textRole] : model[controlRoot.textRole]) : modelData
        highlighted: controlRoot.highlightedIndex === index
        property bool separatorVisible: false
        Kirigami.Theme.colorSet: controlRoot.Kirigami.Theme.inherit ? controlRoot.Kirigami.Theme.colorSet : Kirigami.Theme.View
        Kirigami.Theme.inherit: controlRoot.Kirigami.Theme.inherit
    }

    /**
     * The delegate component to use as entries in the dialog and page display mode.
     */
    property Component dialogDelegate: QQC2.RadioDelegate {
        implicitWidth: ListView.view ? ListView.view.width : Kirigami.Units.gridUnit * 16
        text: controlRoot.textRole ? (Array.isArray(controlRoot.model) ? modelData[controlRoot.textRole] : model[controlRoot.textRole]) : modelData
        checked: controlRoot.currentIndex === index
        property bool separatorVisible: false
        Kirigami.Theme.colorSet: controlRoot.Kirigami.Theme.inherit ? controlRoot.Kirigami.Theme.colorSet : Kirigami.Theme.View
        Kirigami.Theme.inherit: controlRoot.Kirigami.Theme.inherit
        onClicked: {
            controlRoot.currentIndex = index;
            controlRoot.activated(index);
            controlRoot.closeDialog();
        }
    }

    /**
     * Close the dialog or layer
     *
     * Usefull when reimplementing the page or dialog
     */
    function closeDialog() {
        if (_selectionPageItem) {
            _selectionPageItem.closeDialog();
            _selectionPageItem = null;
        }

        if (dialog) {
            dialog.close();
        }
    }

    property var _selectionPageItem: null


    // use connections instead of onClicked on root, so that users can supply
    // their own behaviour.
    Connections {
        target: controlRoot
        function onClicked() {
            if (controlRoot.displayMode === FormComboBoxDelegate.Dialog) {
                controlRoot.dialog.open();
            } else if (controlRoot.displayMode === FormComboBoxDelegate.Page) {
                controlRoot._selectionPageItem = applicationWindow().pageStack.pushDialogLayer(page)
            } else {
                combobox.popup.open();
            }
        }
    }

    /**
     * The dialog component used for the combobox.
     * 
     * Can be replaced with a custom dialog implementation.
     */
    property var dialog: Kirigami.Dialog {
        id: dialog
        showCloseButton: false
        title: controlRoot.text
        preferredWidth: Kirigami.Units.gridUnit * 16

        ColumnLayout {
            spacing: 0
            Repeater {
                model: controlRoot.model
                delegate: controlRoot.dialogDelegate
            }
        }
    }

    /**
     * The page component used for the combobox, if applicable.
     * 
     * Can be replaced with a custom page implementation.
     */
    property Component page: Kirigami.ScrollablePage {
        title: controlRoot.text

        ListView {
            spacing: 0
            model: controlRoot.model
            delegate: controlRoot.dialogDelegate
        }
    }

    function indexOfValue(value) {
        return combobox.indexOfValue(value);
    }

    focusPolicy: Qt.StrongFocus
    Accessible.description: description

    contentItem: RowLayout {
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            QQC2.Label {
                Layout.fillWidth: true
                text: controlRoot.text
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                maximumLineCount: 2
            }

            QQC2.Label {
                visible: controlRoot.description !== ""
                Layout.fillWidth: true
                text: controlRoot.description
                color: Kirigami.Theme.disabledTextColor
                wrapMode: Text.Wrap
            }
        }

        QQC2.Label {
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: Kirigami.Units.smallSpacing
            color: Kirigami.Theme.disabledTextColor
            text: controlRoot.displayText
            visible: controlRoot.displayMode === FormComboBoxDelegate.Dialog || controlRoot.displayMode === FormComboBoxDelegate.Page
        }

        QQC2.ComboBox {
            id: combobox
            focusPolicy: Qt.NoFocus // provided by parent
            model: controlRoot.model
            visible: controlRoot.displayMode == FormComboBoxDelegate.ComboBox
            delegate: controlRoot.comboBoxDelegate
            currentIndex: controlRoot.currentIndex
            onActivated: controlRoot.activated(index)
        }

        FormArrow {
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            direction: FormArrow.Down
            visible: controlRoot.displayMode === FormComboBoxDelegate.Dialog || controlRoot.displayMode === FormComboBoxDelegate.Page
        }
    }
}

