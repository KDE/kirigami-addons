import QtQuick 2.3
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.3 as Controls

Controls.Label {
    id: root
    property date selectedDate
    text: selectedDate.toLocaleDateString(Qt.locale(), Locale.ShortFormat)
    MouseArea {
        anchors.fill: parent
        onClicked: popup.open();

    }
    Controls.Popup {
        id: popup
        y: root.height
        DatePicker {
            selectedDate: root.selectedDate
            onSelectedDateChanged: root.selectedDate = selectedDate
        }
    }
}
