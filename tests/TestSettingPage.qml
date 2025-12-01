// Copyright 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.delegates as Delegates
import org.kde.kirigamiaddons.components as KirigamiComponents

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
