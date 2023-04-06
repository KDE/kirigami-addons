// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
//
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as Components
import org.kde.kirigamiaddons.delegates as Delegates

QQC2.ApplicationWindow {
    id: root

    height: 800
    width: 600

    visible: true

    Components.FloatingButton {
        icon.name: "configure"
        text: "Open Drawer"

        margins: Kirigami.Units.largeSpacing

        anchors {
            right: parent.right
            bottom: parent.bottom
        }

        onClicked: drawer.open()
    }

    Components.BottomDrawer {
        id: drawer
        width: root.width

        headerContentItem: RowLayout {
            Components.Avatar {
                name: "World"
            }

            ColumnLayout {
                Layout.leftMargin: Kirigami.Units.largeSpacing
                Layout.fillWidth: true

                Kirigami.Heading {
                    text: "John Doe"
                    Layout.fillWidth: true
                }
                QQC2.Label {
                    text: "Last connection: 20.04.2042"
                    Layout.fillWidth: true
                }
            }
        }

        QQC2.ScrollView {
            implicitHeight: Math.max(view.implicitHeight, root.height * 0.8)

            ListView {
                id: view

                model: 40

                delegate: Delegates.RoundedItemDelegate {
                    required property int index

                    text: "Item " + index
                }
            }
        }
    }
}
