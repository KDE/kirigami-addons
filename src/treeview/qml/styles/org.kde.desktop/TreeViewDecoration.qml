/*
 *  SPDX-FileCopyrightText: 2020 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.6
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Templates 2.2 as T2
import org.kde.kitemmodels 1.0 
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

RowLayout {
    property T2.ItemDelegate parentDelegate
    property KDescendantsProxyModel model

    Layout.topMargin: -parentDelegate.topPadding
    Layout.bottomMargin: -parentDelegate.bottomPadding
    Repeater {
        model: kDescendantLevel-1
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
        enabled: kDescendantExpandable
        onClicked: model.toggleChildren(index)
        contentItem: StylePrivate.StyleItem {
            id: styleitem
            control: controlRoot
            hover: controlRoot.hovered
            elementType: "itembranchindicator"
            on: kDescendantExpanded 
            properties: {
                "isItem": true,
                "hasChildren": kDescendantExpandable,
                "hasSibling": kDescendantHasSiblings[kDescendantHasSiblings.length - 1]
            }
        }
        background: Item {}
    }
}
