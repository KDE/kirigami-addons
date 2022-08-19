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
    property string currentValue: ""
    
    /**
     * The delegate component to use as entries in the dialog.
     */
    property alias dialogDelegate: repeater.delegate
    
    /**
     * The dialog component used for the combobox.
     */
    property var dialog: Kirigami.Dialog {
        id: dialog
        showCloseButton: false
        title: root.text
        
        ColumnLayout {
            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: Kirigami.Theme.View
            spacing: 0
            
            Repeater {
                id: repeater
            }
        }
    }
    
    /**
     * The model to use for the dialog.
     */
    property alias model: repeater.model
    
    Layout.fillWidth: true
    
    onClicked: root.dialog.open()
    
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
                elide: Text.ElideRight
            }
        }
        
        Label {
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: Kirigami.Units.smallSpacing
            color: Kirigami.Theme.disabledTextColor
            text: root.currentValue
        }
        
        FormArrow {
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            direction: FormArrow.Down
        }
    }
}

