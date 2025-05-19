/*
 *  SPDX-FileCopyrightText: 2020 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import QtQuick.Templates as T2
import org.kde.kitemmodels
import org.kde.kirigami as Kirigami

/*!
   \qmltype TreeViewDecoration
   \inqmlmodule org.kde.kirigamiaddons.treeview
   \brief The tree expander decorator for item views.

   It will have a \c {> v} expander button graphics, and will have indentation on the left
   depending on the level of the tree the item is in.

   It is recommended to use RoundedTreeDelegate directly instead of this component.
 */
RowLayout {
    /*!
       \qmlproperty ItemDelegate parentDelegate
       This property holds the delegate there this decoration will live in.

       It needs to be assigned explicitly by the developer.
     */
    required property T2.ItemDelegate parentDelegate

    /*!
       This property holds the KDescendantsProxyModel the view is showing.

       It needs to be assigned explicitly by the developer.
     */
    required property KDescendantsProxyModel model

    /*!
       This property holds the color of the decoration highlight.
     */
    property color decorationHighlightColor

    /*!
       This property holds the index of the item.

       Provided by the model/ListView.
     */
    required property int index

    /*!
       This property holds the descendant level of the item.

       Provided by the model/ListView.
     */
    required property int kDescendantLevel

    /*!
       This property holds whether this item has siblings.

       Provided by the model/ListView.
     */
    required property var kDescendantHasSiblings

    /*!
       This property holds whether the item is expandable.

       Provided by the model/ListView.
     */
    required property bool kDescendantExpandable

    /*!
       This property holds whether the item is expanded.

       Provided by the model/ListView.
     */
    required property bool kDescendantExpanded

    Layout.topMargin: -parentDelegate.topPadding
    Layout.bottomMargin: -parentDelegate.bottomPadding
    Repeater {
        model: kDescendantLevel - 1
        delegate: Item {
            Layout.preferredWidth: controlRoot.width
            Layout.fillHeight: true

            Rectangle {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    bottom: parent.bottom
                }
                visible: kDescendantHasSiblings[modelData]
                color: Kirigami.Theme.textColor
                opacity: 0.5
                width: 1
            }
        }
    }
    T2.Button {
        id: controlRoot
        Layout.preferredWidth: Kirigami.Units.gridUnit
        Layout.fillHeight: true
        enabled: kDescendantExpandable
        onClicked: model.toggleChildren(parentDelegate.index)
        contentItem: Item {
            id: styleitem
            implicitWidth: Kirigami.Units.gridUnit
            Rectangle {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    bottom: expander.visible ? expander.top : parent.verticalCenter
                }
                color: Kirigami.Theme.textColor
                opacity: 0.5
                width: 1
            }
            Kirigami.Icon {
                id: expander
                anchors.centerIn: parent
                width: Kirigami.Units.iconSizes.small
                height: width
                source: kDescendantExpanded ? "go-down-symbolic" : (Qt.application.layoutDirection == Qt.RightToLeft ? "go-previous-symbolic" : "go-next-symbolic")
                isMask: true
                color: controlRoot.hovered ? decorationLayout.decorationHighlightColor ? decorationLayout.decorationHighlightColor : Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
                Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
                Behavior on color { ColorAnimation { duration: Kirigami.Units.shortDuration; easing.type: Easing.InOutQuad } }
                visible: kDescendantExpandable
            }
            Rectangle {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: expander.visible ? expander.bottom : parent.verticalCenter
                    bottom: parent.bottom
                }
                visible: kDescendantHasSiblings[kDescendantHasSiblings.length - 1]
                color: Kirigami.Theme.textColor
                opacity: 0.5
                width: 1
            }
            Rectangle {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: expander.visible ? expander.right : parent.horizontalCenter
                    right: parent.right
                }
                color: Kirigami.Theme.textColor
                opacity: 0.5
                height: 1
            }
        }
        background: null
    }
}
