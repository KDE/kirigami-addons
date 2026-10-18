/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls.Material
import org.kde.kirigamiaddons.formcard.templates as T

T.FormCardPage {
    id: root

    topPadding: 0
    leftPadding: 0
    rightPadding: 0

    background: Rectangle {
        color: Qt.tint(root.Material.backgroundColor, Qt.alpha(root.Material.foreground, 0.04))
    }
}
