import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2

import org.kde.kirigami 2.20 as Kirigami
import org.kde.kirigamiaddons.labs.toolbar 0.1

Kirigami.ApplicationWindow {
    ToolBar {
        actions: [
            Kirigami.Action {
                objectName: "neoChat"
                text: "Open NeoChat"
                icon.name: "org.kde.neochat"
                onTriggered: console.warn("neeeeochat")
            },
            Kirigami.Action {
                objectName: "kasts"
                text: "Open Kasts"
                icon.name: "kasts"
                onTriggered: console.warn("kasts")
            },
            Kirigami.Action {
                objectName: "kate"
                text: "Open Kate"
                icon.name: "kate"
                onTriggered: console.warn("kate")
            },
            Kirigami.Action {
                objectName: "alligator"
                text: "Open Alligator"
                icon.name: "alligator"
                onTriggered: console.warn("alligator")
            }
        ]
        defaultLayout: [ "neoChat", "kasts", "alligator", "kate", "alligator" ]
        width: parent.width
    }
}
