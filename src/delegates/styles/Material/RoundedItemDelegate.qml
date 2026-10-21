/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls.Material as Material
import org.kde.kirigamiaddons.delegates as Delegates

Material.ItemDelegate {
    id: root

    property var listView: ListView
    property var gridView: GridView
    property bool dropAreaHovered: false

    width: if (root.listView.view) {
        return root.listView.view.width;
    } else if (root.gridView.view) {
        return root.gridView.view.cellWidth;
    } else {
        return implicitWidth;
    }

    height: root.gridView.view ? root.gridView.view.cellHeight : implicitHeight
    highlighted: root.listView.isCurrentItem || root.gridView.isCurrentItem

    contentItem: Delegates.DefaultContentItem {
        itemDelegate: root
    }
}
