/*
 * Copyright 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.tableview as Tables
import org.kde.kirigamiaddons.BookTableModel

import Qt.labs.qmlmodels

Kirigami.Page {
    id: root

    title: i18nc("@title:group", "Table View for QAbstractTableModel")

    topPadding: 0
    leftPadding: 0
    bottomPadding: 0
    rightPadding: 0

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    contentItem: QQC2.ScrollView {
        contentItem: Tables.KTableView {
            id: view
            model: bookTableModel

            interactive: false
            clip: true
            alternatingRows: false

            sortOrder: Qt.AscendingOrder
            sortRole: BookRoles.YearRole

            onColumnClicked: function (index, headerComponent) {
                if (view.sortRole !== headerComponent.role) {
                    view.sortRole = index;
                    view.sortOrder = Qt.AscendingOrder;
                } else {
                    view.sortOrder = view.sortOrder === Qt.AscendingOrder ? Qt.DescendingOrder : Qt.AscendingOrder
                }

                view.model.sort(view.sortRole, view.sortOrder);

                // After sorting we need update selection
                __resetSelection();
            }

            function __resetSelection() {
                // NOTE: Making a forced copy of the list
                let selectedIndexes = Array(...view.selectionModel.selectedIndexes)

                let currentRow = view.selectionModel.currentIndex.row;
                let currentColumn = view.selectionModel.currentIndex.column;

                view.selectionModel.clear();
                for (let i in selectedIndexes) {
                    view.selectionModel.select(selectedIndexes[i], ItemSelectionModel.Select);
                }

                view.selectionModel.setCurrentIndex(view.model.index(currentRow, currentColumn), ItemSelectionModel.Select);
            }

            headerComponents: [
                Tables.HeaderComponent {
                    width: 200
                    title: i18nc("@title:column", "Book")
                    textRole: "title"
                    role: BookRoles.TitleRole
                },

                Tables.HeaderComponent {
                    width: 200
                    title: i18nc("@title:column", "Author")
                    textRole: "author"
                    role: BookRoles.AuthorRole

                    leading: Kirigami.Icon {
                        source: "social"
                        implicitWidth: view.compact ? Kirigami.Units.iconSizes.small : Kirigami.Units.iconSizes.medium
                        implicitHeight: implicitWidth
                    }
                },

                Tables.HeaderComponent {
                    width: 100
                    title: i18nc("@title:column", "Year")
                    textRole: "year"
                    role: BookRoles.YearRole
                },

                Tables.HeaderComponent {
                    width: 100
                    title: i18nc("@title:column", "Rating")
                    textRole: "rating"
                    role: BookRoles.RatingRole

                    leading: Kirigami.Icon {
                        source: "star-shape"
                        implicitWidth: view.compact ? Kirigami.Units.iconSizes.small : Kirigami.Units.iconSizes.medium
                        implicitHeight: implicitWidth
                    }
                }
            ]
        }
    }

    TableModel {
        id: __exampleModel
        TableModelColumn { display: "title" }
        TableModelColumn { display: "author" }
        TableModelColumn { display: "year" }
        TableModelColumn { display: "rating" }

        rows: [
            {
                title: "Harry Potter and the Philosopher's Stone",
                author: "J.K. Rowling",
                year: 1997,
                rating: 4.5
            },
            {
                title: "Harry Potter and the Philosopher's Stone",
                author: "J.K. Rowling",
                year: 1997,
                rating: 4.5
            },
            {
                title: "Harry Potter and the Philosopher's Stone",
                author: "J.K. Rowling",
                year: 1997,
                rating: 4.5
            },
            {
                title: "Harry Potter and the Philosopher's Stone",
                author: "J.K. Rowling",
                year: 1997,
                rating: 4.5
            },
        ]
    }
}
