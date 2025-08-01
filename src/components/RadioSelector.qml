// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

/*!
   \qmltype RadioSelector
   \inqmlmodule org.kde.kirigamiaddons.components
   \brief A Component that allows sitching between multiple options.
   Example:
   \qml
   Components.RadioSelector {
     consistentWidth: false
     actions: [
         Kirigami.Action {
             text: i18nc("@option:radio", "Week")
             icon.name: "view-calendar-week-symbolic"
         },
         Kirigami.Action {
             text: i18nc("@option:radio", "3 Days")
             icon.name: "view-calendar-upcoming-days-symbolic"
         },
         Kirigami.Action {
             text: i18nc("@option:radio", "1 Day")
             icon.name: "view-calendar-day-symbolic"
         }
     ]
   }
   \endqml
   \since 1.6.0.
*/
Item {
    id: root

    /*!
       \qmlproperty list<Action> actions
       \brief This property holds a list of actions, each holding one of the
       options.
     */
    property list<T.Action> actions

    /*!
       \brief This property holds whether all the items should have the same
       width.
       \default false
     */
    property bool consistentWidth: false

    /*!
       \brief This property holds the currently selected option.

       By default, it's the first actions or -1 if no actions is set.
     */
    property int selectedIndex: actions.length > 0 ? 0 : -1

    Layout.fillWidth: consistentWidth
    Layout.minimumWidth: switchLayout.implicitWidth

    implicitHeight: switchLayout.implicitHeight

    onSelectedIndexChanged: if (selectedIndex >= 0 && repeater.count < selectedIndex && !repeater.childAt(selectedIndex).checked) {
        repeater.childAt(selectedIndex).clicked();
    }

    QQC2.ButtonGroup {
        id: buttonGroup

        buttons: switchLayout.children.filter((child) => child !== repeater)
    }

    RowLayout {
        id: switchLayout
        uniformCellSizes: root.consistentWidth

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
                Layout.minimumWidth: button.implicitWidth
                Layout.minimumHeight: Kirigami.Units.gridUnit * 2

                checkable: true
                action: modelData
                text: modelData.text
                icon.name: modelData.icon.name
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

                    QQC2.Label {
                        Layout.alignment: Qt.AlignVCenter

                        font.bold: button.checked
                        color: Kirigami.Theme.textColor
                        text: button.text

                        Behavior on font.bold {
                            PropertyAnimation {
                                duration: Kirigami.Units.longDuration
                                easing.type: Easing.InOutCubic
                            }
                        }

                        Accessible.ignored: true
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.rightMargin: Kirigami.Units.largeSpacing
                    }
                }

                onClicked: {
                    button.checked = true;
                    root.selectedIndex = index;
                }

                Component.onCompleted: if (index === root.selectedIndex) {
                    button.checked = true;
                    root.selectedIndex = index;
                }
            }
        }
    }

    Kirigami.ShadowedRectangle {
        id: marker

        x: buttonGroup.checkedButton.x
        y: switchLayout.y
        z: switchLayout.z - 1

        height: switchLayout.implicitHeight
        width: buttonGroup.checkedButton.width
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
