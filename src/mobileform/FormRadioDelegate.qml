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
            Controls.ButtonGroup.group: root.Controls.ButtonGroup.group
            
            onCheckedChanged: {
                root.checked = checked;
                checked = Qt.binding(() => root.checked);
            }
        }
        
        Controls.Label {
            text: root.text
            color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            maximumLineCount: 2
            Layout.fillWidth: true
        }
    }
}


