// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
//
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.20 as Kirigami

/**
 * This component is a button that can be displayed at the bottom of a page.
 *
 * @code{.qml}
 * import org.kde.kirigamiaddons.components 1.0 as Components
 *
 * Kirigami.ScrollablePage {
 *     ListView {
 *         model: []
 *         delegate: QQC2.ItemDelegate { ... }
 *
 *         Components.FloatingButton {
 *             anchors {
 *                 right: parent.right
 *                 rightMargin: Kirigami.Units.largeSpacing
 *                 bottom: parent.bottom
 *                 bottomMargin: Kirigami.Units.largeSpacing
 *             }
 *
 *             action: Kirigami.Action {
 *                 text: "Add new item"
 *                 icon.name: "list-add"
 *             }
 *         }
 *     }
 *}
 * @endcode
 *
 * @since Kirigami Addons 0.11
 */
QQC2.Button {
    id: root

    height: Math.round(Kirigami.Units.gridUnit * 2.5)
    width: height

    background: Kirigami.ShadowedRectangle{
        Kirigami.Theme.inherit: false
        Kirigami.Theme.colorSet: Kirigami.Theme.Window

        color: if (parent.down || parent.visualFocus) {
            Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.6)
        } else if (parent.hovered) {
            Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.8)
        } else {
            Kirigami.Theme.backgroundColor
        }

        radius: Kirigami.Units.largeSpacing
        border {
            width: 1
            color: if (parent.down || parent.visualFocus) {
                Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.4)
            } else if(parent.hovered) {
                Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.6)
            } else{
                Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.2)
            }
        }

        shadow {
            size: 10
            xOffset: 2
            yOffset: 2
            color: Qt.rgba(0, 0, 0, 0.2)
        }

        Behavior on color {
            ColorAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutCubic
            }
        }

        Behavior on border.color {
            ColorAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutCubic
            }
        }
    }

    contentItem: Item {
        Kirigami.Icon {
            implicitHeight: if (root.icon.height) {
                root.icon.height
            } else {
                Kirigami.Units.iconSizes.medium
            }
            implicitWidth: if (root.icon.width) {
                root.icon.width
            } else {
                Kirigami.Units.iconSizes.medium
            }
            source: if (root.icon.name) {
                root.icon.name
            } else {
                root.icon.source
            }
            anchors.centerIn: parent
        }
    }
}
