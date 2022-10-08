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
    id: root

    /**
     * Label that appears under the main text, that provides additional information about the delegate.
     */
    property string description: ""

    /**
     * Text to display as the current value of the combobox.
     */
    property alias currentValue: combobox.currentValue

    /**
     * The delegate component to use as entries in the dialog.
     */
    property alias dialogDelegate: repeater.delegate

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
        title: root.text

        // use connections instead of onClicked on root, so that users can supply
        // their own behaviour.
        Connections {
            target: root
            function onClicked() {
                if (Kirigami.Settings.isMobile) {
                    root.dialog.open();
                } else {
                    combobox.popup.open();
                }
            }
        }

        ColumnLayout {
            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: Kirigami.Theme.View
            spacing: 0

            Repeater {
                id: repeater
                model: root.model
                delegate: ItemDelegate {
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 25
                    text: root.textRole ? (Array.isArray(root.model) ? modelData[root.textRole] : model[root.textRole]) : modelData
                    highlighted: combobox.highlightedIndex == index
                    Kirigami.Theme.colorSet: root.Kirigami.Theme.inherit ? root.Kirigami.Theme.colorSet : Kirigami.Theme.View
                    Kirigami.Theme.inherit: root.Kirigami.Theme.inherit
                    onClicked: {
                        combobox.currentIndex = index;
                        combobox.activated(index);
                        root.dialog.close();
                    }
                }
            }
        }
    }

    function indexOfValue(value) {
        return combobox.indexOfValue(value);
    }

    Layout.fillWidth: true

    contentItem: RowLayout {
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            Label {
                Layout.fillWidth: true
                text: root.text
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                maximumLineCount: 2
            }

            Label {
                visible: root.description !== ""
                Layout.fillWidth: true
                text: root.description
                color: Kirigami.Theme.disabledTextColor
                font: Kirigami.Theme.smallFont
            }
        }

        Label {
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: Kirigami.Units.smallSpacing
            color: Kirigami.Theme.disabledTextColor
            text: root.currentValue
        }

        ComboBox {
            id: combobox
            model: root.model
            visible: !Kirigami.Settings.isMobile
            textRole: "display"
            onActivated: root.activated(index)
        }

        FormArrow {
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            direction: FormArrow.Down
            visible: Kirigami.Settings.isMobile
        }
    }
}

