/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

import "private" as Private

/*!
   \qmltype FormSliderDelegate
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A form delegate for selecting a value with a slider.

   Use \l valueText to show a formatted value beside the label. Handle
   \l moved to react only to changes made by the user.

   \qml
   FormCard.FormSliderDelegate {
       id: transparencyDelegate
       label: i18n("Past event transparency")
       from: 0
       to: 1
       stepSize: 0.05
       value: Config.pastEventsTransparencyLevel
       valueText: i18n("%1%", Math.round(value * 100))
       onMoved: Config.pastEventsTransparencyLevel = value
   }
   \endqml

   \since 1.15.0
 */
AbstractFormDelegate {
    id: root

    /*!
       \brief The label shown above the slider.
     */
    required property string label

    /*!
       \brief Optional text shown beside the label, such as a formatted value.
       \default ""
     */
    property string valueText: ""

    /*!
       \brief Secondary text shown below the slider.
       \default ""
     */
    property string description: ""

    /*!
       \brief An item shown before the slider, such as an icon.
       \default null
     */
    property Item leading: null

    /*!
       \brief An item shown after the slider, such as an icon.
       \default null
     */
    property Item trailing: null

    /*!
       \qmlproperty real value
       \brief The \l {Slider::value} {value} of the slider.
     */
    property alias value: slider.value

    /*!
       \qmlproperty real from
       \brief The \l {Slider::from} {minimum value} of the slider.
     */
    property alias from: slider.from

    /*!
       \qmlproperty real to
       \brief The \l {Slider::to} {maximum value} of the slider.
     */
    property alias to: slider.to

    /*!
       \qmlproperty real stepSize
       \brief The \l {Slider::stepSize} {step size} of the slider.
     */
    property alias stepSize: slider.stepSize

    /*!
       \brief Emitted when the user moves the slider with a mouse, touch, or keyboard.
     */
    signal moved()

    focusPolicy: Qt.NoFocus
    background: null

    contentItem: ColumnLayout {
        spacing: Private.FormCardUnits.verticalSpacing

        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            QQC2.Label {
                Layout.fillWidth: true
                text: root.label
                elide: Text.ElideRight
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                wrapMode: Text.Wrap
                maximumLineCount: 2
                Accessible.ignored: true
            }

            QQC2.Label {
                visible: root.valueText.length > 0
                text: root.valueText
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                Accessible.ignored: true
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            LayoutItemProxy {
                target: root.leading
                visible: target && target.visible
            }

            QQC2.Slider {
                id: slider
                objectName: "formSlider"

                Layout.fillWidth: true
                Accessible.name: root.label
                Accessible.description: root.description
                onMoved: root.moved()
            }

            LayoutItemProxy {
                target: root.trailing
                visible: target && target.visible
            }
        }

        QQC2.Label {
            Layout.fillWidth: true
            visible: root.description.length > 0
            text: root.description
            color: Kirigami.Theme.disabledTextColor
            wrapMode: Text.Wrap
            Accessible.ignored: true
        }
    }
}
