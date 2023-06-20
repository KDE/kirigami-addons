/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.20 as Kirigami

/**
 * @brief A background for Form delegates.
 *
 * This is a simple background that provides opacity feedback to the user
 * when the control has focus or is currently being pressed, for example.
 *
 * This is used in AbstractFormDelegate so that new delegates provide this
 * feedback by default, and can be easily overriden with a QtQuick.Item.
 *
 * @since org.kde.kirigamiaddons.labs.mobileform 0.1
 *
 * @see AbstractFormDelegate
 *
 * @inherit QtQuick.Rectangle
 */
Rectangle {
    /**
     * @brief The control to which the background will be assigned.
     */
    required property T.Control control

    color: {
        let colorOpacity = 0;

        if (!control.enabled) {
            colorOpacity = 0;
        } else if (control.pressed) {
            colorOpacity = 0.2;
        } else if (control.visualFocus) {
            colorOpacity = 0.1;
        } else if (!Kirigami.Settings.tabletMode && control.hovered) {
            colorOpacity = 0.07;
        }

        return Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, colorOpacity)
    }

    Behavior on color {
        ColorAnimation { duration: Kirigami.Units.shortDuration }
    }
}
