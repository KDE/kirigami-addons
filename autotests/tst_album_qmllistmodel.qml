// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick
import QtTest

import org.kde.kirigamiaddons.labs.components

BaseAlbumMaximizeComponentTestCase {
    id: root
    name: "AlbumQmlListModelTest"
    model: ListModel {
        id: listModel
    }

    Component.onCompleted: {
        listModel.append({"type": AlbumModelItem.Image,
                         "source": Qt.resolvedUrl(root.testImage),
                         "sourceWidth": 0,
                         "sourceHeight": 0,
                         "tempSource": Qt.resolvedUrl(root.testImage),
                         "caption": "A test image"})
        listModel.append({"type": AlbumModelItem.Video,
                         "source": Qt.resolvedUrl(root.testVideo),
                         "sourceWidth": 0,
                         "sourceHeight": 0,
                         "tempSource": Qt.resolvedUrl(root.testImage),
                         "caption": "A test video"})
        listModel.append({"type": AlbumModelItem.Image,
                         "source": Qt.resolvedUrl(root.testImage),
                         "sourceWidth": 0,
                         "sourceHeight": 0,
                         "tempSource": Qt.resolvedUrl(root.testImage),
                         "caption": ""})
    }
}
