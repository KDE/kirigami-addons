// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.delegates as Delegates
import org.kde.kirigamiaddons.treeview as Tree
import org.kde.kitemmodels

/**
 * Rounded item delegate meant to be used in combination with
 * a ListView and a KDescendantsProxyModel to create a TreeView.
 *
 * @since KirigamiAddons 0.12.0
 */
Delegates.RoundedItemDelegate {
    id: root

    required property int index
    required property int kDescendantLevel
    required property var kDescendantHasSiblings
    required property bool kDescendantExpandable
    required property bool kDescendantExpanded

    leftInset: (Qt.application.layoutDirection !== Qt.RightToLeft ? decoration.width + root.padding * 2 : 0)
    leftPadding: (Qt.application.layoutDirection !== Qt.RightToLeft ? decoration.width + root.padding * 2 : 0) + Kirigami.Units.smallSpacing

    rightInset: (Qt.application.layoutDirection === Qt.RightToLeft ? decoration.width + root.padding * 2 : 0) + Kirigami.Units.smallSpacing
    rightPadding: (Qt.application.layoutDirection === Qt.RightToLeft ? decoration.width + root.padding * 2 : 0) + Kirigami.Units.smallSpacing * 2

    data: Tree.TreeViewDecoration {
        id: decoration

        parent: root
        parentDelegate: root
        model: root.ListView.view.model

        index: root.index
        kDescendantLevel: root.kDescendantLevel
        kDescendantHasSiblings: root.kDescendantHasSiblings
        kDescendantExpandable: root.kDescendantExpandable
        kDescendantExpanded: root.kDescendantExpanded

        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            leftMargin: parent.padding
        }
    }
}
