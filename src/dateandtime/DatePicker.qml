//This class serves as an encapsulation of the QQC1 calendar so that it can be replaced at any time
import QtQml 2.14
import QtQuick 2.4
import QtQuick.Controls 1.2

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

