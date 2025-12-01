// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick
import QtTest

import test.artefacts

BaseAlbumMaximizeComponentTestCase {
    id: root
    name: "AlbumAbstractListModelTest"
    model: ExampleAlbumModel {
        testImage: Qt.resolvedUrl(root.testImage)
        testVideo: Qt.resolvedUrl(root.testVideo)
    }
}
