// Copyright 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami
import org.kde.kirigamiaddons.delegates 1.0 as Delegates
import org.kde.kirigamiaddons.components 1.0 as KirigamiComponents

Kirigami.Page {

    Kirigami.PlaceholderMessage {
        text: "This setting is intentionally left blank"
        anchors.centerIn: parent

        KirigamiComponents.AvatarButton {
            name: "Paul"
            Layout.preferredWidth: Kirigami.Units.gridUnit * 2
            Layout.preferredHeight: Kirigami.Units.gridUnit * 2

            onClicked: console.log("Hello")
        }
    }
}
