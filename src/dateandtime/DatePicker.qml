/*
 *   SPDX-FileCopyrightText: 2019 David Edmundson <davidedmundson@kde.org>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
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

