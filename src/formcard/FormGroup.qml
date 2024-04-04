// SPDX-FileCopyrightText: 2024 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami

/**
 * @brief A container for for a form delegates that handles spacing and headers.
 *
 * @since KirigamiAddons 0.11.0
 * @inherit org:kde::kirigami::ScrollablePage
 */
ColumnLayout {
    id: root

    default property alias delegates: internalCard.delegates

    property alias title: internalHeader.title

    property alias titleTrailing: internalHeader.trailing

    property alias titleActions: internalHeader.actions

    property real maximumWidth
    onMaximumWidthChanged: {
        internalHeader.maximumWidth = maximumWidth;
        internalCard.maximumWidth = maximumWidth;
    }

    /**
     * Whether the card's width is being restricted.
     */
    readonly property bool cardWidthRestricted: internalHeader.cardWidthRestricted || internalCard.cardWidthRestricted

    Layout.topMargin: internalHeader.visible ? 0 : Kirigami.Units.largeSpacing

    spacing: 0

    FormHeader {
        id: internalHeader
        visible: title.length > 0
    }
    FormCard {
        id: internalCard
    }
}
