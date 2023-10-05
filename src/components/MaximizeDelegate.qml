// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.15

import org.kde.kirigami 2.15 as Kirigami

Item {
    id: root

    /**
     * @brief The main content item in the delegate.
     *
     * @note The item needs to manage it's own size as it is only anchored in the
     *       center. This allows for items with an set aspect ratio to be sized to
     *       maintain it, or for items smaller than the full space available.
     */
    property Item contentItem

    /**
     * @brief List of top row actions for this delegate.
     *
     * If used in a maximize component these actions will be added to the component's
     * action row.
     */
    property list<Kirigami.Action> actions

    /**
     * @brief Emitted when the background space around the content item is clicked.
     */
    signal backgroundClicked()

    /**
     * @brief Emit this when the content is right clicked.
     *
     * @note The content item must implement this signal itself but included here
     *       so that it can be relied on as a standard interface.
     */
    signal itemRightClicked()

    clip: true

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: root.backgroundClicked()
    }

    onContentItemChanged: {
        if (!root.contentItem) {
            return;
        }
        root.contentItem.parent = root;
        root.contentItem.anchors.centerIn = root;
    }
}
