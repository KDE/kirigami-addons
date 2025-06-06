/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls as Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

import "private" as Private

/*!
   \qmltype FormCheckDelegate
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A Form delegate that corresponds to a checkbox.

   This component is used for individual settings that can be toggled on, off, or tristate, typically in conjunction with multiple other checkboxes.

   Use the inherited \l {AbstractButton::text} {AbstractButton.text} property to define the main text of the checkbox.

   If you need a purely on/off toggle for a single setting, consider using a FormSwitchDelegate.

   If you need multiple toggles for the same setting, use a FormRadioDelegate
   instead.

   If you need multiple values for the same setting, use a
   FormComboBoxDelegate instead.

   \since 0.11.0

   \sa AbstractButton
   \sa FormSwitchDelegate
   \sa FormComboBoxDelegate
   \sa FormRadioDelegate
 */
T.CheckDelegate {
    id: root

    /*!
       \brief A label containing secondary text that appears under the
       inherited text property.

       This provides additional information shown in a faint gray color.
     */
    property string description: ""

    /*!
       \brief This property holds an item that will be displayed to the left
       of the delegate's contents.
     */
    property var leading: null

    /*!
       \brief This property holds the padding after the leading item.
     */
    property real leadingPadding: Kirigami.Units.smallSpacing

    /*!
       \brief This property holds an item that will be displayed to the right
       of the delegate's contents.
     */
    property var trailing: null

    /*!
       \brief This property holds the padding before the trailing item.
     */
    property real trailingPadding: Kirigami.Units.smallSpacing

    /*!
       \qmlproperty Label descriptionItem
       \brief This property allows to override the internal description
       item with a custom component.
     */
    property alias descriptionItem: internalDescriptionItem

    icon {
        width: Kirigami.Units.iconSizes.smallMedium
        height: Kirigami.Units.iconSizes.smallMedium
    }

    horizontalPadding: Private.FormCardUnits.horizontalPadding
    verticalPadding: Private.FormCardUnits.verticalPadding

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    focusPolicy: Qt.StrongFocus
    hoverEnabled: true
    background: FormDelegateBackground { control: root }

    Layout.fillWidth: true

    contentItem: ColumnLayout {
        spacing: Private.FormCardUnits.verticalSpacing

        RowLayout {
            id: innerRowLayout

            spacing: 0

            Private.ContentItemLoader {
                Layout.rightMargin: visible ? root.leadingPadding : 0
                visible: root.leading
                implicitHeight: visible ? root.leading.implicitHeight : 0
                implicitWidth: visible ? root.leading.implicitWidth : 0
                contentItem: root.leading
            }

            Controls.CheckBox {
                id: checkBoxItem
                Layout.rightMargin: Private.FormCardUnits.horizontalSpacing
                focusPolicy: Qt.NoFocus // provided by delegate

                checkState: root.checkState
                nextCheckState: root.nextCheckState
                tristate: root.tristate

                topPadding: 0
                leftPadding: 0
                rightPadding: 0
                bottomPadding: 0

                onToggled: {
                    root.toggle();
                    root.toggled();
                }
                onClicked: root.clicked()
                onPressAndHold: root.pressAndHold()
                onDoubleClicked: root.doubleClicked()

                contentItem: null // Remove right margin
                spacing: 0

                enabled: root.enabled
                checked: root.checked

                Accessible.ignored: true
            }

            Kirigami.Icon {
                visible: root.icon.name.length > 0 || root.icon.source.toString().length > 0
                source: root.icon.name.length > 0 ? root.icon.name : root.icon.source
                color: root.icon.color
                Layout.rightMargin: visible ? Private.FormCardUnits.horizonalSpacing : 0
                implicitWidth: visible ? root.icon.width : 0
                implicitHeight: visible ? root.icon.height : 0
            }

            Controls.Label {
                text: root.text
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                maximumLineCount: 2
                Layout.fillWidth: true
                Accessible.ignored: true
            }

            Private.ContentItemLoader {
                Layout.leftMargin: visible ? root.trailingPadding : 0
                visible: root.trailing
                implicitHeight: visible ? root.trailing.implicitHeight : 0
                implicitWidth: visible ? root.trailing.implicitWidth : 0
                contentItem: root.trailing
            }
        }

        Controls.Label {
            id: internalDescriptionItem

            Layout.fillWidth: true
            text: root.description
            color: Kirigami.Theme.disabledTextColor
            visible: root.description !== ""
            wrapMode: Text.Wrap
        }
    }
}

