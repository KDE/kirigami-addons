import QtQuick 2.3
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.3

import org.kde.kirigami 2.4 as Kirigami

import org.kde.kirigamiaddons.dateandtime 0.1

Loader {
    id: root
    property date selectedDate: new Date()

    //maybe we need something more like combox to handle user selected signals

    source: Kirigami.Settings.tabletMode ? "MobileDateInput.qml" : "DesktopDateInput.qml"

    onLoaded: {
        item.selectedDate = root.selectedDate
        root.selectedDate = Qt.binding(function() {return item.selectedDate});
    }
}

