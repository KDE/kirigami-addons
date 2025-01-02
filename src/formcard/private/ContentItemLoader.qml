/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick

/**
 * Simple component to easily implement embed QML components without using QQC2.Control.
 */
Item {
    id: root
    property var contentItem: null

    onContentItemChanged: {
        // clear old items
        root.children = [];

        if (contentItem instanceof Item) {
            contentItem.parent = root;
            contentItem.anchors.fill = root;
        }
    }
}
