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

    objectName: "Page1"

    GridLayout {
        id: gridLayout

        anchors {
            fill: parent
            margins: Kirigami.Units.largeSpacing
        }
        columns: 3

        QQC2.Button {
            id: button1

            Layout.fillWidth: true
            text: qsTr("Start onboarding")

            //! [1]
            Onboarding.texts: [qsTr("This button starts the default onboarding tutorial.")]
            Onboarding.additionalData: ({
                video: "qrc:/qt/qml/org/kde/kirigamiaddons/examples/onboardingtutorial/onboarding-video.webp",
                videoCaption: "This is a video caption",
            })
            //! [1]

            onClicked: Onboarding.start()
        }

        QQC2.CheckBox {
            id: checkbox1

            Layout.fillWidth: true
            text: qsTr("CheckBox 1")

            Onboarding.texts: [qsTr("This checkbox represents an option that can be enabled or disabled.")]
        }

        QQC2.Button {
            id: button2

            Layout.fillWidth: true
            text: qsTr("Start advanced")

            Onboarding.groups: ["advanced"]
            Onboarding.texts: [qsTr("This button starts the advanced onboarding tutorial.")]

            onClicked: Onboarding.start("advanced")
        }

        QQC2.Button {
            id: button3

            Layout.columnSpan: 2
            Layout.fillWidth: true
            highlighted: true
            text: qsTr("Button 3")

            Onboarding.groups: ["", "advanced"]
            Onboarding.texts: [
                qsTr("This highlighted button shows how longer onboarding text wraps inside the tooltip."),
                qsTr("The advanced flow can reuse the same control with different guidance."),
            ]
        }

        QQC2.ComboBox {
            id: combobox1

            Layout.fillWidth: true
            model: [qsTr("Apple"), qsTr("Banana"), qsTr("Watermelon")]

            Onboarding.texts: [qsTr("This combo box lets the user choose from a short list of values.")]
        }

        RowLayout {
            id: group1

            Layout.columnSpan: 3
            Layout.fillWidth: true

            Onboarding.texts: [qsTr("This row groups related input controls.")]

            QQC2.TextField {
                id: textfield1

                Layout.fillWidth: true
                placeholderText: qsTr("I'm a text field")

                Onboarding.texts: [qsTr("This text field accepts free-form text.")]
            }

            QQC2.SpinBox {
                id: spinbox1

                Layout.fillWidth: true

                Onboarding.texts: [qsTr("This spin box adjusts a numeric value.")]
                up.indicator.Onboarding.texts: [qsTr("This spin box button increases the value.")]
                down.indicator.Onboarding.texts: [qsTr("This spin box button decreases the value.")]
            }

            QQC2.Button {
                id: button4

                Layout.fillWidth: true
                text: qsTr("Button 4")

                Onboarding.texts: [qsTr("This button completes the grouped controls on the first page.")]
            }
        }

        QQC2.TextArea {
            id: textarea1

            Layout.fillHeight: true
            Layout.fillWidth: true

            Onboarding.texts: [qsTr("This text area accepts longer input.")]
        }

        QQC2.Dial {
            id: dial1

            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Onboarding.texts: [qsTr("This dial is an interactive value selector.")]
        }

        QQC2.Dial {
            id: dial2

            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Onboarding.groups: ["", "advanced"]
            Onboarding.texts: [
                qsTr("This second dial is the last item on the first page."),
                qsTr("The advanced flow continues on the next page after this dial."),
            ]
            Onboarding.onAboutToShow: item.swipeView.currentIndex = 0
        }
    }
}
