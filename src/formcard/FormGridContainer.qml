// SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
// SPDX-FileCopyrightText: 2023 Rishi Kumar <rsi.dev17@gmail.com>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

import "private" as Private

/*!
   \qmltype FormGridContainer
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief This component render a grid of small cards.

   This is used to display multiple information in a FormCard.FormLayout
   without taking too much vertical space.

   Form delegates can also be placed directly inside the container. In this
   mode, delegates are displayed in a two-column grid, each with its own card
   background.

   \qml
   import org.kde.kirigamiaddons.formcard as FormCard

   FormCard.FormGridContainer {
       id: container

       Layout.topMargin: Kirigami.Units.largeSpacing
       Layout.fillWidth: true

       infoCards: [
           FormCard.FormGridContainer.InfoCard {
               title: "42"
               subtitle: i18nc("@info:Number of Posts", "Posts")
           },
           FormCard.FormGridContainer.InfoCard {
               title: "42"
               subtitle: i18nc("@info:Number of followers.", "Followers")
           }
       ]
   }
   \endqml

   \qml
   import org.kde.kirigamiaddons.formcard as FormCard

   FormCard.FormGridContainer {
       FormCard.FormTextDelegate {
           text: "Name"
       }
       FormCard.FormSwitchDelegate {
           text: "Enable notifications"
       }
   }
   \endqml

   \since 0.11.0
 */
Item {
    id: root

    /*! The form delegates displayed in the container. */
    default property list<Item> delegates

    readonly property bool hasDelegates: delegates.length > 0

    /*!
       This property holds the maximum width of the grid.
       \default Kirigami.Units.gridUnit * 30
     */
    property real maximumWidth: Kirigami.Units.gridUnit * 30

    /*!
       \qmlproperty real padding
       \qmlproperty real verticalPadding
       \qmlproperty real horizontalPadding
       \qmlproperty real topPadding
       \qmlproperty real bottomPadding
       \qmlproperty real leftPadding
       \qmlproperty real rightPadding
       \brief Padding property used around the content edges.
       \default 0
     */
    property real padding: 0
    property real verticalPadding: padding
    property real horizontalPadding: padding
    property real topPadding: verticalPadding
    property real bottomPadding: verticalPadding
    property real leftPadding: horizontalPadding
    property real rightPadding: horizontalPadding

    /*!
       This property holds whether the card's width is being restricted.
     */
    readonly property bool cardWidthRestricted: root.width > root.maximumWidth

    /*!
       This property holds the InfoCards which should be displayed.

       Each InfoCard contains a title and an optional subtitle

       \qml
       import org.kde.kirigamiaddons.formcard as FormCard

       FormCard.FormGridContainer {
           infoCards: [
               FormCard.FormGridContainer.InfoCard {
                   title: "42"
                   subtitle: i18nc("@info:Number of Posts", "Posts")
               },
               FormCard.FormGridContainer.InfoCard {
                   title: "42"
               },
               FormCard.FormGridContainer.InfoCard {
                   title: "Details"
                   action: Kirigami.Action {
                       onClicked: pageStack.push("Details.qml")
                   }
               }
           ]
       }
       \endqml

       \deprecated Use direct form delegates instead.
     */
    property list<QtObject> infoCards

    /*!
       A legacy data object used by the deprecated \c infoCards property.

       \deprecated Use direct form delegates instead.
     */
    component InfoCard: QtObject {
        property bool visible: true
        property string title
        property string subtitle
        property string buttonIcon
        property string tooltipText
        property int subtitleTextFormat: Text.AutoText
        property Kirigami.Action action
    }

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    Layout.fillWidth: true

    implicitHeight: topPadding + bottomPadding + (hasDelegates ? delegateGrid.implicitHeight : infoGrid.implicitHeight)

    GridLayout {
        id: delegateGrid

        visible: root.hasDelegates
        anchors {
            fill: parent
            leftMargin: (root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : 0) + root.leftPadding
            rightMargin: (root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : 0) + root.rightPadding
            topMargin: root.topPadding
            bottomMargin: root.bottomPadding
        }
        columns: 2
        columnSpacing: Kirigami.Units.smallSpacing
        rowSpacing: Kirigami.Units.smallSpacing

        Repeater {
            model: root.delegates

            Item {
                required property int index

                implicitWidth: root.delegates[index]?.implicitWidth ?? 0
                implicitHeight: root.delegates[index]?.implicitHeight ?? 0

                Layout.preferredWidth: Kirigami.Units.gridUnit * 10
                Layout.columnSpan: root.delegates.length % 2 !== 0 && index === root.delegates.length - 1 ? 2 : 1
                Layout.fillWidth: true
                Layout.fillHeight: true

                Private.FormCardBackground {
                    anchors.fill: parent
                    rounded: true
                }

                LayoutItemProxy {
                    id: delegateLoader

                    anchors.fill: parent
                    target: root.delegates[index]
                }
            }
        }
    }

    Private.FormInfoGrid {
        id: infoGrid

        visible: !root.hasDelegates
        maximumWidth: root.maximumWidth
        leftPadding: root.leftPadding
        rightPadding: root.rightPadding
        topPadding: root.topPadding
        bottomPadding: root.bottomPadding
        cardWidthRestricted: root.cardWidthRestricted
        infoCards: root.infoCards

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right

            leftMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : 0
            rightMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : 0
        }

    }
}
