/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.12 as Kirigami

Rectangle {
    required property var control
    
    color: {
        let colorOpacity = 0;
        
        if (!control.enabled) {
            colorOpacity = 0;
        }
        if (control.pressed) {
            colorOpacity = 0.2;
        }
        if (control.visualFocus) {
            colorOpacity = 0.1
        }
        if (!Kirigami.Settings.tabletMode && control.hovered) {
            colorOpacity = 0.07;
        }
        
        return Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, colorOpacity)
    }
    
    Behavior on color {
        ColorAnimation { duration: Kirigami.Units.shortDuration }
    }
}
