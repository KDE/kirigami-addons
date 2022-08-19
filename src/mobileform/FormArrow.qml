/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

/**
 * Arrow UI component used in form delegates.
 */

Kirigami.Icon {
    enum Direction {
        Up,
        Down,
        Left,
        Right
    }
    
    property int direction: Right
    
    source: {
        if (direction === FormArrow.Up) {
            return "arrow-up";
        } else if (direction === FormArrow.Down) {
            return "arrow-down";
        } else if (direction === FormArrow.Left) {
            return "arrow-left";
        } else {
            return "arrow-right";
        }
    }
    implicitWidth: Math.round(Kirigami.Units.iconSizes.small * 0.75)
    implicitHeight: Math.round(Kirigami.Units.iconSizes.small * 0.75)
}
