/*
 *   Copyright 2019 Dimitris Kardarakos <dimkard@posteo.net>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.12
import QtQuick.Controls 2.5 as Controls2
import org.kde.kirigami 2.0 as Kirigami
import QtQuick.Layouts 1.11

        
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
        color: parent.checked ? Kirigami.Theme.buttonBackgroundColor : "transparent"
    }                 
}
    
