/*
    SPDX-FileCopyrightText: 2023 Louis Schul <schul9louis@gmail.com>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1 as QQC2
import org.kde.kirigami 2.5 as Kirigami
import org.kde.kirigamiaddons.formcard 1.0 as FormCard

Kirigami.ApplicationWindow {
    title: "TextFieldDelegate Test"
    pageStack.initialPage: textFieldPage

    Component {
        id: textFieldPage
        Kirigami.Page {
            Kirigami.FormLayout {
                anchors.fill: parent

                FormCard.FormTextFieldDelegate {
                    label: "No limits!"
                    text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse non diam eros. Aliquam nisi justo, pretium id rhoncus sit amet, fringilla non ipsum."
                }
                FormCard.FormTextFieldDelegate {
                    id: overloadField
                    label: "Sorry, you must be under 20"
                    text: "Perfect, I am 18 !"
                    maximumLength: 20
                }
                FormCard.FormTextFieldDelegate {
                    label: "No more than 10!"
                    text: "The limit!"
                    maximumLength: 10
                }
                FormCard.FormTextFieldDelegate {
                    label: fieldActiveFocus ? "I am active!" : "I am inactive"
                    text: "Focus me"
                }
                QQC2.Button {
                    Layout.fillWidth: true
                    text: "Force long text in second field"
                    onClicked: overloadField.text = "Some very long text that's way longer than 20"
                }
            }
        }
    }
}
