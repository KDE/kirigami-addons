/*
 *  SPDX-FileCopyrightText: 2020 by Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.12
import QtQuick.Layouts 1.4
import QtQuick.Window 2.2
import org.kde.kirigami 2.14 as Kirigami
import QtQuick.Controls 2.12 as QQC2

QQC2.Control {
    id: root
    property int orientation: Qt.Vertical
    property alias model: tabsRepeater.model

    leftPadding: 0
    topPadding: 1
    rightPadding: 0
    bottomPadding: 0

    background: Rectangle {
        color: Kirigami.Theme.backgroundColor
        Kirigami.Separator {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
        }
    }

    contentItem: GridLayout {
        rows: root.orientation === Qt.Horizontal ? 2 : 1
        columns: root.orientation === Qt.Horizontal ? 1 : 2

        QQC2.ScrollView {
            z: 99
            Layout.fillHeight: true
            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: Kirigami.Theme.View

            background: Rectangle {
                color: Kirigami.Theme.backgroundColor
                property int rightPadding: 1
                Kirigami.Separator {
                    anchors {
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                    }
                }
            }

            GridLayout {
                rows: root.orientation === Qt.Horizontal ? 1: Infinity
                columns: root.orientation === Qt.Horizontal ? Infinity : 1
                columnSpacing: 0
                rowSpacing: 0
                Repeater {
                    id: tabsRepeater
                    property int currentIndex: -1
                    delegate: Kirigami.AbstractListItem {
                        id: delegate
                        Layout.fillWidth: true
                        checked: index === tabsRepeater.currentIndex
                        separatorVisible: false
                        contentItem: ColumnLayout {
                            Kirigami.Icon {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Kirigami.Units.iconSizes.medium
                                source: model.icon
                                selected: delegate.checked
                            }
                            QQC2.Label {
                                Layout.fillWidth: true
                                text: model.name
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.WordWrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                                color: delegate.checked ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
                            }
                        }
                        onClicked: {
                            if (tabsRepeater.currentIndex == index) {
                                return;
                            }
                            pageStack.invertAnimations = tabsRepeater.currentIndex > index;
                            tabsRepeater.currentIndex = index;
                            pageStack.replace(model.source);
                        }
                    }
                }
            }
        }
        ColumnLayout {
            QQC2.StackView {
                id: pageStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                property bool invertAnimations
                replaceEnter: Transition {
                    ParallelAnimation {
                        //OpacityAnimator when starting from 0 is buggy (it shows one frame with opacity 1)
                        NumberAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: units.longDuration
                            easing.type: Easing.InOutQuad
                        }
                        YAnimator {
                            from: pageStack.invertAnimations ? -Kirigami.Units.gridUnit * 2: Kirigami.Units.gridUnit * 2
                            to: 0
                            duration: units.longDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
                replaceExit: Transition {
                    ParallelAnimation {
                        OpacityAnimator {
                            from: 1
                            to: 0
                            duration: units.shortDuration
                            easing.type: Easing.InOutQuad
                        }
                        YAnimator {
                            from: 0
                            to: pageStack.invertAnimations ? Kirigami.Units.gridUnit * 2 : -Kirigami.Units.gridUnit * 2
                            duration: units.shortDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
            RowLayout {
                Layout.rightMargin: Kirigami.Units.smallSpacing
                Layout.bottomMargin: Kirigami.Units.smallSpacing
                Item {
                    Layout.fillWidth: true
                }
                QQC2.Button {
                    icon.name: "dialog-ok"
                    text: "OK"
                }
                QQC2.Button {
                    icon.name: "dialog-ok-apply"
                    text: "Apply"
                }
                QQC2.Button {
                    icon.name: "dialog-cancel"
                    text: "Cancel"
                }
            }
        }
    }
}
