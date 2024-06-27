/*
 * Copyright 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

import org.kde.kirigamiaddons.tableview as Tables

QQC2.Control {
    id: delegate

    Accessible.role: Accessible.ColumnHeader
    padding: Kirigami.Units.smallSpacing

    z: Drag.active ? 2 : 0
    Drag.active: dragHandler.active && delegate.headerComponent.draggable
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2

    required property int index
    required property var headerComponent

    property bool sortEnabled
    property int sortOrder

    signal clicked()
    signal doubleClicked()

    background: Rectangle {
        readonly property bool containsDrag: delegate.enabled &&
                                             delegate.headerComponent.draggable &&
                                             dropArea.containsDrag &&
                                             dropArea.drag.source.index !== delegate.index

        border.color: containsDrag ? Kirigami.Theme.highlightColor : "Transparent"
        color: {
            if (!delegate.enabled) {
                return "Transparent"
            }

            if (delegate.hovered && !Kirigami.Settings.isMobile) {
                return Qt.alpha(Kirigami.Theme.hoverColor, 0.3)
            }

            return Kirigami.Theme.backgroundColor
        }

        Kirigami.Separator {
            height: parent.height
            anchors.right: parent.right
            visible: !parent.containsDrag && !delegate.Drag.active
        }

        Kirigami.Separator {
            width: parent.width
            anchors.bottom: parent.bottom
            visible: !parent.containsDrag && !delegate.Drag.active
        }
    }

    contentItem: DropArea {
        id: dropArea

        TapHandler {
            onTapped: delegate.clicked()
            onDoubleTapped: delegate.doubleClicked()
        }

        DragHandler {
            id: dragHandler
            target: delegate
            enabled: delegate.headerComponent.draggable
            yAxis.enabled: false
            cursorShape: Qt.DragMoveCursor

            // For restore initial position after drop
            property real startX: -1

            onActiveChanged: {
                if (!active) {
                    delegate.Drag.drop();
                    delegate.x = startX;
                    startX = -1;
                } else {
                    startX = target.x;
                }
            }
        }

        RowLayout {
            anchors.fill: parent
            spacing: delegate.spacing

            Loader {
                id: leadingLoader
                Layout.alignment: Qt.AlignVCenter
                visible: delegate.headerComponent.leading
                sourceComponent: delegate.headerComponent.leading
            }

            Loader {
                id: contentLoader
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                sourceComponent: delegate.headerComponent.headerDelegate
                readonly property string modelData: delegate.headerComponent.title
                readonly property int index: delegate.index
            }

            Loader {
                id: sortIndicatorLoader
                Layout.alignment: Qt.AlignVCenter
                visible: delegate.sortEnabled
                sourceComponent: delegate.sortEnabled ? delegate.sortIndicator : null
            }
        }

        onDropped: function(drop) {
            const currentItemIndex = delegate.index
            const dropItemIndex = drop.source.index

            if (!delegate.headerComponent.draggable)
                return

            if (currentItemIndex === -1 || dropItemIndex === -1)
                return

            if (currentItemIndex === dropItemIndex)
                return

            __columnModel.move(dropItemIndex, currentItemIndex, 1)
        }
    }

    property Component sortIndicator: Kirigami.Icon {
        id: sortIndicator

        source: "arrow-up-symbolic"

        implicitWidth: Kirigami.Units.iconSizes.small
        implicitHeight: Kirigami.Units.iconSizes.small

        states: State {
            when: delegate.sortEnabled && delegate.sortOrder === Qt.DescendingOrder
            PropertyChanges { target: sortIndicator; rotation: 180 }
        }

        transitions: Transition {
            RotationAnimation {
                duration: Kirigami.Units.longDuration
                direction: RotationAnimation.Counterclockwise
            }
        }
    }
}
