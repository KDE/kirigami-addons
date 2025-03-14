/*
 * Copyright 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami

import "private" as Private

/*!
   \qmltype ListTableView
   \inqmlmodule org.kde.kirigamiaddons.tableview
 */
Private.AbstractTable {
    id: root

    contentWidth: __columnsContentWidth()
    contentHeight: listView.contentHeight

    __rowCount: listView.count

    ListView {
        id: listView

        anchors.fill: parent
        model: root.model
        interactive: false

        header: QQC2.HorizontalHeaderView {
            id: header

            width: listView.width
            height: root.__rowHeight

            model: root.__columnModel
            interactive: false

            rowHeightProvider: () => root.__rowHeight
            columnWidthProvider: function(column) {
                if (!isColumnLoaded(index)) {
                    return;
                }

                return root.__columnWidth(column, explicitColumnWidth(column))
            }

            onLayoutChanged: {
                for(let column = 0; column < root.columnCount; column++) {
                    const columnItem = root.__columnModel.get(column).headerComponent;
                    columnItem.width = columnWidthProvider(column)
                }
            }

            delegate: Private.HeaderDelegate {
                sortEnabled: headerComponent.role === root.sortRole
                sortOrder: root.sortOrder
                onClicked: root.columnClicked(column, headerComponent)
                onDoubleClicked: root.columnDoubleClicked(column, headerComponent)
            }
        }

        delegate: Private.ListRowDelegate {
            id: delegate

            highlighted: root.selectionModel?.isSelected(root.model.index(index, 0)) ?? false
            alternatingRows: root.alternatingRows

            Connections {
                target: root.selectionModel

                function onSelectionChanged(selected, deselected) {
                    delegate.highlighted = Qt.binding(() => root.selectionModel.isSelected(root.model.index(delegate.index, 0)))
                }
            }

            onClicked: root.rowClicked(index)
            onDoubleClicked: root.rowDoubleClicked(index)
        }
    }
}
