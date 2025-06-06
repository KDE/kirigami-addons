/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

import "private" as Private

/*!
   \qmltype FormCard
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A single card that follows a form style.

   This is the entrypoint component for FormCard.

   A FormCard consists of a container that can be used to create your
   own Settings pages. It has a different color than the background.

   Each FormCard can contain one or more Form delegates in its contentItem.
   To add more than one Form delegate to a FormCard, use a
   ColumnLayout to group them.

   Multiple FormCards can be grouped with a ColumnLayout to
   represent different Settings sections.

   Each section is expected to contain a FormHeader as the first
   delegate, which serves the role of a section title.

   The height of the FormCard matches the implicit height of the
   contentItem and does not need to be set, while the width is expected
   to be given by the parent, for example, via a \l {Layout::fillWidth} {Layout.fillWidth}.

   \since 0.11.0
 */
Item {
    id: root

    /*!
       \brief The delegates inside the Form card.

       This is where you should add new Form delegates.
     */
    default property alias delegates: internalColumn.data

    /*!
       \brief The maximum width of the card.

       This can be set to a specific value to force its delegates to wrap
       instead of using the entire width of the parent.

       \default Kirigami.Units.gridUnit * 30

       \sa cardWidthRestricted
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
       Whether the card's width is being restricted.
     */
    readonly property bool cardWidthRestricted: root.width > root.maximumWidth

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    Layout.fillWidth: true

    implicitHeight: topPadding + bottomPadding + internalColumn.implicitHeight + rectangle.borderWidth * 2

    Kirigami.ShadowedRectangle {
        id: rectangle

        readonly property real borderWidth: 1
        readonly property bool isDarkColor: {
            const temp = Qt.darker(Kirigami.Theme.backgroundColor, 1);
            return temp.a > 0 && getDarkness(Kirigami.Theme.backgroundColor) >= 0.4;
        }

        // only have card radius if it isn't filling the entire width
        radius: root.cardWidthRestricted ? Kirigami.Units.cornerRadius : 0
        color: Kirigami.Theme.backgroundColor

        function getDarkness(background: color): real {
            // Thanks to Gojir4 from the Qt forum
            // https://forum.qt.io/topic/106362/best-way-to-set-text-color-for-maximum-contrast-on-background-color/
            var temp = Qt.darker(background, 1);
            var a = 1 - ( 0.299 * temp.r + 0.587 * temp.g + 0.114 * temp.b);
            return a;
        }

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right

            leftMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : -1
            rightMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : -1
        }

        border {
            color: isDarkColor ? Qt.darker(Kirigami.Theme.backgroundColor, 1.2) : Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.15)
            width: borderWidth
        }

        shadow {
            size: isDarkColor ? Kirigami.Units.smallSpacing : Kirigami.Units.largeSpacing
            color: Qt.alpha(Kirigami.Theme.textColor, 0.10)
        }

        ColumnLayout {
            id: internalColumn

            // used in FormDelegateBackground to determine whether to round corners of the background
            readonly property bool _roundCorners: root.cardWidthRestricted

            spacing: 0

            // add 1 to margins to account for the border (so content doesn't overlap it)
            anchors {
                fill: parent
                leftMargin: root.leftPadding + rectangle.borderWidth
                rightMargin: root.rightPadding + rectangle.borderWidth
                topMargin: root.topPadding + rectangle.borderWidth
                bottomMargin: root.bottomPadding + rectangle.borderWidth
            }
        }
    }
}
