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
   \qmltype FormSwitchDelegate
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A Form delegate that corresponds to a switch.

   This component is used to create a purely on/off toggle for a single
   setting.

   Use the inherited \l {AbstractButton::text} {AbstractButton.text} property to define
   the main text of the button.

   If you need an on/off/tristate toggle, use a FormCheckDelegate instead.

   If you need multiple values for the same setting, use a
   FormComboBoxDelegate instead.

   If you need multiple toggles for the same setting, use a FormRadioDelegate
   instead.

   \since 0.11.0

   \sa AbstractButton
   \sa FormCheckDelegate
   \sa FormComboBoxDelegate
   \sa FormRadioDelegate
 */
T.SwitchDelegate {
    id: root

    /*!
       \brief A label containing secondary text that appears under the inherited text property.

       This provides additional information shown in a faint gray color.
     */
    property string description: ""

    /*!
       \brief This property holds an item that will be displayed
       to the left of the delegate's contents.
     */
    property var leading: null

    /*!
       \brief This property holds the padding after the leading item.
     */
    property real leadingPadding: Kirigami.Units.smallSpacing

    /*!
       \brief This property holds an item that will be displayed
       to the right of the delegate's contents.
     */
    property var trailing: null

    /*!
       \brief This property holds the padding before the trailing item.
     */
    property real trailingPadding: Kirigami.Units.smallSpacing

    horizontalPadding: Private.FormCardUnits.horizontalPadding
    verticalPadding: Private.FormCardUnits.verticalPadding

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    focusPolicy: Qt.StrongFocus
    hoverEnabled: true
    background: FormDelegateBackground { control: root }

    icon {
        width: Kirigami.Units.iconSizes.smallMedium
        height: Kirigami.Units.iconSizes.smallMedium
    }

    Layout.fillWidth: true

    Accessible.description: root.description
    Accessible.role: Accessible.CheckBox
    Accessible.onPressAction: switchItem.toggle()
    Accessible.onToggleAction: switchItem.toggle()

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
            visible: root.icon.name.length > 0 || root.icon.source.toString().length > 0
            source: root.icon.name.length > 0 ? root.icon.name : root.icon.source
            color: root.icon.color
            Layout.rightMargin: visible ? Private.FormCardUnits.horizontalSpacing : 0
            implicitWidth: visible ? root.icon.width : 0
            implicitHeight: visible ? root.icon.height : 0
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Private.FormCardUnits.verticalSpacing

            Controls.Label {
                Layout.fillWidth: true
                text: root.text
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                maximumLineCount: 2
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                Accessible.ignored: true
            }

            Controls.Label {
                visible: root.description !== ""
                Layout.fillWidth: true
                text: root.description
                wrapMode: Text.Wrap
                color: Kirigami.Theme.disabledTextColor
                Accessible.ignored: true
            }
        }

        Controls.Switch {
            id: switchItem
            focusPolicy: Qt.NoFocus // provided by delegate
            Layout.leftMargin: Private.FormCardUnits.horizontalSpacing

            enabled: root.enabled
            checked: root.checked

            spacing: 0
            contentItem: null

            topPadding: 0
            leftPadding: 0
            rightPadding: 0
            bottomPadding: 0

            onToggled: root.toggled()
            onClicked: root.clicked()
            onPressAndHold: root.pressAndHold()
            onDoubleClicked: root.doubleClicked()

            onCheckedChanged: {
                root.checked = checked;
                checked = Qt.binding(() => root.checked);
            }

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
}
