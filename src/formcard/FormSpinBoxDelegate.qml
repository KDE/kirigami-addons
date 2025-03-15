// Copyright 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import 'private' as Private

/*!
   \qmltype FormSpinBoxDelegate
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A Form delegate that corresponds to a spinbox.

   This component is used to select a number. By default, the spinbox will be
   initialized with a minimum of 0 and a maximum of 99.

   Example code:
   \qml
   FormCard.FormCardHeader {
       title: "Information"
   }

   FormCard.FormCard {
       FormCard.FormSpinBoxDelegate {
           label: "Amount"
       }
   }
   \endqml

   \since 0.11.0
 */
AbstractFormDelegate {
    id: root

    /*!
       \brief A label that appears above the spinbox.
     */
    required property string label

    /*!
       \qmlproperty int value
       \brief This property holds the \l {SpinBox::value} {value} of the internal spinbox.
     */
    property alias value: spinbox.value

    /*!
       \qmlproperty int from
       \brief This property holds the \l {SpinBox::from} {from} of the internal spinbox.
     */
    property alias from: spinbox.from

    /*!
       \qmlproperty int to
       \brief This property holds the \l {SpinBox::to} {to} of the internal spinbox.
     */
    property alias to: spinbox.to

    /*!
       \qmlproperty int stepSize
       \brief This property holds the \l {SpinBox::stepSize} {stepSize} of the internal spinbox.
     */
    property alias stepSize: spinbox.stepSize

    /*!
       \qmlproperty function textFromValue
       \brief This property holds the \l {SpinBox::textFromValue} {textFromValue} of the internal spinbox.
     */
    property alias textFromValue: spinbox.textFromValue

    /*!
       \qmlproperty function valueFromText
       \brief This property holds the \l {SpinBox::valueFromText} {valueFromText} of the internal spinbox.
     */
    property alias valueFromText: spinbox.valueFromText

    /*!
       \qmlproperty string displayText
       \brief This property holds the \l {SpinBox::displayText} {displayText} of the internal spinbox.
     */
    property alias displayText: spinbox.displayText

    /*!
       \qmlproperty Validator validator
       \brief This property holds the \l {SpinBox::validator} {validator} of the internal spinbox.
     */
    property alias validator: spinbox.validator

    /*!
       \qmlproperty var status
       \brief This property holds the current type of status displayed in
       the text field.

       Depending on the status of the text field, the statusMessage property
       will look different.

       Accepted values:
       \value Kirigami.MessageType.Information
       \value Kirigami.MessageType.Positive
       \value Kirigami.MessageType.Warning
       \value Kirigami.MessageType.Error

       \sa Kirigami.MessageType
     */
    property var status: Kirigami.MessageType.Information

    /*!
       This property holds the current status message of the text field.
       \default ""
     */
    property string statusMessage: ""

    /*!
       Increases the value by stepSize, or 1 if stepSize is not defined.
     */
    function increase() {
        spinbox.increase();
    }

    /*!
       Decreases the value by stepSize, or 1 if stepSize is not defined.
     */
    function decrease() {
        spinbox.decrease();
    }

    focusPolicy: Kirigami.Settings.isMobile ? Qt.StrongFocus : Qt.NoFocus

    onClicked: spinbox.forceActiveFocus()
    background: null

    contentItem: ColumnLayout {
        spacing: Private.FormCardUnits.verticalSpacing

        RowLayout {
            Layout.fillWidth: true
            spacing: 0

            QQC2.Label {
                Layout.fillWidth: true
                text: label
                elide: Text.ElideRight
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                wrapMode: Text.Wrap
                maximumLineCount: 2
            }

            Private.SpinButton {
                onClicked: root.decrease()
                icon.name: 'arrow-down'
                visible: Kirigami.Settings.isMobile

                isStart: true
                isEnd: false
            }

            QQC2.Pane {
                focusPolicy: Qt.NoFocus
                topPadding: 0
                bottomPadding: 0
                leftPadding: Kirigami.Units.largeSpacing * 2
                rightPadding: Kirigami.Units.largeSpacing * 2
                visible: Kirigami.Settings.isMobile
                contentItem: QQC2.Label {
                    verticalAlignment: Text.AlignVCenter
                    height: Kirigami.Units.gridUnit * 2
                    text: root.textFromValue(root.value, root.locale)
                }
                background: Item {
                    implicitHeight: Kirigami.Units.gridUnit * 2
                    Rectangle {
                        color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, Kirigami.Theme.frameContrast)
                        height: 1
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                        }
                    }

                    Rectangle {
                        color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, Kirigami.Theme.frameContrast)
                        height: 1
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                    }
                }
            }

            Private.SpinButton {
                onClicked: root.increase()
                visible: Kirigami.Settings.isMobile
                icon.name: 'arrow-up'

                isStart: false
                isEnd: true
            }
        }

        QQC2.SpinBox {
            id: spinbox
            Layout.fillWidth: true
            visible: !Kirigami.Settings.isMobile
            locale: root.locale
        }

        Kirigami.InlineMessage {
            id: formErrorHandler
            visible: root.statusMessage.length > 0
            Layout.topMargin: visible ? Kirigami.Units.smallSpacing : 0
            Layout.fillWidth: true
            text: root.statusMessage
            type: root.status
        }
    }
}
