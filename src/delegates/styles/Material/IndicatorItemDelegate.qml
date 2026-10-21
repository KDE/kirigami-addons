/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls.Material as Material
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.delegates as Delegates

Material.ItemDelegate {
    id: root

    required property int index
    required property bool unread

    property ListView listView: ListView.view
    readonly property bool showSeparator: root.listView && root.index !== root.listView.count

    width: root.listView ? root.listView.width : implicitWidth
    highlighted: ListView.isCurrentItem

    contentItem: Delegates.DefaultContentItem {
        itemDelegate: root
    }

    Rectangle {
        anchors {
            left: parent.left
            top: parent.top
            topMargin: 1
            bottom: parent.bottom
            bottomMargin: 1
        }

        width: Kirigami.Units.smallSpacing
        visible: root.unread
        color: Kirigami.Theme.highlightColor
    }
}
