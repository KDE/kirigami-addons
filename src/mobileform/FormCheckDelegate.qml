/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

/**
 * Form delegate that corresponds to a checkbox.
 */
T.CheckDelegate {
    id: root

    /**
     * Label that appears under the text, providing the value of the label.
     */
    property string description: ""

    /**
     * This property holds the interal description item.
     */
    property alias descriptionItem: internalDescriptionItem

    signal linkActivated(link: string)

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
        Controls.CheckBox {
            id: checkBoxItem
            Layout.rightMargin: Kirigami.Units.largeSpacing
            focusPolicy: Qt.NoFocus // provided by delegate
            
            checkState: root.checkState
            nextCheckState: root.nextCheckState
            tristate: root.tristate

            onToggled: root.toggled()
            
            enabled: root.enabled
            checked: root.checked
            onCheckedChanged: {
                root.checked = checked;
                checked = Qt.binding(() => root.checked);
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing
            Controls.Label {
                text: root.text
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                maximumLineCount: 2
                Layout.fillWidth: true
            }

            Controls.Label {
                id: internalDescriptionItem
                Layout.fillWidth: true
                text: root.description
                color: Kirigami.Theme.disabledTextColor
                visible: root.description !== ""
                onLinkActivated: root.linkActivated(link)
                wrapMode: Text.Wrap
            }
        }
    }
}

