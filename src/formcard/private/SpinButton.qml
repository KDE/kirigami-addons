// Copyright 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami

QQC2.Button {
    id: root

    required property bool isEnd
    required property bool isStart

    readonly property color borderColor: if (enabled && (visualFocus || hovered || down)) {
        return Kirigami.Theme.focusColor
    } else {
        return Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, Kirigami.Theme.frameContrast)
    }

    visible: Kirigami.Settings.isMobile

    contentItem: Item {
        Kirigami.Icon {
            source: root.icon.name
            anchors.centerIn: parent
            implicitHeight: Kirigami.Units.iconSizes.small
            implicitWidth: Kirigami.Units.iconSizes.small
        }
    }

    background: Kirigami.ShadowedRectangle {
        implicitWidth: implicitHeight
        implicitHeight: Kirigami.Units.gridUnit * 2

        Kirigami.Theme.colorSet: Kirigami.Theme.Button
        color: root.down ? Kirigami.Theme.alternateBackgroundColor: Kirigami.Theme.backgroundColor

        corners {
            topLeftRadius: (!root.mirrored && root.isStart) || (root.mirrored && root.isEnd) ? 4 : 0
            bottomLeftRadius: (!root.mirrored && root.isStart) || (root.mirrored && root.isEnd) ? 4 : 0
            topRightRadius: (!root.mirrored && root.isEnd) || (root.mirrored && root.isStart) ? 4 : 0
            bottomRightRadius: (!root.mirrored && root.isEnd) || (root.mirrored && root.isStart) ? 4 : 0
        }

        border {
            width: 1
            color: root.borderColor
        }
    }
}
