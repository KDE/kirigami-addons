import QtQuick 2.12
import QtQuick.Controls 2.5
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Layouts 1.11

/**
 * A large time picker
 * Represented as a clock provides a very visual way for a user
 * to set and visulise a time being chosen
 */

Item {
    property bool is12hour: true
    property int hours
    property int minutes
    property bool pm

    id: root
    implicitHeight: Kirigami.Units.gridUnit * 5
    implicitWidth: is12hour ? Kirigami.Units.gridUnit * 10 : Kirigami.Units.gridUnit * 5.5
    FontMetrics {
        id: fontMetrics
    }
    Component {
        id: hourDelegate
        Label {
            text: modelData + 1
            opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: fontMetrics.font.pixelSize * 1.25
        }
    }
    Component {
        id: minuteDelegate
        Label {
            text: modelData < 10 ? '0' + modelData : modelData
            opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: fontMetrics.font.pixelSize * 1.25
        }
    }
    RowLayout {
        id: row
        anchors.fill: parent
        Frame {
            background: Rectangle {
                color: "transparent"
                border.color: Kirigami.Theme.highlightColor
                radius: 10
            }
            RowLayout {
                Tumbler {
                    id: hoursTumbler
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 2
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 2.5
                    model: is12hour ? 12 : 24
                    delegate: hourDelegate
                    visibleItemCount: 3
                    onCurrentIndexChanged: hours = currentIndex + 1
                }
                Label {
                    Layout.alignment: Qt.AlignCenter
                    text: ":"
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.3
                }

                Tumbler {
                    id: minutesTumbler
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 2
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 2.5
                    model: 60
                    delegate: minuteDelegate
                    visibleItemCount: 3
                    currentIndex: minutes
                }
            }
        }
        Switch {
            visible: is12hour
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            text: Qt.locale().pmText
            height: parent.height
            onCheckedChanged: {
                if (checked) {
                    text = Qt.locale().amText
                    pm = false
                }
                else {
                    text = Qt.locale().pmText
                    pm = true
                }
            }
        }
    }
    Component.onCompleted: { 
        hoursTumbler.currentIndex = hours;
        minutesTumbler.currentIndex = minutes;
    }
}
