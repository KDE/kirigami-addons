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
