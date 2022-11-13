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
     * Label that appears under the main text, that provides additional information about the delegate.
     */
    property string description: ""

    /**
     * This property holds the value of the current item in the combo box.
     */
    property alias currentValue: combobox.currentValue

    /**
     * This property holds the text of the current item in the combo box.
     */
    property alias currentText: combobox.currentText

    /**
     * This property holds the model providing data for the combo box.
     */
    property var model

    /**
     * This property holds the textRole of the internal combobox
     */
    property alias textRole: combobox.textRole

    /**
     * This property holds the valueRole of the internal combobox
     */
    property alias valueRole: combobox.valueRole

    /**
     * This property holds the currentIndex of the internal combobox
     */
    property alias currentIndex: combobox.currentIndex

    /**
     * This property holds the highlightedIndex of the internal combobox
     */
    property alias highlightedIndex: combobox.highlightedIndex

    /**
     * The delegate component to use as entries in the desktop combobox.
     */
    property Component delegate: QQC2.ItemDelegate {
        implicitWidth: ListView.view ? ListView.view.width : Kirigami.Units.gridUnit * 16
        text: controlRoot.textRole ? (Array.isArray(controlRoot.model) ? modelData[controlRoot.textRole] : model[controlRoot.textRole]) : modelData
        highlighted: controlRoot.highlightedIndex === index
        property bool separatorVisible: false
        Kirigami.Theme.colorSet: controlRoot.Kirigami.Theme.inherit ? controlRoot.Kirigami.Theme.colorSet : Kirigami.Theme.View
        Kirigami.Theme.inherit: controlRoot.Kirigami.Theme.inherit
    }

    /**
     * The delegate component to use as entries in the mobile combobox.
     */
    property Component mobileDelegate: QQC2.RadioDelegate {
        implicitWidth: ListView.view ? ListView.view.width : Kirigami.Units.gridUnit * 16
        text: controlRoot.textRole ? (Array.isArray(controlRoot.model) ? modelData[controlRoot.textRole] : model[controlRoot.textRole]) : modelData
        checked: controlRoot.currentIndex === index
        property bool separatorVisible: false
        Kirigami.Theme.colorSet: controlRoot.Kirigami.Theme.inherit ? controlRoot.Kirigami.Theme.colorSet : Kirigami.Theme.View
        Kirigami.Theme.inherit: controlRoot.Kirigami.Theme.inherit
        onClicked: {
            combobox.currentIndex = index;
            combobox.activated(index);
            controlRoot.dialog.close();
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

        // use connections instead of onClicked on root, so that users can supply
        // their own behaviour.
        Connections {
            target: controlRoot
            function onClicked() {
                if (Kirigami.Settings.isMobile) {
                    controlRoot.dialog.open();
                } else {
                    combobox.popup.open();
                }
            }
        }

        QQC2.ScrollView {
            implicitWidth: Kirigami.Units.gridUnit * 16
            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: Kirigami.Theme.View
            ListView {
                spacing: 0
                model: controlRoot.model
                delegate: controlRoot.mobileDelegate
            }
        }
    }

    function indexOfValue(value) {
        return combobox.indexOfValue(value);
    }

    Layout.fillWidth: true
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
                font: Kirigami.Theme.smallFont
            }
        }

        QQC2.Label {
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: Kirigami.Units.smallSpacing
            color: Kirigami.Theme.disabledTextColor
            text: controlRoot.currentText
            visible: Kirigami.Settings.isMobile
        }

        QQC2.ComboBox {
            id: combobox
            model: controlRoot.model
            visible: !Kirigami.Settings.isMobile
            delegate: controlRoot.delegate
            currentIndex: controlRoot.currentIndex
            onActivated: controlRoot.activated(index)
        }

        FormArrow {
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            direction: FormArrow.Down
            visible: Kirigami.Settings.isMobile
        }
    }
}

