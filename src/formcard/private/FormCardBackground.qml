/*
 * Copyright 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick

import org.kde.kirigami as Kirigami

Kirigami.ShadowedRectangle {
    id: root

    property bool rounded: false

    readonly property real borderWidth: 1
    readonly property bool isDarkColor: {
        const temp = Qt.darker(Kirigami.Theme.backgroundColor, 1);
        return temp.a > 0 && getDarkness(Kirigami.Theme.backgroundColor) >= 0.4;
    }

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    radius: rounded ? Kirigami.Units.cornerRadius : 0
    color: Kirigami.Theme.backgroundColor

    function getDarkness(background: color): real {
        const temp = Qt.darker(background, 1);
        return 1 - (0.299 * temp.r + 0.587 * temp.g + 0.114 * temp.b);
    }

    border {
        color: root.isDarkColor
            ? Qt.darker(Kirigami.Theme.backgroundColor, 1.2)
            : Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.15)
        width: root.borderWidth
    }

    shadow {
        size: root.isDarkColor ? Kirigami.Units.smallSpacing : Kirigami.Units.largeSpacing
        color: Qt.alpha(Kirigami.Theme.textColor, 0.10)
    }
}
