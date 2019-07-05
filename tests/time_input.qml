import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1 as QQC2
import org.kde.kirigami 2.5 as Kirigami
import org.kde.kirigamiaddons.dateandtime 0.1 as Addon

Rectangle {
    ColumnLayout {
        Addon.TimeInput {
            id: timeInput
            hours: 5
            minutes: 5
        }
        Text {
            text: timeInput.text + timeInput.acceptableInput
        }
    }
}
