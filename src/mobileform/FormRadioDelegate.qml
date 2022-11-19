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
 * Form delegate that corresponds to a radio button.
 */
T.RadioDelegate {
    id: root

    /**
     * Label that appears under the main text, that provides additional information about the delegate.
     */
    property string description: ""
    
    leftPadding: Kirigami.Units.gridUnit
    topPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    bottomPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    rightPadding: Kirigami.Units.gridUnit
    
    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
    
    hoverEnabled: true
    background: FormDelegateBackground { control: root }
    
    Layout.fillWidth: true
    
    contentItem: RowLayout {
        Controls.RadioButton {
            id: radioButtonItem
            Layout.rightMargin: Kirigami.Units.largeSpacing
            
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
                Layout.fillWidth: true
                text: root.text
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                maximumLineCount: 2
            }

            Controls.Label {
                visible: root.description !== ""
                Layout.fillWidth: true
                text: root.description
                color: Kirigami.Theme.disabledTextColor
                wrapMode: Text.Wrap
            }
        }
    }
}


