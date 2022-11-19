/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

/**
 * Form delegate that corresponds to a clickable button.
 */
AbstractFormDelegate {
    id: root
    
    /**
     * Label that appears under the main text, that provides additional information about the delegate.
     */
    property string description: ""
    
    Layout.fillWidth: true
    
    contentItem: RowLayout {
        Kirigami.Icon {
            visible: root.icon.name !== ""
            source: root.icon.name
            Layout.rightMargin: (root.icon.name !== "") ? Kirigami.Units.largeSpacing : 0
            implicitWidth: (root.icon.name !== "") ? Kirigami.Units.iconSizes.small : 0
            implicitHeight: (root.icon.name !== "") ? Kirigami.Units.iconSizes.small : 0
        }
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing
            
            Label {
                Layout.fillWidth: true
                text: root.text
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                maximumLineCount: 2
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
            }
            
            Label {
                Layout.fillWidth: true
                text: root.description
                color: Kirigami.Theme.disabledTextColor
                elide: Text.ElideRight
                visible: root.description !== ""
                wrapMode: Text.Wrap
            }
        }
        
        FormArrow {
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            direction: FormArrow.Right
        }
    }
}
