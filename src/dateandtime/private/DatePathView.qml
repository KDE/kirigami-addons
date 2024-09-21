// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

PathView {
    id: root

    required property QQC2.SwipeView mainView
    property int startIndex: 0

    implicitHeight: Kirigami.Units.gridUnit * 16
    flickDeceleration: 200
    highlightRangeMode: PathView.StrictlyEnforceRange
    preferredHighlightBegin: 0.5
    preferredHighlightEnd: 0.5
    snapMode: PathView.SnapToItem
    focus: true

    clip: true

    path: Path {
        startX: root.width / 2
        startY: -root.height * root.count / 2 + root.height / 2
        PathLine {
            x: root.width / 2
            y: root.height * root.count / 2 + root.height / 2
        }
    }

    // Center index
    Component.onCompleted: {
        startIndex = count / 2;
        currentIndex = startIndex;
    }
}
