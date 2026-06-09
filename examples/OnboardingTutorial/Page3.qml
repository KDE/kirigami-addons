// SPDX-FileCopyrightText: 2026 Sandro Andrade <sandroandrade@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.onboarding

Item {
    id: item

    required property var swipeView

    objectName: "Page3"

    ColumnLayout {
        anchors {
            fill: parent
            margins: Kirigami.Units.largeSpacing
        }

        QQC2.CheckBox {
            id: checkbox3

            Layout.fillWidth: true
            text: qsTr("CheckBox 3")

            Onboarding.groups: ["advanced"]
            Onboarding.texts: [qsTr("This checkbox is the final advanced onboarding item.")]
            Onboarding.onAboutToShow: item.swipeView.currentIndex = 2
        }

        QQC2.Dial {
            Layout.fillWidth: true
        }

        QQC2.ComboBox {
            Layout.fillWidth: true
            model: [qsTr("Apple"), qsTr("Banana"), qsTr("Watermelon")]
        }

        QQC2.Label {
            Layout.fillWidth: true
            text: qsTr("I'm a label")
        }
    }
}
