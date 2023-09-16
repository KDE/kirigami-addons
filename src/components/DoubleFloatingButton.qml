// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
//
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.20 as Kirigami

/**
 * This component allows to display two buttons at the bottom of a page.
 *
 * @code{.qml}
 * import org.kde.Kirigamiaddons.components 1.0 as Components
 *
 * Kirigami.ScrollablePage {
 *     ListView {
 *         model: []
 *         delegate: QQC2.ItemDelegate { ... }
 *
 *         Components.DoubleFloatingButton {
 *             anchors {
 *                 right: parent.right
 *                 rightMargin: Kirigami.Units.largeSpacing
 *                 bottom: parent.bottom
 *                 bottomMargin: Kirigami.Units.largeSpacing
 *             }
 *
 *             leadingAction: Kirigami.Action {
 *                 text: "Zoom In"
 *                 icon.name: "list-add"
 *             }
 *
 *             trailingAction: Kirigami.Action {
 *                 text: "Zoom Out"
 *                 icon.name: "list-minus"
 *             }
 *         }
 *     }
 * }
 * @endcode
 *
 * @since Kirigami Addons 0.11
 */
Kirigami.ShadowedRectangle {
    id: root

    /**
     * This property holds the leading action.
     * @deprecated Set leadingAction instead.
     */
    property alias leftAction: root.leadingAction

    /**
     * This property holds the trailing action.
     * @deprecated Set trailingAction instead.
     */
    property alias rightAction: root.trailingAction

    /**
     * This property holds the leading action.
     */
    property Kirigami.Action leadingAction

    /**
     * This property holds the trailing action.
     */
    property Kirigami.Action trailingAction

    radius: Kirigami.Units.largeSpacing
    color: "transparent"
    height: Math.round(Kirigami.Units.gridUnit * 2.5)
    width: 2 * height - 1

    shadow {
        size: 10
        xOffset: 2
        yOffset: 2
        color: Qt.rgba(0, 0, 0, 0.2)
    }

    QQC2.Button {
        id: leadingButton

        z: (down || visualFocus || hovered) ? 2 : leadingButtonBorderAnimation.running ? 1 : 0

        background: Kirigami.ShadowedRectangle {
            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: Kirigami.Theme.Window

            corners {
                topLeftRadius: root.radius
                bottomLeftRadius: root.radius
            }

            border {
                width: 1
                color: if (parent.down || parent.visualFocus) {
                    Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.4)
                } else if (parent.hovered) {
                    Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.6)
                } else {
                    Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.2)
                }
            }

            color: if (parent.down || parent.visualFocus) {
                Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.6)
            } else if (parent.hovered) {
                Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.8)
            } else {
                Kirigami.Theme.backgroundColor
            }

            Behavior on color {
                enabled: true
                ColorAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on border.color {
                enabled: true
                ColorAnimation {
                    id: leadingButtonBorderAnimation
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.OutCubic
                }
            }
        }

        contentItem: Item {
            Kirigami.Icon {
                implicitHeight: if (root.leadingAction.icon.height) {
                    root.leadingAction.icon.height
                } else {
                    Kirigami.Units.iconSizes.medium
                }
                implicitWidth: if (root.leadingAction.icon.width) {
                    root.leadingAction.icon.width
                } else {
                    Kirigami.Units.iconSizes.medium
                }
                source: if (root.leadingAction.icon.name) {
                    root.leadingAction.icon.name
                } else {
                    root.leadingAction.icon.source
                }
                anchors.centerIn: parent
            }
        }
        action: root.leadingAction
        anchors.left: root.left
        height: root.height
        width: root.height
        display: QQC2.AbstractButton.IconOnly
    }

    QQC2.Button {
        id: trailingButton

        z: (down || visualFocus || hovered) ? 2 : trailingButtonBorderAnimation.running ? 1 : 0

        background: Kirigami.ShadowedRectangle {
            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: Kirigami.Theme.Window

            corners {
                topRightRadius: root.radius
                bottomRightRadius: root.radius
            }

            border {
                width: 1
                color: if (parent.down || parent.visualFocus) {
                    Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.4)
                } else if (parent.hovered) {
                    Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.6)
                } else {
                    Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.2)
                }
            }

            color: if (parent.down || parent.visualFocus) {
                Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.6)
            } else if (parent.hovered) {
                Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.8)
            } else {
                Kirigami.Theme.backgroundColor
            }

            Behavior on color {
                enabled: true
                ColorAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on border.color {
                id: trailingButtonBorderAnimation
                enabled: true
                ColorAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.OutCubic
                }
            }
        }

        contentItem: Item {
            Kirigami.Icon {
                implicitHeight: if (root.trailingAction.icon.height) {
                    root.trailingAction.icon.height
                } else {
                    Kirigami.Units.iconSizes.medium
                }
                implicitWidth: if (root.trailingAction.icon.width) {
                    root.trailingAction.icon.width
                } else {
                    Kirigami.Units.iconSizes.medium
                }
                source: if (root.trailingAction.icon.name) {
                    root.trailingAction.icon.name
                } else {
                    root.trailingAction.icon.source
                }
                anchors.centerIn: parent
            }
        }

        action: root.trailingAction
        anchors.right: root.right
        height: root.height
        width: root.height
        display: QQC2.AbstractButton.IconOnly
    }
}
