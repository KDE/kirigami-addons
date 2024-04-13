// SPDX-FileCopyrightText: 2024 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kirigamiaddons.delegates as Delegates

Kirigami.ScrollablePage {
    property alias model: listView.model

    title: i18ndc("kirigami-addons6", "@title:window", "Shortcuts")

    actions: Kirigami.Action {
        displayComponent: Kirigami.SearchField {
            placeholderText: i18ndc("kirigami-addons6", "@label:textbox", "Filter...")
        }
    }

    ListView {
        id: listView

        delegate: Delegates.RoundedItemDelegate {
            id: shortcutDelegate

            required property int index
            required property string actionName
            required property string shortcut

            text: actionName.replace('&', '')

            contentItem: RowLayout {
                QQC2.Label {
                    text: shortcutDelegate.text
                    Layout.fillWidth: true
                }

                QQC2.Label {
                    text: shortcutDelegate.shortcut
                }
            }

            onClicked: {
                shortcutDialog.title = i18ndc("krigiami-addons6", "@title:window", "Shortcut: %1",  shortcutDelegate.text);
                shortcutDialog.open()
            }
        }

        FormCard.FormCardDialog {
            id: shortcutDialog
            parent: QQC2.ApplicationWindow.overlay
        }

        Kirigami.PlaceholderMessage {
            width: parent.width - Kirigami.Units.gridUnit * 4
            anchors.centerIn: parent
            text: i18ndc("kirigami-addons6", "Placeholder message", "No shortcuts found")
            visible: listView.count === 0
        }
    }
}