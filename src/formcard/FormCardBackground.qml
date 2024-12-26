// SPDX-FileCopyrightText: 2024 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

/**
 * FormCard background rectangle.
 *
 * This component is used to create custom cards which use the same shadows and
 * borders as the FormCards components.
 *
 * ## Interactible button:
 *
 * @code{qml}
 * AbstractButton {
 *     id: button
 *     background: FormCardRectangle {
 *         hovered: button.hovered
 *     }
 *     contentItem: ColumnLayout { ... }
 * }
 * @endcode{}
 *
 * ## Non-interactible control (e.g. information card):
 *
 * @code{qml}
 * Control {
 *     id: button
 *     background: FormCardRectangle {}
 *     contentItem: ColumnLayout { ... }
 * }
 * @endcode{}
 *
 * @since 1.7.0
 */
Kirigami.ShadowedRectangle {
    id: root

    /**
     * This property holds whether the card is hovered.
     */
    property bool hovered: false

    /**
     * This property holds the border size.
     */
    readonly property real borderWidth: 1

    /**
     * @internal
     */
    readonly property bool _isDarkColor: {
        const temp = Qt.darker(Kirigami.Theme.backgroundColor, 1);
        return temp.a > 0 && getDarkness(Kirigami.Theme.backgroundColor) >= 0.4;
    }

    function getDarkness(background: color): real {
        const temp = Qt.darker(background, 1);
        const a = 1 - ( 0.299 * temp.r + 0.587 * temp.g + 0.114 * temp.b);
        return a;
    }

    radius: Kirigami.Units.cornerRadius
    color: Kirigami.Theme.backgroundColor

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    border {
        color: if (root.hovered) {
            return Kirigami.Theme.highlightColor;
        } else if (_isDarkColor) {
            return Qt.darker(Kirigami.Theme.backgroundColor, 1.2);
        } else {
            return Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.15);
        }
        width: borderWidth
    }

    shadow {
        size: Kirigami.Units.largeSpacing
        color: Qt.alpha(root.hovered ? Kirigami.Theme.textColor : Kirigami.Theme.highlightColor, 0.10)
    }
}
