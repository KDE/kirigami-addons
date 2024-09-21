/*
 *   SPDX-FileCopyrightText: 2019 Dimitris Kardarakos <dimkard@posteo.net>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as Controls2
import org.kde.kirigami as Kirigami
import QtQuick.Layouts

Controls2.ToolButton {
    id: hoursButton

    property int selectedValue
    property string type

    checkable: true
    checked: index == selectedValue
    autoExclusive: true
    text: index == selectedValue ? ( (type == "hours" && index == 0) ? 12 : index )
                                 : ( (type == "hours") ? ( index == 0 ? 12 : ( (index % 3 == 0) ? index : ".") ) : (index % 15 == 0) ? index : ".")
    contentItem: Controls2.Label {
        text: hoursButton.text
        color: index <= parent.selectedValue ? Kirigami.Theme.activeTextColor : Kirigami.Theme.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        implicitHeight: Kirigami.Units.gridUnit
        implicitWidth: height
        radius: width*0.5
        color: parent.checked ? Kirigami.Theme.activeBackgroundColor : "transparent"
    }
}

