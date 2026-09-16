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
    property Item contentItem: null

    onContentItemChanged: {
        // Detach the previous item before attaching the replacement.
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
