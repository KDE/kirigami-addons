/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.12 as Kirigami

Rectangle {
    required property var control
    
    color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, !control.enabled ? 0 : control.pressed ? 0.2 : control.hovered ? 0.07 : 0)
    
    Behavior on color {
        ColorAnimation { duration: Kirigami.Units.shortDuration }
    }
}
