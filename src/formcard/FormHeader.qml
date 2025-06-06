/*
 * SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
 * SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

/*!
   \qmltype FormHeader
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A header item for a form card.

   \note The header should be placed above the card in a layout not as a child.
 */
Item {
    id: root

    /*!
       \qmlproperty string title
       \brief This property holds the header title.
     */
    property alias title: headerContent.text

    /*!
       The component that appears to the right-most side of the header.
     */
    property alias trailing: header.data

    /*!
       \brief The maximum width of the header.
     */
    property real maximumWidth: Kirigami.Units.gridUnit * 30

    /*!
       \qmlproperty list<Action> actions
       The \l Action components to be presented in the header.
     */
    property list<T.Action> actions

    /*!
       \qmlproperty real topPadding
       \qmlproperty real bottomPadding
       \qmlproperty real leftPadding
       \qmlproperty real rightPadding
       Padding property.

       The default value is based on \l {Units} {Kirigami.Units}.
       To ensure consistency it's recommended that you do not change this property.
     */
    property real topPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    property real bottomPadding: Kirigami.Units.smallSpacing
    property real leftPadding: cardWidthRestricted ? Kirigami.Units.smallSpacing : Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    property real rightPadding: cardWidthRestricted ? Kirigami.Units.smallSpacing : Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing

    /*!
       \brief Whether the card's width is being restricted.
     */
    readonly property bool cardWidthRestricted: root.width > root.maximumWidth

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    Layout.fillWidth: true

    implicitHeight: header.implicitHeight
    implicitWidth: header.implicitWidth

    RowLayout {
        id: header

        spacing: Kirigami.Units.smallSpacing

        anchors {
            fill: parent
            leftMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : 0
            rightMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : 0
        }

        QQC2.Label {
            id: headerContent

            topPadding: root.topPadding
            bottomPadding: root.bottomPadding
            leftPadding: root.leftPadding
            rightPadding: root.rightPadding

            font.weight: Font.DemiBold
            wrapMode: Text.WordWrap
            Accessible.role: Accessible.Heading
            Layout.fillWidth: true
        }

        Repeater {
            model: root.actions

            QQC2.ToolButton {
                required property var modelData

                action: modelData
                visible: modelData
            }
        }
    }
}
