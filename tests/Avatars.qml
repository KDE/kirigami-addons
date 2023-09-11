/*
 *  SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami
import org.kde.kirigamiaddons.components 1.0 as KirigamiComponents

QQC2.Pane {
    width: Kirigami.Units.gridUnit * 15
    height: Kirigami.Units.gridUnit * 20

    ColumnLayout {
        anchors.fill: parent
        spacing: Kirigami.Units.largeSpacing

        KirigamiComponents.AvatarButton {
            id: avatar1

            Layout.preferredWidth: Kirigami.Units.gridUnit * 6
            Layout.preferredHeight: Kirigami.Units.gridUnit * 6
            Layout.alignment: Qt.AlignHCenter

            name: "John Due"

            QQC2.Button {
                parent: avatar1.clippedContent
                width: parent.width
                height: Math.round(parent.height * 0.333)
                anchors.bottom: parent.bottom
                anchors.bottomMargin: avatar1.hovered ? 0 : -height

                Behavior on anchors.bottomMargin {
                    NumberAnimation {
                        duration: Kirigami.Units.shortDuration
                        easing.type: Easing.InOutCubic
                    }
                }

                verticalPadding: Math.round(height * 0.1)
                topPadding: undefined
                bottomPadding: undefined

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }

                contentItem: Item {
                    Kirigami.Icon {
                        height: parent.height
                        width: height
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: "camera-photo-symbolic"
                    }
                }
                background: Rectangle {
                    color: Qt.rgba(0, 0, 0, 0.6)
                }

                onClicked: print("Select photo")
            }

            onClicked: print("Show photo fullscreen")
        }
    }
}
