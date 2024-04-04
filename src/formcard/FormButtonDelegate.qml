/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami 2.19 as Kirigami
import org.kde.kirigami.delegates as KirigamiDelegates

import "private" as Private

/**
 * @brief A Form delegate that corresponds to a clickable button.
 *
 * Use the inherited QtQuick.Controls.AbstractButton.text property to define
 * the main text of the button.
 *
 * The trailing property (right-most side of the button) includes an arrow
 * pointing to the right by default and cannot be overridden.
 *
 * @since KirigamiAddons 0.11.0
 *
 * @inherit AbstractFormDelegate
 */
AbstractFormDelegate {
    id: root

    /**
     * @brief A label containing secondary text that appears under the
     * inherited text property.
     *
     * This provides additional information shown in a faint gray color.
     *
     * This is supposed to be a short text and the API user should avoid
     * making it longer than two lines.
     */
    property string description: ""

    /**
     * @brief This property holds an item that will be displayed to the
     * left of the delegate's contents.
     *
     * default: `null`
     */
    property var leading: null

    spacing: Kirigami.Units.smallSpacing

    focusPolicy: Qt.StrongFocus

    contentItem: RowLayout {
        spacing: root.spacing

        Private.ContentItemLoader {
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
            implicitWidth: (root.icon.name !== "") ? root.icon.width : 0
            implicitHeight: (root.icon.name !== "") ? root.icon.height : 0
        }

        KirigamiDelegates.TitleSubtitle {
            Layout.fillWidth: true

            title: root.text
            subtitle: root.description
            color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
            subtitleColor: Kirigami.Theme.disabledTextColor
            wrapMode: Text.Wrap
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
