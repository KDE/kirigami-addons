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
   \qmltype FormButtonDelegate
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A Form delegate that corresponds to a clickable button.

   Use the inherited \l {AbstractButton::text} {AbstractButton.text} property to define
   the main text of the button.

   The trailing property (right-most side of the button) includes an arrow
   pointing to the right by default and cannot be overridden.

   \since 0.11.0
 */
AbstractFormDelegate {
    id: root

    /*!
       \qmlproperty string description
       \brief A label containing secondary text that appears under the
       inherited text property.

       This provides additional information shown in a faint gray color.

       This is supposed to be a short text and the API user should avoid
       making it longer than two lines.
     */
    property string description: ""

    /*!
       \qmlproperty Label descriptionItem
       \brief This property allows to override the internal description
       item with a custom component.
     */
    property alias descriptionItem: internalDescriptionItem

    /*!
       \brief This property holds an item that will be displayed to the
       left of the delegate's contents.

       \default null
     */
    property var leading: null

    /*!
       \brief This property holds the padding after the leading item.

       It is recommended to use \l {Units} {Kirigami.Units} here instead of direct values.

       \sa {Units} {Kirigami.Units}
     */
    property real leadingPadding: Kirigami.Units.largeSpacing

    /*!
       \brief This property holds an alias to the internal FormArrow.

       This allow to hide it completely or change the direction (e.g. to
       implement a collapsible section).

       \since 1.7.0
     */
    readonly property alias trailingLogo: formArrow

    focusPolicy: Qt.StrongFocus

    contentItem: RowLayout {
        spacing: 0

        Private.ContentItemLoader {
            readonly property bool _visible: root.leading && root.leading.visible
            Layout.rightMargin: _visible ? root.leadingPadding : 0
            implicitHeight: _visible ? root.leading.implicitHeight : 0
            implicitWidth: _visible ? root.leading.implicitWidth : 0
            contentItem: root.leading
        }

        Kirigami.Icon {
            visible: root.icon.name !== ""
            source: root.icon.name
            color: root.icon.color
            Layout.rightMargin: (root.icon.name !== "") ? Private.FormCardUnits.horizontalSpacing : 0
            implicitWidth: (root.icon.name !== "") ? root.icon.width : 0
            implicitHeight: (root.icon.name !== "") ? root.icon.height : 0
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Label {
                Layout.fillWidth: true
                text: root.text
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                maximumLineCount: 2
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                Accessible.ignored: true // base class sets this text on root already
            }

            Label {
                id: internalDescriptionItem
                Layout.fillWidth: true
                text: root.description
                color: Kirigami.Theme.disabledTextColor
                elide: Text.ElideRight
                visible: root.description !== ""
                wrapMode: Text.Wrap
                Accessible.ignored: !visible
            }
        }

        FormArrow {
            id: formArrow

            Layout.leftMargin: Kirigami.Units.smallSpacing
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            direction: Qt.RightArrow
            visible: root.background.visible
        }
    }

    Accessible.onPressAction: action ? action.trigger() : root.clicked()
}
