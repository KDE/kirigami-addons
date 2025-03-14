// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

/*!
   \qmltype SubtitleContentItem
   \inqmlmodule org.kde.kirigamiaddons.delegates
 */
RowLayout {
    id: root

    /*!
       \qmlproperty ItemDelegate itemDelegate
     */
    required property T.ItemDelegate itemDelegate
    /*!
     */
    required property string subtitle
    /*!
     */
    property bool bold: false

    /*!
       \qmlproperty Label labelItem
     */
    readonly property alias labelItem: labelItem
    /*!
       \qmlproperty Label subtitleItem
     */
    readonly property alias subtitleItem: subtitleItem
    /*!
       \qmlproperty Kirigami.Icon iconItem
     */
    readonly property alias iconItem: iconItem

    spacing: itemDelegate instanceof T.ItemDelegate ? itemDelegate.spacing : Kirigami.Units.mediumSpacing

    Kirigami.Icon {
        id: iconItem

        visible: itemDelegate.icon.name.length > 0 || itemDelegate.icon.source.toString().length > 0
        source: itemDelegate.icon.name.length > 0 ? itemDelegate.icon.name : itemDelegate.icon.source

        Layout.alignment: Qt.AlignVCenter
        Layout.preferredHeight: itemDelegate.icon.width
        Layout.preferredWidth: itemDelegate.icon.height
        Layout.leftMargin: Kirigami.Units.smallSpacing
        Layout.rightMargin: Kirigami.Units.smallSpacing
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 0

        QQC2.Label {
            id: labelItem

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

