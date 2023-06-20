/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

/**
 * @brief An arrow UI component used in Form delegates.
 *
 * This component can be used to decorate existing or custom Form delegates.
 * It is used, for instance, as the trailing property of FormButtonDelegate.
 *
 * Each FormArrow instance corresponds to a single arrow that may point
 * upwards, downwards, to the left or to the right.
 *
 * @since org.kde.kirigamiaddons.labs.mobileform 0.1
 *
 * @inherit Kirigami.Icon
 */

Kirigami.Icon {
    /**
     * @brief The ::direction of the FormArrow.
     */
    enum Direction {
        /** The arrow icon will point upwards. */
        Up,
        /** The arrow icon will point downwards. */
        Down,
        /** The arrow icon will point to the left. */
        Left,
        /** The arrow icon will point to the right. */
        Right
    }
    
    /**
     * @brief The direction the FormArrow will point towards.
     *
     * Set this to any ::Direction enum value.
     *
     * default: `FormArrow.Right`
     */
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
