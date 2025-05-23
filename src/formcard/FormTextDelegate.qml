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
   \qmltype FormTextDelegate
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A Form delegate that corresponds to a text label and a description.

   This component is used to create primary text with the inherited
   \l {AbstractButton::text} {AbstractButton.text} property, with an optional
   description that serves as secondary text/subtitle.

   If you need just a secondary text component, use a FormSectionText
   instead.

   \since 0.11.0

   \sa FormSectionText
   \sa AbstractButton
 */
AbstractFormDelegate {
    id: root

    /*!
       \brief A label containing secondary text that appears under the
       inherited text property.

       This provides additional information shown in a faint gray color.
       \default ""
     */
    property string description: ""

    /*!
       \qmlproperty Label descriptionItem
       \brief This property allows for access to the description label item.
     */
    property alias descriptionItem: internalDescriptionItem

    /*!
       \qmlproperty Label textItem
       \brief This property holds allows for access to the text label item.
     */
    property alias textItem: internalTextItem

    /*!
       \brief This property holds an item that will be displayed before
       the delegate's contents.
       \default null
     */
    property var leading: null

    /*!
       \brief This property holds the padding after the leading item.
       \default Kirigami.Units.smallSpacing
     */
    property real leadingPadding: Kirigami.Units.smallSpacing

    /*!
       \brief This property holds an item that will be displayed after
       the delegate's contents.
       \default null
     */
    property var trailing: null

    /*!
       \brief This property holds the padding before the trailing item.
       \default Kirigami.Units.smallSpacing
     */
    property real trailingPadding: Kirigami.Units.smallSpacing

    /*!
       This signal is emitted when the \a link is activated.
     */
    signal linkActivated(string link)

    focusPolicy: Qt.NoFocus

    background: null

    contentItem: RowLayout {
        spacing: 0

        Private.ContentItemLoader {
            Layout.rightMargin: visible ? root.leadingPadding : 0
            visible: root.leading
            implicitHeight: visible ? root.leading.implicitHeight : 0
            implicitWidth: visible ? root.leading.implicitWidth : 0
            contentItem: root.leading
        }

        Kirigami.Icon {
            visible: root.icon.name !== ""
            source: root.icon.name
            color: root.icon.color
            Layout.rightMargin: (root.icon.name !== "") ? Private.FormCardUnits.horizontalSpacing : 0
            implicitWidth: (root.icon.name !== "") ? Kirigami.Units.iconSizes.smallMedium : 0
            implicitHeight: (root.icon.name !== "") ? Kirigami.Units.iconSizes.smallMedium : 0
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Label {
                id: internalTextItem
                Layout.fillWidth: true
                text: root.text
                elide: Text.ElideRight
                onLinkActivated: root.linkActivated(link)
                visible: root.text
                Accessible.ignored: true // base class sets this text on root already
            }

            Label {
                id: internalDescriptionItem
                Layout.fillWidth: true
                text: root.description
                color: Kirigami.Theme.disabledTextColor
                visible: root.description !== ""
                onLinkActivated: root.linkActivated(link)
                wrapMode: Text.Wrap
            }
        }

        Private.ContentItemLoader {
            Layout.leftMargin: visible ? root.trailingPadding : 0
            visible: root.trailing
            implicitHeight: visible ? root.trailing.implicitHeight : 0
            implicitWidth: visible ? root.trailing.implicitWidth : 0
            contentItem: root.trailing
        }
    }
}

