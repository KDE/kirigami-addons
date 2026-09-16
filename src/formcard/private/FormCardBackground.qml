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
    readonly property color _backgroundColor: Kirigami.Theme.backgroundColor
    readonly property color _textColor: Kirigami.Theme.textColor
    readonly property color _darkerBackground: Qt.darker(_backgroundColor, 1)
    readonly property real _backgroundDarkness: 1 - (0.299 * _darkerBackground.r + 0.587 * _darkerBackground.g + 0.114 * _darkerBackground.b)
    readonly property bool isDarkColor: _darkerBackground.a > 0 && _backgroundDarkness >= 0.4
    readonly property color _borderColor: isDarkColor
        ? Qt.darker(_backgroundColor, 1.2)
        : Kirigami.ColorUtils.linearInterpolation(_backgroundColor, _textColor, 0.15)
    readonly property color _shadowColor: Qt.alpha(_textColor, 0.10)
    readonly property real _shadowSize: isDarkColor ? Kirigami.Units.smallSpacing : Kirigami.Units.largeSpacing
    readonly property real _radius: rounded ? Kirigami.Units.cornerRadius : 0

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    radius: _radius
    color: _backgroundColor

    border {
        color: root._borderColor
        width: root.borderWidth
    }

    shadow {
        size: root._shadowSize
        color: root._shadowColor
    }
}
