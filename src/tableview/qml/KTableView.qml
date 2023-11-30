/*
 * Copyright 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami

import "private" as Private

Private.AbstractTable {
    id: root

    contentWidth: header.contentWidth
    contentHeight: header.contentHeight + tableView.contentHeight
    selectionBehavior: TableView.SelectCells

    signal cellClicked(int row, int column)
    signal cellDoubleClicked(int row, int column)

    __rowCount: tableView.rows

    QQC2.HorizontalHeaderView {
        id: header

        width: tableView.width
        height: root.__rowHeight

        model: root.__columnModel
        syncView: tableView
        interactive: false

        rowHeightProvider: () => root.__rowHeight

        delegate: Private.HeaderDelegate {
            sortEnabled: headerComponent.role === root.sortRole
            sortOrder: root.sortOrder
            onClicked: root.columnClicked(column, headerComponent)
            onDoubleClicked: root.columnDoubleClicked(column, headerComponent)
        }
    }

    TableView {
        id: tableView

        anchors.fill: parent
        anchors.topMargin: header.height
        model: root.model
        interactive: false

        alternatingRows: root.alternatingRows
        selectionModel: root.selectionModel
        selectionMode: root.selectionMode
        selectionBehavior: root.selectionBehavior

        resizableColumns: false
        resizableRows: false

        rowHeightProvider: () => root.__rowHeight
        columnWidthProvider: function(column) {
            if (!isColumnLoaded(index)) {
                return;
            }

            return root.__columnWidth(column, explicitColumnWidth(column))
        }

        delegate: Private.TableCellDelegate {
            onClicked: root.cellClicked(row, column)
            onDoubleClicked: root.cellDoubleClicked(row, column)
        }
    }

    QQC2.SelectionRectangle {
        target: tableView
        topLeftHandle: null
        bottomRightHandle: null
    }

    // TableView controls selection behavior only when user interact with table using keyboard and holding shift key
    onCellClicked: function(row, column) {
        if (root.selectionBehavior === TableView.SelectCells) {
            __selectCell(row, column);
        }

        if (root.selectionBehavior === TableView.SelectRows) {
            if (__isControlModifier || __isShiftModifier) {
                __selectRow(row);
                return
            }

            root.selectionModel.clearSelection();
            root.selectionModel.clearCurrentIndex();
            for (let _column = 0; _column < root.columnCount; _column++) {
                root.selectionModel.setCurrentIndex(root.model.index(row, _column), ItemSelectionModel.Select);
            }
        }

        if (root.selectionBehavior === TableView.SelectColumns) {
            if (__isControlModifier || __isShiftModifier) {
                __selectColumn(column);
                return;
            }

            root.selectionModel.clearSelection();
            root.selectionModel.clearCurrentIndex();
            for (let _row = 0; _row < root.rowCount; _row++) {
                root.selectionModel.setCurrentIndex(root.model.index(_row, column), ItemSelectionModel.Select);
            }
        }
    }
}
