/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

import "private" as Private

/**
 * @brief A Form delegate that corresponds to a radio button.
 *
 * This component is used for creating multiple on/off toggles for the same
 * setting. In other words, by grouping multiple radio buttons under the same
 * parent, only one of the radio buttons should be checkable and applied to a
 * setting.
 *
 * Use the inherited QtQuick.Controls.AbstractButton.text property to define
 * the main text of the radio button.
 *
 * If you need multiple values for the same setting, use a
 * FormComboBoxDelegate instead.
 *
 * If you need a purely on/off toggle for a single setting, use a
 * FormSwitchDelegate instead.
 *
 * If you need an on/off/tristate toggle, use a FormCheckDelegate instead.
 *
 * @since KirigamiAddons 0.11.0
 *
 * @see QtQuick.Controls.AbstractButton
 * @see FormSwitchDelegate
 * @see FormCheckDelegate
 * @see FormComboBoxDelegate
 *
 * @inherit QtQuick.Controls.RadioDelegate
 */
T.RadioDelegate {
    id: root

    /**
     * @brief A label containing secondary text that appears under the
     * inherited text property.
     *
     * This provides additional information shown in a faint gray color.
     */
    property string description: ""

    /**
     * @brief This property holds an item that will be displayed to the left of the delegate's contents.
     */
    property var leading: null

    /**
     * @brief This property holds the padding after the leading item.
     */
    property real leadingPadding: Kirigami.Units.smallSpacing

    /**
     * @brief This property holds an item that will be displayed after the
     * delegate's contents.
     */
    property var trailing: null

    /**
     * @brief This property holds the padding before the trailing item.
     */
    property real trailingPadding: Kirigami.Units.smallSpacing

    leftPadding: Kirigami.Units.gridUnit
    topPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    bottomPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    rightPadding: Kirigami.Units.gridUnit

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    focusPolicy: Qt.StrongFocus
    hoverEnabled: true
    background: FormDelegateBackground { control: root }

    Layout.fillWidth: true

    contentItem: RowLayout {
        spacing: 0

        Private.ContentItemLoader {
            Layout.rightMargin: visible ? root.leadingPadding : 0
            visible: root.leading
            implicitHeight: visible ? root.leading.implicitHeight : 0
            implicitWidth: visible ? root.leading.implicitWidth : 0
            contentItem: root.leading
        }

        Controls.RadioButton {
            id: radioButtonItem
            focusPolicy: Qt.NoFocus // provided by delegate
            Layout.rightMargin: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing

            enabled: root.enabled
            checked: root.checked

            onToggled: root.toggled()
            onClicked: root.clicked()
            onPressAndHold: root.pressAndHold()
            onDoubleClicked: root.doubleClicked()

            onCheckedChanged: {
                root.checked = checked;
                checked = Qt.binding(() => root.checked);
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            Controls.Label {
                Layout.fillWidth: true
                text: root.text
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                maximumLineCount: 2
            }

            Controls.Label {
                visible: root.description !== ""
                Layout.fillWidth: true
                text: root.description
                color: Kirigami.Theme.disabledTextColor
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


