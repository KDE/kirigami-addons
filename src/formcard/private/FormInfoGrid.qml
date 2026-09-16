/*
 * Copyright 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQml
import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

Item {
    id: root

    required property real maximumWidth
    required property real leftPadding
    required property real rightPadding
    required property real topPadding
    required property real bottomPadding
    required property bool cardWidthRestricted
    required property list<QtObject> infoCards

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    implicitHeight: topPadding + bottomPadding + grid.implicitHeight

    GridLayout {
        id: grid

        readonly property int cellWidth: Kirigami.Units.gridUnit * 10
        readonly property int visibleChildrenCount: visibleChildren.length - 1

        anchors {
            fill: parent
            leftMargin: root.leftPadding
            rightMargin: root.rightPadding
            topMargin: root.topPadding
            bottomMargin: root.bottomPadding
        }

        columns: 2
        columnSpacing: Kirigami.Units.smallSpacing
        rowSpacing: Kirigami.Units.smallSpacing

        Repeater {
            model: root.infoCards

            QQC2.AbstractButton {
                id: infoCardDelegate

                required property int index
                required property QtObject modelData

                readonly property string title: modelData.title
                readonly property string subtitle: modelData.subtitle
                readonly property string buttonIcon: modelData.buttonIcon
                readonly property string tooltipText: modelData.tooltipText
                readonly property int subtitleTextFormat: modelData.subtitleTextFormat

                visible: modelData.visible
                action: modelData.action

                leftPadding: Kirigami.Units.largeSpacing
                rightPadding: Kirigami.Units.largeSpacing
                topPadding: Kirigami.Units.largeSpacing
                bottomPadding: Kirigami.Units.largeSpacing

                leftInset: root.cardWidthRestricted ? 0 : -infoCardDelegate.background.border.width
                rightInset: root.cardWidthRestricted ? 0 : -infoCardDelegate.background.border.width

                hoverEnabled: true

                Accessible.name: title + " " + subtitle
                Accessible.role: action ? Accessible.Button : Accessible.Note

                Layout.preferredWidth: grid.cellWidth
                Layout.columnSpan: grid.visibleChildrenCount % grid.columns !== 0 && index === grid.visibleChildrenCount - 1 ? 2 : 1
                Layout.fillWidth: true
                Layout.fillHeight: true

                QQC2.ToolTip.text: tooltipText
                QQC2.ToolTip.visible: tooltipText && hovered
                QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay

                background: FormCardBackground {
                    rounded: root.cardWidthRestricted

                    Rectangle {
                        anchors.fill: parent
                        radius: root.cardWidthRestricted ? Kirigami.Units.cornerRadius : 0

                        color: {
                            let alpha = 0;

                            if (!infoCardDelegate.enabled || !infoCardDelegate.action) {
                                alpha = 0;
                            } else if (infoCardDelegate.pressed) {
                                alpha = 0.2;
                            } else if (infoCardDelegate.visualFocus) {
                                alpha = 0.1;
                            } else if (!Kirigami.Settings.tabletMode && infoCardDelegate.hovered) {
                                alpha = 0.07;
                            }

                            return Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, alpha)
                        }

                        Behavior on color {
                            ColorAnimation { duration: Kirigami.Units.shortDuration }
                        }
                    }
                }

                contentItem: RowLayout {
                    spacing: Kirigami.Units.smallSpacing

                    Kirigami.Icon {
                        id: icon

                        source: infoCardDelegate.buttonIcon
                        visible: source
                        Layout.alignment: Qt.AlignTop
                    }

                    ColumnLayout {
                        spacing: 0

                        Kirigami.Heading {
                            Layout.fillWidth: true
                            level: 4
                            text: infoCardDelegate.title
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: icon.visible ? Text.AlignLeft : Text.AlignHCenter
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            wrapMode: Text.Wrap
                        }

                        QQC2.Label {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: infoCardDelegate.subtitle
                            text: infoCardDelegate.subtitle
                            horizontalAlignment: icon.visible ? Text.AlignLeft : Text.AlignHCenter
                            elide: Text.ElideRight
                            wrapMode: Text.Wrap
                            textFormat: infoCardDelegate.subtitleTextFormat
                            opacity: 0.6
                            verticalAlignment: Text.AlignTop
                            onLinkActivated: (link) => modelData.linkActivated(link)
                        }
                    }
                }
            }
        }
    }
}
