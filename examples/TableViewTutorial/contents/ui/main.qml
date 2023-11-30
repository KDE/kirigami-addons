/*
 * Copyright 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQml
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

Kirigami.ApplicationWindow {
    id: root
    width: 600
    height: 700

    Component {
        id: tableviewpage
        TableViewPage {}
    }

    Component {
        id: listtableviewpage
        ListTableViewPage {}
    }

    pageStack.initialPage: Kirigami.ScrollablePage {
        ColumnLayout {
            FormCard.FormCard {
                FormCard.FormButtonDelegate {
                    text: i18n("Table View for QAbstractTableModel")
                    onClicked: root.pageStack.layers.push(tableviewpage)
                }

                FormCard.FormButtonDelegate {
                    text: i18n("Table View for QAbstractListModel")
                    onClicked: root.pageStack.layers.push(listtableviewpage)
                }
            }
        }
    }
}
