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

    objectName: "Page2"

    ColumnLayout {
        anchors {
            fill: parent
            margins: Kirigami.Units.largeSpacing
        }

        QQC2.CheckBox {
            id: checkbox2

            Layout.fillWidth: true
            text: qsTr("CheckBox 2")

            //! [2]
            Onboarding.groups: ["advanced"]
            Onboarding.texts: [qsTr("This checkbox is on the second page of the advanced flow.")]
            Onboarding.onAboutToShow: item.swipeView.currentIndex = 1
            //! [2]
        }

        QQC2.Button {
            Layout.fillWidth: true
            text: qsTr("Button 2")
        }

        QQC2.Button {
            Layout.fillWidth: true
            highlighted: true
            text: qsTr("Button 3")
        }

        QQC2.ComboBox {
            Layout.fillWidth: true
            model: [qsTr("Apple"), qsTr("Banana"), qsTr("Watermelon")]
        }
    }
}
