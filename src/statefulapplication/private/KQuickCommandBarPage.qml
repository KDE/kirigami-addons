// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.delegates as Delegates
import org.kde.kirigamiaddons.components as Components
import org.kde.kirigamiaddons.statefulapp as StatefulApp
import QtQuick.Templates as T

Kirigami.SearchDialog {
    id: root

    required property StatefulApp.AbstractKirigamiApplication application

    background: Components.DialogRoundedBackground {}

    onTextChanged: root.application.actionsModel.filterString = text

    model: root.application.actionsModel
    delegate: Delegates.RoundedItemDelegate {
        id: commandDelegate

        required property int index
        required property string decoration
        required property string displayName
        required property string shortcut
        required property var qaction

        icon.name: decoration
        text: displayName

        contentItem: RowLayout {
            spacing: Kirigami.Units.smallSpacing

            Delegates.DefaultContentItem {
                itemDelegate: commandDelegate
                Layout.fillWidth: true
            }

            QQC2.Label {
                text: commandDelegate.shortcut
                color: Kirigami.Theme.disabledTextColor
            }
        }

        onClicked: {
            qaction.trigger()
            root.close()
        }
    }

    emptyText: i18n("No results found")
}
