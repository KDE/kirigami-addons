// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Window
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

/**
 * @brief A scrollable page used as a container for one or more FormCards.
 *
 * @since KirigamiAddons 0.11.0
 * @inherit org:kde::kirigami::ScrollablePage
 */
Kirigami.ScrollablePage {
    id: root

    default property alias cards: internalLayout.data

    topPadding: 0
    leftPadding: 0
    rightPadding: 0

    ColumnLayout {
        id: internalLayout

        spacing: 0
    }
}
