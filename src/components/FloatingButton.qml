// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl\carlschwan.eu>
// SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>
//
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components.templates as Templates

/*!
   \qmltype FloatingButton
   \inqmlmodule org.kde.kirigamiaddons.components
   \brief This component is a button that can be displayed at the bottom of a page.

   \qml
   import QtQuick
   import QtQuick.Controls as QQC2
   import org.kde.kirigami as Kirigami
   import org.kde.kirigamiaddons.components as KirigamiComponents

   Kirigami.ScrollablePage {
       ListView {
           model: []
           delegate: QQC2.ItemDelegate {}

           KirigamiComponents.FloatingButton {
               anchors {
                   right: parent.right
                   bottom: parent.bottom
               }
               margins: Kirigami.Units.largeSpacing

               action: Kirigami.Action {
                   text: "Add new item"
                   icon.name: "list-add"
               }
           }
       }
   }
   \endqml

   \since 0.11
 */
Templates.FloatingButton {
    id: controlRoot

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    readonly property size __effectiveIconSize: Qt.size(
        icon.height > 0 ? icon.height : Kirigami.Units.iconSizes.medium,
        icon.width > 0 ? icon.width : Kirigami.Units.iconSizes.medium,
    )

    // Property is needed to prevent binding loops on insets
    readonly property real __padding: radius === Infinity
        ? Math.round(Math.max(__effectiveIconSize.width, __effectiveIconSize.height) * (Math.sqrt(2) - 1))
        : Kirigami.Settings.hasTransientTouchInput ? (Kirigami.Units.largeSpacing * 2) : Kirigami.Units.largeSpacing

    // Fit icon into a square bounded by a circle bounded by button
    padding: __padding

    // Set to Infinity to get extra padding for round button style.
    radius: Kirigami.Units.largeSpacing

    contentItem: Item {
        implicitWidth: controlRoot.__effectiveIconSize.width
        implicitHeight: controlRoot.__effectiveIconSize.height

        Kirigami.Icon {
            anchors.fill: parent
            color: controlRoot.icon.color
            source: controlRoot.icon.name !== "" ? controlRoot.icon.name : controlRoot.icon.source
        }
    }

    background: Item {
        Kirigami.ShadowedRectangle {
            anchors.centerIn: parent
            width: Math.min(parent.width, parent.height)
            height: width
            radius: controlRoot.radius

            shadow {
                size: 10
                xOffset: 0
                yOffset: 2
                color: Qt.rgba(0, 0, 0, 0.2)
            }

            border {
                width: 1
                color: if (controlRoot.down || controlRoot.visualFocus) {
                    Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.4)
                } else if (controlRoot.enabled && controlRoot.hovered) {
                    Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.6)
                } else {
                    Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, Kirigami.Theme.frameContrast)
                }
            }

            color: if (controlRoot.down || controlRoot.visualFocus) {
                Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.6)
            } else if (controlRoot.enabled && controlRoot.hovered) {
                Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.8)
            } else {
                Kirigami.Theme.backgroundColor
            }

            Behavior on border.color {
                ColorAnimation {
                    duration: Kirigami.Units.veryShortDuration
                }
            }

            Behavior on color {
                ColorAnimation {
                    duration: Kirigami.Units.veryShortDuration
                }
            }
        }
    }
}
