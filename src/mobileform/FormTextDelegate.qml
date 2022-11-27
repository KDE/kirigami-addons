/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

import "private" as Private

/**
 * Form delegate that corresponds to a text label.
 */
AbstractFormDelegate {
    id: root

    /**
     * Label that appears under the text, providing the value of the label.
     */
    property string description: ""

    /**
     * This property holds allows for access to the description label item.
     */
    property alias descriptionItem: internalDescriptionItem
    
    /**
     * This property holds allows for access to the text label item.
     */
    property alias textItem: internalTextItem

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
    
    signal linkActivated(link: string)

    focusPolicy: Qt.NoFocus

    background: Item {}

    contentItem: RowLayout {
        spacing: 0
        
        Private.ContentItemLoader {
            Layout.rightMargin: visible ? root.leadingPadding : 0
            visible: root.leading
            implicitHeight: visible ? root.leading.implicitHeight : 0
            implicitWidth: visible ? root.leading.implicitWidth : 0
            contentItem: root.leading
        }
        
        Kirigami.Icon {
            visible: root.icon.name !== ""
            source: root.icon.name
            Layout.rightMargin: (root.icon.name !== "") ? Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing : 0
            implicitWidth: (root.icon.name !== "") ? Kirigami.Units.iconSizes.small : 0
            implicitHeight: (root.icon.name !== "") ? Kirigami.Units.iconSizes.small : 0
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing
            
            Label {
                id: internalTextItem
                Layout.fillWidth: true
                text: root.text
                elide: Text.ElideRight
                onLinkActivated: root.linkActivated(link)
                visible: root.text
            }
            
            Label {
                id: internalDescriptionItem
                Layout.fillWidth: true
                text: root.description
                color: Kirigami.Theme.disabledTextColor
                visible: root.description !== ""
                onLinkActivated: root.linkActivated(link)
                wrapMode: Text.Wrap
            }
        }
        
        Private.ContentItemLoader {
            Layout.leftMargin: visible ? root.trailingPadding : 0
            visible: root.trailing
            implicitHeight: visible ? root.trailing.implicitHeight : 0
            implicitWidth: visible ? root.trailing.implicitWidth : 0
            contentItem: root.trailing
        }
    }
}

