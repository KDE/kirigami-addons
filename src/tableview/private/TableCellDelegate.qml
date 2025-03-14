/*
 * Copyright 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami

/*!
   \qmltype TableCellDelegate
   \inqmlmodule org.kde.kirigamiaddons.tableview
 */
QQC2.ItemDelegate {
    id: delegate

    Accessible.role: Accessible.Cell
    highlighted: selected

    /*!
     */
    required property int row
    /*!
     */
    required property var index
    /*!
     */
    required property int column
    /*!
     */
    required property bool current
    /*!
     */
    required property bool selected
    /*!
     */
    required property var model

    /*!
     */
    readonly property AbstractHeaderComponent headerComponent: __columnModel.get(column).headerComponent

    Rectangle {
        anchors.fill: parent
        visible: delegate.current
        color: "Transparent"
        border.color: Kirigami.Theme.highlightColor
    }

    contentItem: Loader {
        sourceComponent: delegate.headerComponent.itemDelegate
        readonly property var modelData: model.display ?? delegate.model[delegate.headerComponent.textRole]
        readonly property var index: delegate.index
        readonly property int row: delegate.row
        readonly property int column: delegate.column
        readonly property var model: delegate.model
    }

    onClicked: delegate.forceActiveFocus()
}
