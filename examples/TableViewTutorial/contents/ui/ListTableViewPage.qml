/*
 * Copyright 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.tableview as Tables
import org.kde.kirigamiaddons.BookListModel

Kirigami.Page {
    id: root

    title: i18nc("@title:group", "Table View for QAbstractListModel")

    QQC2.ScrollView {
        Component.onCompleted: background.visible = true
        anchors.fill: parent

        Tables.ListTableView {
            id: view
            model: bookListModel

            clip: true

            sortOrder: Qt.AscendingOrder
            sortRole: bookListModel.sortRole

            onColumnClicked: function (index, headerComponent) {
                if (view.model.sortRole !== headerComponent.role) {
                    view.model.sortRole = headerComponent.role;
                    view.sortOrder = Qt.AscendingOrder;
                } else {
                    view.sortOrder = view.sortOrder === Qt.AscendingOrder ? Qt.DescendingOrder : Qt.AscendingOrder
                }

                view.model.sort(0, view.sortOrder);

                // After sorting we need update selection
                __resetSelection();
            }

            function __resetSelection() {
                // NOTE: Making a forced copy of the list
                let selectedIndexes = Array(...view.selectionModel.selectedIndexes)
                let currentIndex = view.selectionModel.currentIndex.row;
                view.selectionModel.clear();

                for (let i in selectedIndexes) {
                    view.selectionModel.select(selectedIndexes[i], ItemSelectionModel.Select);
                }

                view.selectionModel.setCurrentIndex(view.model.index(currentIndex, 0), ItemSelectionModel.Select);
            }

            headerComponents: [
                Tables.HeaderComponent {
                    width: 200
                    title: i18n("Book")
                    textRole: "title"
                    role: BookRoles.TitleRole
                },

                Tables.HeaderComponent {
                    width: 200
                    title: i18n("Author")
                    textRole: "author"
                    role: BookRoles.AuthorRole
                    draggable: true

                    leading: Kirigami.Icon {
                        source: "social"
                        implicitWidth: view.compact ? Kirigami.Units.iconSizes.small : Kirigami.Units.iconSizes.medium
                        implicitHeight: implicitWidth
                    }
                },

                Tables.HeaderComponent {
                    width: 100
                    title: i18n("Year")
                    textRole: "year"
                    role: BookRoles.YearRole
                    draggable: true
                },

                Tables.HeaderComponent {
                    width: 100
                    title: i18n("Rating")
                    textRole: "rating"
                    role: BookRoles.RatingRole
                    draggable: true

                    leading: Kirigami.Icon {
                        source: "star-shape"
                        implicitWidth: view.compact ? Kirigami.Units.iconSizes.small : Kirigami.Units.iconSizes.medium
                        implicitHeight: implicitWidth
                    }
                }
            ]
        }
    }

    ListModel {
        id: __exampleModel

        ListElement {
            title: "Harry Potter and the Philosopher's Stone"
            author: "J.K. Rowling"
            year: 1997
            rating: 4.5
        }

        ListElement {
            title: "Harry Potter and the Philosopher's Stone"
            author: "J.K. Rowling"
            year: 1997
            rating: 4.5
        }

        ListElement {
            title: "Harry Potter and the Philosopher's Stone"
            author: "J.K. Rowling"
            year: 1997
            rating: 4.5
        }

        ListElement {
            title: "Harry Potter and the Philosopher's Stone"
            author: "J.K. Rowling"
            year: 1997
            rating: 4.5
        }
    }
}
