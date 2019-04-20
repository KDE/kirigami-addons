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

ColumnLayout {
    
    id: root
    
    property int hours
    property int minutes
    property bool pm
    
        
    Item {
        id: clock
        width: Kirigami.Units.gridUnit * 18
        height: width
        
        //Hours clock
        PathView {
            id: hoursClock
            
            delegate: ClockElement {
                type: "hours"
                selectedValue: root.hours
                onClicked: root.hours = index 
            }
            model: 12
            path: Path {
                PathAngleArc {
                    centerX: Kirigami.Units.gridUnit * 9
                    centerY: centerX
                    radiusX: Kirigami.Units.gridUnit * 4
                    radiusY: radiusX
                    startAngle: -90
                    sweepAngle: 360
                }   
            }
        }
                
        //Minutes clock
        PathView {
            id: minutesClock
            
            model: 60
            
            delegate: ClockElement {
                type: "minutes"
                selectedValue: root.minutes
                onClicked: root.minutes = index 
            }
            
            path: Path {
                PathAngleArc {
                    centerX: Kirigami.Units.gridUnit * 9
                    centerY: centerX
                    radiusX: Kirigami.Units.gridUnit * 7
                    radiusY: radiusX
                    startAngle: -90
                    sweepAngle: 360
                }           
            }
        }
    }

    RowLayout {
        Layout.alignment: Qt.AlignHCenter

        Controls2.Label {
            text: ((root.hours < 10) ? "0" : "" ) + root.hours + ":" + ( (root.minutes < 10) ? "0" : "") + root.minutes
            font.pointSize: Kirigami.Units.fontMetrics.font.pointSize * 1.5
        }
        
        Controls2.ToolButton {
            id: pm

            checked: root.pm
            checkable: true
            text: checked ? "PM" : "AM"
            font.pointSize: Kirigami.Units.fontMetrics.font.pointSize * 1.5

            onClicked: root.pm = checked
        }
    }
    
}
