// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.15
import QtTest 1.2

import test.artefacts 1.0

BaseAlbumMaximizeComponentTestCase {
    id: root
    name: "AlbumAbstractListModelTest"
    model: ExampleAlbumModel {
        testImage: Qt.resolvedUrl(root.testImage)
        testVideo: Qt.resolvedUrl(root.testVideo)
    }
}
