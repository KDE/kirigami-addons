/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

import "private" as Private

/**
 * Form delegate that corresponds to a switch.
 */
T.SwitchDelegate {
    id: root
    
    /**
     * Label that appears under the main text, that provides additional information about the delegate.
     */
    property string description: ""
    
    /**
     * This property holds an item that will be displayed before the delegate's contents.
     */
    property var leading: null
    
    /**
     * This property holds the padding after the leading item.
     */
    property real leadingPadding: Kirigami.Units.smallSpacing
    
    /**
     * This property holds an item that will be displayed after the delegate's contents.
     */
    property var trailing: null
    
    /**
     * This property holds the padding before the trailing item.
     */
    property real trailingPadding: Kirigami.Units.smallSpacing
    
    leftPadding: Kirigami.Units.gridUnit
    topPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    bottomPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    rightPadding: Kirigami.Units.gridUnit
    
    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
    
    focusPolicy: Qt.StrongFocus
    hoverEnabled: true
    background: FormDelegateBackground { control: root }
    
    Layout.fillWidth: true
    
    contentItem: RowLayout {
        spacing: 0
        
        Private.ContentItemLoader {
            Layout.rightMargin: visible ? root.leadingPadding : 0
            visible: root.leading && root.leading.visible
            implicitHeight: visible ? root.leading.implicitHeight : 0
            implicitWidth: visible ? root.leading.implicitWidth : 0
            contentItem: root.leading
        }
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing
            
            Controls.Label {
                Layout.fillWidth: true
                text: root.text
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                maximumLineCount: 2
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
            }
            
            Controls.Label {
                visible: root.description !== ""
                Layout.fillWidth: true
                text: root.description
                wrapMode: Text.Wrap
                color: Kirigami.Theme.disabledTextColor
            }
        }
        
        Controls.Switch {
            id: switchItem
            focusPolicy: Qt.NoFocus // provided by delegate
            Layout.leftMargin: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
            
            enabled: root.enabled
            checked: root.checked
            
            onToggled: root.toggled()
            onClicked: root.clicked()
            onPressAndHold: root.pressAndHold()
            onDoubleClicked: root.doubleClicked()
            
            onCheckedChanged: {
                root.checked = checked;
                checked = Qt.binding(() => root.checked);
            }
        }
        
        Private.ContentItemLoader {
            Layout.leftMargin: visible ? root.trailingPadding : 0
            visible: root.trailing && root.trailing.visible
            implicitHeight: visible ? root.trailing.implicitHeight : 0
            implicitWidth: visible ? root.trailing.implicitWidth : 0
            contentItem: root.trailing
        }
    }
}
