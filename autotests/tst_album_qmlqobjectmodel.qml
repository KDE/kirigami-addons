// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.15
import QtTest 1.2

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kirigamiaddons.labs.components 1.0

BaseAlbumMaximizeComponentTestCase {
    id: root

    property list<AlbumModelItem> items: [
        AlbumModelItem {
            type: AlbumModelItem.Image
            source: Qt.resolvedUrl(root.testImage)
            tempSource: Qt.resolvedUrl(root.testImage)
            caption: "A test image"
        },
        AlbumModelItem {
            type: AlbumModelItem.Video
            source: Qt.resolvedUrl(root.testVideo)
            tempSource: Qt.resolvedUrl(root.testImage)
            caption: "A test video"
        },
        // This is just to test a blank caption.
        AlbumModelItem {
            type: AlbumModelItem.Image
            source: Qt.resolvedUrl(root.testImage)
            tempSource: Qt.resolvedUrl(oot.testImage)
            caption: ""
        }
    ]

    name: "AlbumQmlQObjectModelTest"
    model: root.items
}

