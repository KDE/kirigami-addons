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
 *             leftAction: Kirigami.Action {
 *                 text: "Zoom In"
 *                 icon.name: "list-add"
 *             }
 *
 *             rightAction: Kirigami.Action {
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
     * This property holds the left action
     */
    required property Kirigami.Action leftAction

    /**
     * This property holds the right action
     */
    required property Kirigami.Action rightAction

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
        id: rightButton

        z: (down || visualFocus || hovered) ? 2 : rightButtonBorderAnimation.running ? 1 : 0

        background: Kirigami.ShadowedRectangle {
            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: Kirigami.Theme.Window

            corners {
                topRightRadius: 10
                bottomRightRadius: 10
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
                id: rightButtonBorderAnimation
                enabled: true
                ColorAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.OutCubic
                }
            }
        }

        contentItem: Item {
            Kirigami.Icon {
                implicitHeight: if (root.rightAction.icon.height) {
                    root.rightAction.icon.height
                } else {
                    Kirigami.Units.iconSizes.medium
                }
                implicitWidth: if (root.rightAction.icon.width) {
                    root.rightAction.icon.width
                } else {
                    Kirigami.Units.iconSizes.medium
                }
                source: if (root.rightAction.icon.name) {
                    root.rightAction.icon.name
                } else {
                    root.rightAction.icon.source
                }
                anchors.centerIn: parent
            }
        }

        action: root.rightAction
        anchors.right: root.right
        height: root.height
        width: root.height
        display: QQC2.AbstractButton.IconOnly
    }

    QQC2.Button {
        id: leftButton

        z: (down || visualFocus || hovered) ? 2 : leftButtonBorderAnimation.running ? 1 : 0

        background: Kirigami.ShadowedRectangle {
            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: Kirigami.Theme.Window

            corners {
                topLeftRadius: 10
                bottomLeftRadius: 10
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
                    id: leftButtonBorderAnimation
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.OutCubic
                }
            }
        }

        contentItem: Item {
            Kirigami.Icon {
                implicitHeight: if (root.leftAction.icon.height) {
                    root.leftAction.icon.height
                } else {
                    Kirigami.Units.iconSizes.medium
                }
                implicitWidth: if (root.leftAction.icon.width) {
                    root.leftAction.icon.width
                } else {
                    Kirigami.Units.iconSizes.medium
                }
                source: if (root.leftAction.icon.name) {
                    root.leftAction.icon.name
                } else {
                    root.leftAction.icon.source
                }
                anchors.centerIn: parent
            }
        }
        action: root.leftAction
        anchors.left: root.left
        height: root.height
        width: root.height
        display: QQC2.AbstractButton.IconOnly
    }
}
