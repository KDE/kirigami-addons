// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

/*!
   \qmltype DefaultContentItem
   \inqmlmodule org.kde.kirigamiaddons.delegates
   \brief Content item which is used by default in the RoundedItemDelegate and IndicatorItemDelegate.

   Provides a label and an icon.

   This can be used directly as contentItem or inside a RowLayout if you need to put some content before or after this item.
   \since 0.10.0
 */
RowLayout {
    id: root

    /*!
       \qmlproperty AbstractButton itemDelegate
       This required property holds the item delegate corresponding to this content item.
       \since 0.10.0
     */
    required property T.AbstractButton itemDelegate

    /*!
       \qmlproperty Label labelItem
       This property holds the Label containing the text of the item delegate.
       \since 0.10.1
     */
    readonly property alias labelItem: labelItem

    /*!
       \qmlproperty Kirigami.Icon iconItem
       This property holds the \l {Icon} {Kirigami.Icon} containing the icon of the item delegate.
       \since 0.10.1
     */
    readonly property alias iconItem: iconItem

    spacing: itemDelegate instanceof T.ItemDelegate ? itemDelegate.spacing : Kirigami.Units.mediumSpacing

    Kirigami.Icon {
        id: iconItem

        Layout.alignment: Qt.AlignVCenter
        visible: itemDelegate.icon.name.length > 0 || itemDelegate.icon.source.toString().length > 0
        source: itemDelegate.icon.name.length > 0 ? itemDelegate.icon.name : itemDelegate.icon.source
        Layout.preferredHeight: itemDelegate.icon.width
        Layout.preferredWidth: itemDelegate.icon.height
    }

    QQC2.Label {
        id: labelItem

        leftPadding: itemDelegate.mirrored ? (itemDelegate.indicator ? itemDelegate.indicator.width : 0) + itemDelegate.spacing : 0
        rightPadding: !itemDelegate.mirrored ? (itemDelegate.indicator ? itemDelegate.indicator.width : 0) + itemDelegate.spacing : 0

        text: root.itemDelegate.text
        font: root.itemDelegate.font
        color: root.itemDelegate.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
        elide: Text.ElideRight
        visible: itemDelegate.text && itemDelegate.display !== QQC2.AbstractButton.IconOnly
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        Layout.alignment: Qt.AlignLeft
        Layout.fillWidth: true

        Accessible.ignored: true
    }
}

