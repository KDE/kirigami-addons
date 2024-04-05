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

    pageStack.initialPage: FormCard.FormPage {
        FormCard.FormGroup {
            Layout.topMargin: Kirigami.Units.gridUnit

            FormCard.FormButtonDelegate {
                text: i18nc("@title:action", "Table View for QAbstractTableModel")
                onClicked: root.pageStack.layers.push(tableviewpage)
            }

            FormCard.FormDelegateSeparator {}

            FormCard.FormButtonDelegate {
                text: i18nc("@title:action", "Table View for QAbstractListModel")
                onClicked: root.pageStack.layers.push(listtableviewpage)
            }
        }
    }
}
