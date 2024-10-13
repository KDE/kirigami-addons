// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

/**
* @brief A Component that allows sitching between multiple options.
*
* Example:
*
* @code{.qml}
* Components.RadioSelector {
*   consistentWidth: false
*   actions: [
*       Kirigami.Action {
*           text: i18n("Week")
*           icon.name:  "view-calendar-week"
*       },
*       Kirigami.Action {
*           text: i18n("3 Days")
*           icon.name:  "view-calendar-upcoming-days"
*       },
*       Kirigami.Action {
*           text: i18n("1 Day")
*           icon.name:  "view-calendar-day"
*       }
*   ]
* }
* @endcode
*/
Item {
    id: root

    /**
     * @brief This property holds a list of actions, each holding one of the options.
     */
    property list<T.Action> actions

    /**
     * @brief This property holds whether all the items should have the same width.
     */
    property bool consistentWidth: false

    /**
     * @brief This property holds which option will be selected by default.
     */
    property int defaultIndex: 0

    /**
     * @brief This property holds the currently selected option.
     */
    readonly property int selectedIndex: marker.selectedIndex

    Layout.minimumWidth: consistentWidth ? 0 : switchLayout.implicitWidth
    Layout.fillWidth: consistentWidth

    implicitHeight: switchLayout.implicitHeight

    QQC2.ButtonGroup {
        buttons: switchLayout.children
    }

    RowLayout {
        id: switchLayout

        anchors {
            top: root.top
            left: root.left
            right: root.right
        }

        Repeater {
            id: repeater

            model: actions
            delegate: QQC2.ToolButton {
                id: button

                required property T.Action modelData
                required property int index

                Layout.fillWidth: true
                Layout.preferredWidth: root.consistentWidth ? (root.width/repeater.count)-(switchLayout.spacing/repeater.count-1) : button.implicitWidth

                checkable: true
                action: modelData
                visible: !(modelData instanceof Kirigami.Action) || modelData.visible

                icon {
                    width: Kirigami.Units.iconSizes.sizeForLabels
                    height: Kirigami.Units.iconSizes.sizeForLabels
                }

                background: Rectangle {
                    radius: Kirigami.Units.cornerRadius
                    color: Kirigami.Theme.textColor
                    opacity: Kirigami.Settings.hasTransientTouchInput ? 0 : ( button.hovered ? 0.1 : 0)

                    Behavior on opacity {
                        PropertyAnimation {
                            duration: Kirigami.Units.shortDuration
                            easing.type: Easing.InOutCubic
                        }
                    }
                }

                contentItem: RowLayout {
                    Item {
                        Layout.leftMargin: icon.visible ? Kirigami.Units.smallSpacing : Kirigami.Units.largeSpacing
                        Layout.fillWidth: true
                    }

                    Kirigami.Icon {
                        id: icon

                        Layout.topMargin: (container.height - label.height) / 2
                        Layout.bottomMargin: (container.height - label.height) / 2

                        color: button.checked ? Kirigami.Theme.hoverColor : Kirigami.Theme.textColor
                        visible: button.icon.name
                        source: button.icon.name
                        implicitHeight: button.icon.height
                        implicitWidth: button.icon.width
                        Behavior on color {
                            PropertyAnimation {
                                duration: Kirigami.Units.longDuration
                                easing.type: Easing.InOutCubic
                            }
                        }
                    }

                    Item {
                        Layout.topMargin: (container.height - label.height) / 2
                        Layout.bottomMargin: (container.height - label.height) / 2

                        Layout.preferredWidth: fakeLabel.width
                        Layout.preferredHeight: fakeLabel.height

                        QQC2.Label {
                            id: fakeLabel

                            anchors.centerIn: parent
                            font.bold: true
                            color: Kirigami.Theme.hoverColor

                            opacity: button.checked ? 1 : 0
                            text: button.text
                            Behavior on opacity {
                                PropertyAnimation {
                                    duration: Kirigami.Units.longDuration
                                    easing.type: Easing.InOutCubic
                                }
                            }
                        }
                        QQC2.Label {
                            id: label

                            anchors.centerIn: parent
                            color: Kirigami.Theme.textColor

                            opacity: button.checked ? 0 : 1
                            text: button.text
                            Behavior on opacity {
                                PropertyAnimation {
                                    duration: Kirigami.Units.longDuration
                                    easing.type: Easing.InOutCubic
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.rightMargin: Kirigami.Units.largeSpacing
                    }
                }

                onClicked: {
                    marker.width = Qt.binding(function() { return width; })
                    marker.x = Qt.binding(function() { return x; });
                    modelData.triggered();
                    marker.selectedIndex = index;

                }
                Component.onCompleted: if (index === defaultIndex ) {
                    marker.width = Qt.binding(function() { return width; });
                    marker.x = Qt.binding(function() { return x; });
                    button.checked = true;
                }
            }
        }
    }

    Kirigami.ShadowedRectangle {
        id: marker

        property int selectedIndex: root.defaultIndex

        y: switchLayout.y
        z: switchLayout.z - 1
        height: switchLayout.implicitHeight
        radius: Kirigami.Units.cornerRadius
        color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.8)
        border {
            width: 1
            color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.5)
        }
        shadow {
            size: 7
            yOffset: 3
            color: Qt.rgba(0, 0, 0, 0.15)
        }
        Behavior on x {
            PropertyAnimation {
                id: x_anim

                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutCubic
            }
        }

        Behavior on width {
            PropertyAnimation {
                id: width_anim

                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutCubic
            }
        }
    }
}
