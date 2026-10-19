// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components.templates as Templates
import "templates/private" as Private

/*!
   \qmltype RadioSelector
   \inqmlmodule org.kde.kirigamiaddons.components
   \brief A Component that allows switching between multiple options.

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
Templates.RadioSelector {
    id: root

    spacing: Kirigami.Units.smallSpacing

    delegate: Private.RadioSelectorButton {
        id: button
        selector: root

        Layout.minimumHeight: Kirigami.Units.gridUnit * 2

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
                visible: Boolean(button.icon.name || button.icon.source)
                source: button.icon.name || button.icon.source
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
    }

    Kirigami.ShadowedRectangle {
        id: marker

        x: root.leftPadding + (root.checkedButton?.x ?? 0)
        y: root.topPadding
        z: -1

        height: root.availableHeight
        width: root.checkedButton?.width ?? 0
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
