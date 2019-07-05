import QtQuick.Controls 2.5
import org.kde.kirigamiaddons.dateandtime 0.1

TextField
{
    property int hour
    property int minutes

    validator: TimeInputValidator {

    }
    inputMethodHints: Qt.ImhTime
}
