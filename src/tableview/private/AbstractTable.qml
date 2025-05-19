/*
 * Copyright 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami

/*!
   \qmltype AbstractTable
   \inqmlmodule org.kde.kirigamiaddons.tableview
 */
Flickable {
    id: root

    Accessible.role: Accessible.Table
    interactive: false
    focus: true

    /*!
       \brief This property holds the model that provides data for the table.

       The model provides the set of data that is used to create the items in the view.
     */
    property var model

    /*!
       \brief The default property that stores the components for forming the columns of this table.
       \sa AbstractHeaderComponent
     */
    property list<AbstractHeaderComponent> headerComponents
    onHeaderComponentsChanged: updateModel()

    /*!
       \brief This property holds the number of rows in the view.
     */
    readonly property int rowCount: __rowCount

    /*!
       \brief This property holds the number of columns in the component include invisibles.
     */
    readonly property int columnCount: __columnCount

    /*!
       \brief This property controls whether the background color of the rows should alternate.
       \default true
     */
    property bool alternatingRows: true


    /*!
       \brief If this property is enabled, the table will be displayed in a compact form.
       \default true
     */
    property bool compact: true

    /*!
       \brief A link to a list of context menu items.
       \sa Menu
     */
    property alias actions: menu.contentData

    /*!
       \qmlproperty Qt.SortOrder sortOrder
       \brief The property is responsible for the direction in which sorting will be performed.
       \note You must implement sorting yourself for this property to be valid.
       \sa sortRole
       \sa {Qt::SortOrder} {Qt.SortOrder}
     */
    property int sortOrder

    /*!
       \brief This property specifies based on which role the table will be sorted.
       \note You must implement sorting yourself for this property to be valid.
       \sa sortOrder
     */
    property int sortRole: -1

    /*!
       \brief This property can be set to control which delegate items should be shown as selected, and which item should be shown as current.

       Using the selectionType and selectionMode properties you can adjust the selection behavior.

       \sa selectionType
       \sa selectionMode
     */
    property ItemSelectionModel selectionModel: ItemSelectionModel { model: root.model }

    /*!
       \brief This property holds whether the user can select cells, rows or columns.
       \default TableView.SelectRows
       \sa {TableView::selectionBehavior} {TableView.selectionBehavior}
     */
    property int selectionBehavior: TableView.SelectRows

    /*!
       \brief The selection mode.

       \value TableView.SelectCells
              Whether the user can select one cell at a time, or multiple cells.
       \value TableView.SelectRows
              Whether the user can select one row at a time, or multiple rows.
       \value TableView.SelectColumns
              Whether the user can select one column at a time, or multiple columns.

       \default TableView.ExtendedSelection
       \sa {TableView::selectionMode} {TableView.selectionMode}
     */
    property int selectionMode: TableView.ExtendedSelection

    /*!
     */
    signal columnClicked(int column, var headerComponent)
    /*!
     */
    signal columnDoubleClicked(int column, var headerComponent)

    /*!
     */
    signal rowClicked(int row)
    /*!
     */
    signal rowDoubleClicked(int row)

    readonly property var __columnModel: ListModel { id: columnModel }
    readonly property real __rowHeight: root.compact ? Kirigami.Units.gridUnit * 2
                                                     : Kirigami.Units.gridUnit * 3

    property int __rowCount
    property int __columnCount: columnModel.count

    property bool __isControlModifier: false
    property bool __isShiftModifier: false

    Keys.onPressed: function(event) {
        __isControlModifier = event.modifiers & Qt.ControlModifier
        __isShiftModifier = event.modifiers & Qt.ShiftModifier
    }

    Keys.onReleased: function(event) {
        __isControlModifier = event.modifiers & Qt.ControlModifier
        __isShiftModifier = event.modifiers & Qt.ShiftModifier
    }

    onRowClicked: function(row) {
        __selectCell(row, 0);
    }

    QQC2.Menu { id: menu }

    MouseArea {
        z: -2
        anchors.fill: parent
        propagateComposedEvents: true
        acceptedButtons: Qt.RightButton
        onClicked: function(mouse) {
            root.forceActiveFocus();
            if (mouse.button === Qt.RightButton) {
                if (menu.count > 0) {
                    menu.x = mouse.x
                    menu.y = mouse.y
                    menu.open()
                    mouse.accepted = true
                    return;
                }
            }

            mouse.accepted = false
        }
    }

    function updateModel(): void {
        __columnModel.clear();
        for(let index = 0; index < root.headerComponents.length; index++) {
            let object = root.headerComponents[index];

            if (object instanceof AbstractHeaderComponent && object.visible) {
                __columnModel.append({ headerComponent: object });
            }
        }
    }

    function __columnsContentWidth(): real {
        let contentWidth = 0

        for(let index = 0; index < __columnModel.count; index++) {
            let column = __columnModel.get(index).headerComponent;

            if (column.visible) {
                contentWidth += column.width;
            }
        }

        return contentWidth
    }

    function __columnWidth(column: int, explicitWidth: real): real {
        const columnItem = root.__columnModel.get(column).headerComponent;
        if (!columnItem.resizable) {
            return columnItem.width;
        }

        if (explicitWidth > 0) {
            if (explicitWidth < columnItem.minimumWidth) {
                return columnItem.minimumWidth;
            }

            return explicitWidth;
        }

        return columnItem.width;
    }

    function __selectCell(row: int, column: int): void {
        if (!root.selectionModel || root.selectionBehavior === TableView.SelectionDisabled) {
            return;
        }

        const modelIndex = root.model.index(row, column);

        if (__isControlModifier && root.selectionMode !== TableView.SingleSelection) {
            root.selectionModel.setCurrentIndex(modelIndex, ItemSelectionModel.Toggle);

            if (!root.selectionModel.hasSelection) {
                root.selectionModel.clearSelection();
                root.selectionModel.clearCurrentIndex();
            }

            return;
        }

        if (__isShiftModifier && root.selectionMode !== TableView.SingleSelection) {
            const currentIndex = root.selectionModel.currentIndex;

            const startRow = Math.min(row, currentIndex.row);
            const endRow = Math.max(row, currentIndex.row);
            const startColumn = Math.min(column, currentIndex.column);
            const endColumn = Math.max(column, currentIndex.column);

            for (let _row = startRow; _row <= endRow; _row++) {
                for (let _column = startColumn; _column <= endColumn; _column++) {
                    root.selectionModel.select(root.model.index(_row, _column), ItemSelectionModel.Select);
                }
            }

            return;
        }

        root.selectionModel.setCurrentIndex(modelIndex, ItemSelectionModel.ClearAndSelect);
    }

    function __selectRow(row: int): void {
        for (let column = 0; column < root.__columnCount; column++) {
            __selectCell(row, column);
        }
    }

    function __selectColumn(column: int): void {
        for (let row = 0; row < root.__rowCount; row++) {
            __selectCell(row, column);
        }
    }
}
