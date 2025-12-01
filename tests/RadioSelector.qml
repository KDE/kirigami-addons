// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Mathis <mbb@kaidan.im>

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.Component_Test

Kirigami.ApplicationWindow {
    id: root

    title: i18n("RadioSelector Test")

    minimumWidth: Kirigami.Units.gridUnit * 20
    minimumHeight: Kirigami.Units.gridUnit * 20

    pageStack.initialPage: page

    Kirigami.Page {
        id: page
        globalToolBarStyle: Kirigami.ApplicationHeaderStyle.None

        titleDelegate:ColumnLayout{
            Kirigami.AbstractApplicationHeader {
                Layout.margins: 0
                Layout.preferredHeight: pageStack.globalToolBar.preferredHeight
                Layout.maximumHeight: pageStack.globalToolBar.preferredHeight
                Layout.fillWidth: true
                id: applicationHeader
                width: root.width
                RowLayout{
                    anchors.fill: parent
                    Kirigami.Heading{
                        Layout.leftMargin: Kirigami.Units.largeSpacing

                        text: "RadioSelector Test"
                        Layout.fillWidth: true
                    }

                    RadioSelector {
                        Layout.maximumHeight: Math.round(Kirigami.Units.gridUnit * 1.5)

                        id: selector
                        consistentWidth: false
                        actions: [
                            Kirigami.Action {
                                text: i18n("Week")
                                icon.name:  "view-calendar-week"
                            },
                            Kirigami.Action {
                                text: i18n("3 Days")
                                icon.name:  "view-calendar-upcoming-days"
                            },
                            Kirigami.Action {
                                text: i18n("1 Day")
                                icon.name:  "view-calendar-day"
                            }
                        ]
                        Layout.rightMargin: Kirigami.Units.largeSpacing
                    }
                }
            }
        }

        Layout.fillWidth: true

        ColumnLayout {
            width: page.width
            anchors.centerIn: parent

            QQC2.Label {
                id: heading
                Layout.alignment: Qt.AlignCenter
                text: "Search in:"
            }
            RadioSelector {
                consistentWidth: false
                actions: [
                    Kirigami.Action {
                        text: i18n("Songs")
                        icon.name: "filename-track-amarok"
                    },
                    Kirigami.Action {
                        text: i18n("Album")
                        icon.name: "filename-album-amarok"
                    },
                    Kirigami.Action {
                        text: i18n("Artist")
                        icon.name: "amarok_artist"
                    }
                ]
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
