/*
 * Copyright 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

QQC2.Control {
    id: delegate

    Accessible.role: Accessible.Cell
    hoverEnabled: false

    required property int index
    required property var model

    // Reference for current entry of root.model
    property var entry
    property int rowIndex

    contentItem: Loader {
        sourceComponent: delegate.model.headerComponent.itemDelegate
        readonly property var modelData: delegate.entry[delegate.model.headerComponent.textRole]
        readonly property var model: delegate.entry
        readonly property int row: delegate.rowIndex
        readonly property int column: delegate.index
    }
}
