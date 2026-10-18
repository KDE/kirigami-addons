/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls.Material
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard.templates as T

T.FormDelegateBackground {
    id: root

    readonly property real stateOpacity: !control.enabled ? 0
        : control.pressed || control.visualFocus ? 0.12
        : control.hovered ? 0.08 : 0

    color: Qt.alpha(control.Material.foreground, stateOpacity)

    Behavior on color {
        ColorAnimation { duration: Kirigami.Units.shortDuration }
    }
}
