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

//This class serves as an encapsulation of the QQC1 calendar so that it can be replaced at any time
import QtQml 2.14
import QtQuick 2.4
import QtQuick.Controls 1.2

/**
 * A large date picker
 *
 * Use case is for picking a date and visualising that in
 * context of a calendar view
 */
FocusScope {
    property alias selectedDate: calendar.selectedDate

    implicitWidth: calendar.implicitWidth
    implicitHeight: calendar.implicitHeight

    Calendar {
        id: calendar
        frameVisible: false
        weekNumbersVisible: false
        selectedDate: new Date()

        focus: true
        //style stuff here?
    }
}

