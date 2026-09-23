/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick

/**
 * Simple component for embedding an item and filling the loader's geometry.
 */
Item {
    id: root

    property Item contentItem: null

    onContentItemChanged: {
        for (const child of root.children) {
            if (child !== contentItem) {
                child.parent = null;
            }
        }

        if (contentItem) {
            contentItem.parent = root;
            contentItem.anchors.fill = root;
        }
    }
}
