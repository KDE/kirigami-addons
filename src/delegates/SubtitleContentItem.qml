// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.20 as Kirigami

RowLayout {
    id: root

    required property T.ItemDelegate itemDelegate
    required property string subtitle
    property bool bold: false

    spacing: Kirigami.Units.smallSpacing

    Kirigami.Icon {
        Layout.alignment: Qt.AlignVCenter
        visible: itemDelegate.icon.name.length > 0 || itemDelegate.icon.source.toString().length > 0
        source: itemDelegate.icon.name.length > 0 ? itemDelegate.icon.name : itemDelegate.icon.source
        Layout.preferredHeight: itemDelegate.icon.width
        Layout.preferredWidth: itemDelegate.icon.height
    }

    ColumnLayout {
        Layout.fillWidth: true

        QQC2.Label {
            leftPadding: itemDelegate.mirrored ? (itemDelegate.indicator ? itemDelegate.indicator.width : 0) + itemDelegate.spacing : 0
            rightPadding: !itemDelegate.mirrored ? (itemDelegate.indicator ? itemDelegate.indicator.width : 0) + itemDelegate.spacing : 0

            text: itemDelegate.text
            font: itemDelegate.font
            color: itemDelegate.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
            elide: Text.ElideRight
            visible: itemDelegate.text
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

            Layout.fillWidth: true
            Layout.alignment: subtitleItem.visible ? Qt.AlignLeft | Qt.AlignBottom : Qt.AlignLeft | Qt.AlignVCenter
        }

        QQC2.Label {
            id: subtitleItem

            color: itemDelegate.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
            text: root.subtitle

            elide: Text.ElideRight
            font: Kirigami.Theme.smallFont
            opacity: root.bold ? 0.9 : 0.7
            visible: text.length > 0

            Layout.fillWidth: true
            Layout.alignment: visible ? Qt.AlignLeft | Qt.AlignTop : Qt.AlignLeft | Qt.AlignVCenter
        }
    }
}

