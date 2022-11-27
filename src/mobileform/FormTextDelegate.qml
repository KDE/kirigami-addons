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
     * This property holds the description label item.
     */
    property Label descriptionItem: Label {
        text: root.description
        color: Kirigami.Theme.disabledTextColor
        visible: root.description !== ""
        onLinkActivated: root.linkActivated(link)
        wrapMode: Text.Wrap
    }
    
    /**
     * This property holds the text label item.
     */
    property Label textItem: Label {
        text: root.text
        elide: Text.ElideRight
        onLinkActivated: root.linkActivated(link)
        visible: root.text
    }

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
            visible: root.leading && root.leading.visible
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
            spacing: 0
            
            Private.ContentItemLoader {
                Layout.fillWidth: true
                visible: root.textItem && root.textItem.visible && root.textItem.text != ""
                implicitHeight: visible ? root.textItem.implicitHeight : 0
                implicitWidth: visible ? root.textItem.implicitWidth : 0
                contentItem: root.textItem
            }

            Private.ContentItemLoader {
                Layout.fillWidth: true
                Layout.topMargin: visible ? Kirigami.Units.smallSpacing : 0
                visible: root.descriptionItem && root.descriptionItem.visible && root.descriptionItem.text != ""
                implicitHeight: visible ? root.descriptionItem.implicitHeight : 0
                implicitWidth: visible ? root.descriptionItem.implicitWidth : 0
                contentItem: root.descriptionItem
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

