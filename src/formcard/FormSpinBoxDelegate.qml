// Copyright 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import 'private' as P

/**
 * @brief A Form delegate that corresponds to a spinbox.
 *
 * This component is used to select a number. By default, the spinbox will be
 * initialized with a minimum of 0 and a maximum of 99.
 *
 * Example code:
 * ```qml
 * FormCard.FormCardHeader {
 *     title: "Information"
 * }
 *
 * FormCard.FormCard {
 *     FormCard.FormSpinBoxDelegate {
 *         label: "Amount"
 *     }
 * }
 * ```
 *
 * @since KirigamiAddons 0.11.0
 *
 * @inherit AbstractFormDelegate
 */
AbstractFormDelegate {
    id: root

    /**
     * @brief A label that appears above the spinbox.
     *
     */
    required property string label

    /**
     * @brief This property holds the `value` of the internal spinbox.
     */
    property alias value: spinbox.value

    /**
     * @brief This property holds the `from` of the internal spinbox.
     */
    property alias from: spinbox.from

    /**
     * @brief This property holds the `to` of the internal spinbox.
     */
    property alias to: spinbox.to

    /**
     * @brief This property holds the `stepSize` of the internal spinbox.
     */
    property alias stepSize: spinbox.stepSize

    /**
     * @brief This property holds the `textFromValue` of the internal spinbox.
     */
    property alias textFromValue: spinbox.textFromValue

    /**
     * @brief This property holds the `valueFromText` of the internal spinbox.
     */
    property alias valueFromText: spinbox.valueFromText

    /**
     * @brief This property holds the `displayText` of the internal spinbox.
     */
    property alias displayText: spinbox.displayText

    /**
     * @brief This property holds the `validator` of the internal spinbox.
     */
    property alias validator: spinbox.validator

    /**
     * @brief This property holds the current type of status displayed in
     * the text field.
     *
     * Depending on the status of the text field, the statusMessage property
     * will look different
     *
     * Accepted values:
     * - Kirigami.MessageType.Information
     * - Kirigami.MessageType.Positive
     * - Kirigami.MessageType.Warning
     * - Kirigami.MessageType.Error
     *
     * @see Kirigami.MessageType
     */
    property var status: Kirigami.MessageType.Information

    /**
     * This property holds the current status message of the text field.
     */
    property string statusMessage: ""

    /**
     * Increases the value by stepSize, or 1 if stepSize is not defined.
     */
    function increase() {
        spinbox.increase();
    }

    /**
     * Decreases the value by stepSize, or 1 if stepSize is not defined.
     */
    function decrease() {
        spinbox.decrease();
    }

    focusPolicy: Kirigami.Settings.isMobile ? Qt.StrongFocus : Qt.NoFocus

    onClicked: spinbox.forceActiveFocus()
    background: null

    contentItem: ColumnLayout {
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

            P.SpinButton {
                onClicked: root.decrease()
                icon.name: 'list-remove-symbolic'
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

            P.SpinButton {
                onClicked: root.increase()
                visible: Kirigami.Settings.isMobile
                icon.name: 'list-add'

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
