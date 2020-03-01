/*
 *   Copyright 2019 David Edmundson <davidedmundson@kde.org>
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

import org.kde.kirigami 2.0 as Kirigami
import QtQuick 2.12
import QtQuick.Controls 2.5 as Controls2

Controls2.Label {
    text: "14th March 2019"
    MouseArea {
        anchors.fill: parent
        onClicked: popup.open()
    }
    Controls2.Popup {
        id: popup
        TimePicker {
            implicitWidth: 400
            implicitHeight: 400
        }
    }
}
