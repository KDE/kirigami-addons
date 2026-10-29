// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami.platform as Platform
import org.kde.kirigami.primitives as Primitives
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

    spacing: Platform.Units.smallSpacing

    _delegate: Private.RadioSelectorButton {
        id: button
        selector: root

        Layout.minimumHeight: Platform.Units.gridUnit * 2

        icon {
            width: Platform.Units.iconSizes.sizeForLabels
            height: Platform.Units.iconSizes.sizeForLabels
        }

        background: Rectangle {
            radius: Platform.Units.cornerRadius
            color: Platform.Theme.textColor
            opacity: Platform.Settings.hasTransientTouchInput ? 0 : ( button.hovered ? 0.1 : 0)

            Behavior on opacity {
                PropertyAnimation {
                    duration: Platform.Units.shortDuration
                    easing.type: Easing.InOutCubic
                }
            }
        }

        contentItem: RowLayout {
            Item {
                Layout.leftMargin: icon.visible ? Platform.Units.smallSpacing : Platform.Units.largeSpacing
                Layout.fillWidth: true
            }

            Primitives.Icon {
                id: icon

                visible: button.icon.name.length > 0 || button.icon.source.length > 0
                source: button.icon.name || button.icon.source
                implicitHeight: button.icon.height
                implicitWidth: button.icon.width
            }

            QQC2.Label {
                Layout.alignment: Qt.AlignVCenter

                color: Platform.Theme.textColor
                text: button.text

                Accessible.ignored: true
            }

            Item {
                Layout.fillWidth: true
                Layout.rightMargin: icon.visible ? Platform.Units.smallSpacing : Platform.Units.largeSpacing
            }
        }
    }

    Primitives.ShadowedRectangle {
        id: marker

        x: root.leftPadding + (root._checkedButton?.x ?? 0)
        y: root.topPadding
        z: -1

        height: root.availableHeight
        width: root._checkedButton?.width ?? 0
        radius: Platform.Units.cornerRadius

        color: Qt.alpha(Platform.Theme.highlightColor, 0.2)
        border {
            width: 1
            color: Platform.Theme.highlightColor
        }
        shadow {
            size: 7
            yOffset: 3
            color: Qt.rgba(0, 0, 0, 0.15)
        }

        Behavior on x {
            PropertyAnimation {
                id: x_anim

                duration: Platform.Units.longDuration
                easing.type: Easing.InOutCubic
            }
        }

        Behavior on width {
            PropertyAnimation {
                id: width_anim

                duration: Platform.Units.longDuration
                easing.type: Easing.InOutCubic
            }
        }
    }
}
