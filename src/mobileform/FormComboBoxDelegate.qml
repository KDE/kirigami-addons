/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

/**
 * Form delegate that corresponds to a combobox.
 */
AbstractFormDelegate {
    id: controlRoot

    /**
     * Label that appears under the main text, that provides additional information about the delegate.
     */
    property string description: ""

    /**
     * Text to display as the current value of the combobox.
     */
    property alias currentValue: combobox.currentValue

    /**
     * The delegate component to use as entries in the dialog and combobox.
     */
    property Component delegate: ItemDelegate {
        implicitWidth: ListView.view ? ListView.view.width : Kirigami.Units.gridUnit * 16
        text: controlRoot.textRole ? (Array.isArray(controlRoot.model) ? modelData[controlRoot.textRole] : model[controlRoot.textRole]) : modelData
        highlighted: controlRoot.highlightedIndex == index
        property bool separatorVisible: false
        Kirigami.Theme.colorSet: controlRoot.Kirigami.Theme.inherit ? controlRoot.Kirigami.Theme.colorSet : Kirigami.Theme.View
        Kirigami.Theme.inherit: controlRoot.Kirigami.Theme.inherit
        onClicked: if (Kirigami.Settings.isMobile) {
            combobox.currentIndex = index;
            combobox.activated(index);
            controlRoot.dialog.close();
        }
    }

    /**
     * The model to use for the dialog.
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
     * This signal is emitted when the item at index is activated by the user.
     */
    signal activated(int index)

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

        ScrollView {
            implicitWidth: Kirigami.Units.gridUnit * 16
            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: Kirigami.Theme.View
            ListView {
                spacing: 0
                model: controlRoot.model
                delegate: controlRoot.delegate
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

            Label {
                Layout.fillWidth: true
                text: controlRoot.text
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                maximumLineCount: 2
            }

            Label {
                visible: controlRoot.description !== ""
                Layout.fillWidth: true
                text: controlRoot.description
                color: Kirigami.Theme.disabledTextColor
                font: Kirigami.Theme.smallFont
            }
        }

        Label {
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: Kirigami.Units.smallSpacing
            color: Kirigami.Theme.disabledTextColor
            text: controlRoot.currentValue
            visible: Kirigami.Settings.isMobile
        }

        ComboBox {
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

