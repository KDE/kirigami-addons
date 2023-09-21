/*
 *  SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.20 as Kirigami
import org.kde.kirigamiaddons.components 1.0 as KirigamiComponents

Kirigami.ScrollablePage {
    id: root

    width: cellSize * columns
    height: cellSize * 4
    padding: 0

    property real cellSize: Kirigami.Units.gridUnit * 12
    property int columns: 4

    component Cell : Item {
        implicitWidth: root.cellSize
        implicitHeight: root.cellSize
        Rectangle {
            anchors.fill: parent
            z: -1
            color: "transparent"
            border.color: Kirigami.Theme.textColor
            border.width: 1
            opacity: 0.3
        }
    }

    component CenterSet : Cell {
        id: cell

        // These are the default values of FloatingButton
        property real radius: Kirigami.Units.largeSpacing
        property real margins: 0

        property alias title: label.text

        QQC2.Label {
            id: label
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            z: 1
        }
        KirigamiComponents.FloatingButton {
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            icon.name: "arrow-up-symbolic"
            radius: cell.radius
            margins: cell.margins
        }
        KirigamiComponents.FloatingButton {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            icon.name: "arrow-left-symbolic"
            radius: cell.radius
            margins: cell.margins
        }
        KirigamiComponents.FloatingButton {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            icon.name: "arrow-right-symbolic"
            radius: cell.radius
            margins: cell.margins
        }
        KirigamiComponents.FloatingButton {
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
            icon.name: "arrow-down-symbolic"
            radius: cell.radius
            margins: cell.margins
        }
    }

    component CornerSet : Cell {
        id: cell

        // These are the default values of FloatingButton
        property real radius: Kirigami.Units.largeSpacing
        property real margins: 0
        property real iconSize: 0
        property int focusPolicy: Qt.StrongFocus

        property alias title: label.text

        QQC2.Label {
            id: label
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            z: 1
        }
        KirigamiComponents.FloatingButton {
            anchors {
                top: parent.top
                left: parent.left
            }
            icon.name: "go-top-symbolic"
            icon.width: cell.iconSize
            icon.height: cell.iconSize
            radius: cell.radius
            margins: cell.margins
            focusPolicy: cell.focusPolicy
        }
        KirigamiComponents.FloatingButton {
            anchors {
                left: parent.left
                bottom: parent.bottom
            }
            icon.name: "go-bottom-symbolic"
            icon.width: cell.iconSize
            icon.height: cell.iconSize
            radius: cell.radius
            margins: cell.margins
            focusPolicy: cell.focusPolicy
        }
        KirigamiComponents.FloatingButton {
            anchors {
                right: parent.right
                top: parent.top
            }
            icon.name: "search-symbolic"
            icon.width: cell.iconSize
            icon.height: cell.iconSize
            radius: cell.radius
            margins: cell.margins
            focusPolicy: cell.focusPolicy
        }
        KirigamiComponents.FloatingButton {
            anchors {
                right: parent.right
                bottom: parent.bottom
            }
            icon.name: "list-add-symbolic"
            icon.width: cell.iconSize
            icon.height: cell.iconSize
            radius: cell.radius
            margins: cell.margins
            focusPolicy: cell.focusPolicy
        }
    }

    GridLayout {
        columns: root.columns
        rowSpacing: 0
        columnSpacing: 0

        CenterSet {
            title: "Default"
        }
        CenterSet {
            title: "Round"
            radius: Infinity
        }
        CenterSet {
            title: "Default\nDisabled"
            enabled: false
        }
        CenterSet {
            title: "Round\nDisabled"
            radius: Infinity
            enabled: false
        }

        CornerSet {
            title: "Default"
        }
        CornerSet {
            title: "Round"
            radius: Infinity
        }
        CornerSet {
            title: "Default\nDisabled"
            enabled: false
        }
        CornerSet {
            title: "Round\nDisabled"
            radius: Infinity
            enabled: false
        }

        CornerSet {
            title: "Default\nMargins"
            margins: Kirigami.Units.gridUnit
        }
        CornerSet {
            title: "Round\nMargins"
            margins: Kirigami.Units.gridUnit
            radius: Infinity
        }
        CornerSet {
            title: "Default\nBig"
            iconSize: Kirigami.Units.iconSizes.large
        }
        CornerSet {
            title: "Round\nBig"
            iconSize: Kirigami.Units.iconSizes.large
            radius: Infinity
        }

        CornerSet {
            title: "Default\nNo Focus"
            focusPolicy: Qt.NoFocus
        }
        CornerSet {
            title: "Round\nNo Focus"
            radius: Infinity
            focusPolicy: Qt.NoFocus
        }
        CornerSet {
            title: "Default\nMargins\nNo Focus"
            margins: Kirigami.Units.gridUnit
            focusPolicy: Qt.NoFocus
        }
        CornerSet {
            title: "Default\nMargins\nNo Focus"
            radius: Infinity
            margins: Kirigami.Units.gridUnit
            focusPolicy: Qt.NoFocus
        }
    }
}
