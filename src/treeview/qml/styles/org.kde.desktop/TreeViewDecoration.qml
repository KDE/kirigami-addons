//  SPDX-FileCopyrightText: 2020 Marco Martin <mart@kde.org>
//  SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import QtQuick.Templates as T2
import org.kde.kitemmodels
import org.kde.qqc2desktopstyle.private as StylePrivate

RowLayout {
    id: root

    required property int index
    required property int kDescendantLevel
    required property var kDescendantHasSiblings
    required property bool kDescendantExpandable
    required property bool kDescendantExpanded
    required property T2.ItemDelegate parentDelegate
    required property KDescendantsProxyModel model

    Layout.topMargin: -parentDelegate.topPadding
    Layout.bottomMargin: -parentDelegate.bottomPadding

    Repeater {
        model: kDescendantLevel - 1
        delegate: StylePrivate.StyleItem {
            Layout.preferredWidth: controlRoot.width
            Layout.fillHeight: true
            visible: true
            elementType: "itembranchindicator"
            properties: {
                "isItem": false,
                "hasSibling": kDescendantHasSiblings[modelData]
            }
        }
    }

    T2.Button {
        id: controlRoot
        Layout.preferredWidth: contentItem.pixelMetric("treeviewindentation")
        Layout.fillHeight: true
        enabled: root.kDescendantExpandable
        onClicked: {
            root.model.toggleChildren(root.parentDelegate.index)
        }
        contentItem: StylePrivate.StyleItem {
            id: styleitem
            control: controlRoot
            hover: controlRoot.hovered
            elementType: "itembranchindicator"
            on: kDescendantExpanded
            properties: {
                "isItem": true,
                "hasChildren": root.kDescendantExpandable,
                "hasSibling": root.kDescendantHasSiblings[root.kDescendantHasSiblings.length - 1]
            }
        }
        background: null
    }
}
