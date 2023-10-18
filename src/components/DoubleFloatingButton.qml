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
 * import QtQuick 2.15
 * import QtQuick.Controls 2.15 as QQC2
 * import org.kde.kirigami 2.20 as Kirigami
 * import org.kde.kirigamiaddons.components 1.0 as KirigamiComponents
 *
 * Kirigami.ScrollablePage {
 *     ListView {
 *         model: []
 *         delegate: QQC2.ItemDelegate {}
 *
 *         KirigamiComponents.DoubleFloatingButton {
 *             anchors {
 *                 right: parent.right
 *                 bottom: parent.bottom
 *                 margins: Kirigami.Units.largeSpacing
 *             }
 *
 *             leadingAction: Kirigami.Action {
 *                 text: "Zoom Out"
 *                 icon.name: "list-remove"
 *             }
 *
 *             trailingAction: Kirigami.Action {
 *                 text: "Zoom In"
 *                 icon.name: "list-add"
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
     */
    property Kirigami.Action leadingAction

    /**
     * This property holds the trailing action.
     */
    property Kirigami.Action trailingAction

    // Note: binding corners to each other results in binding loops, because
    // they share one common NOTIFY signal. Storing properties wastes memory.
    // So these two expressions are implemented as little helper functions.

    // Left for leading and right for trailing buttons
    function __radiusA(): real {
        return LayoutMirroring.enabled ? 0 : radius;
    }

    // and vice-versa
    function __radiusB(): real {
        return LayoutMirroring.enabled ? radius : 0;
    }

    radius: Kirigami.Units.largeSpacing
    color: "transparent"
    height: Math.round(Kirigami.Units.gridUnit * 2.5)
    width: 2 * height - 1

    shadow {
        size: 10
        xOffset: 0
        yOffset: 2
        color: Qt.rgba(0, 0, 0, 0.2)
    }

    QQC2.Button {
        id: leadingButton

        LayoutMirroring.enabled: root.LayoutMirroring.enabled

        z: (down || visualFocus || (enabled && hovered)) ? 2 : leadingButtonBorderAnimation.running ? 1 : 0

        background: Kirigami.ShadowedRectangle {
            id: leadingButtonBackground

            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: Kirigami.Theme.Window

            corners {
                topLeftRadius: root.__radiusA()
                bottomLeftRadius: root.__radiusA()
                topRightRadius: root.__radiusB()
                bottomRightRadius: root.__radiusB()
            }

            border {
                width: 1
                color: if (leadingButton.down || leadingButton.visualFocus) {
                    Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.4)
                } else if (leadingButton.enabled && leadingButton.hovered) {
                    Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.6)
                } else {
                    Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.2)
                }
            }

            color: if (leadingButton.down || leadingButton.visualFocus) {
                Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.6)
            } else if (leadingButton.enabled && leadingButton.hovered) {
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
                implicitHeight: if (leadingButton.icon.height) {
                    leadingButton.icon.height
                } else {
                    Kirigami.Units.iconSizes.medium
                }
                implicitWidth: if (leadingButton.icon.width) {
                    leadingButton.icon.width
                } else {
                    Kirigami.Units.iconSizes.medium
                }
                source: if (leadingButton.icon.name) {
                    leadingButton.icon.name
                } else {
                    leadingButton.icon.source
                }
                anchors.centerIn: parent
            }
        }
        action: root.leadingAction
        anchors.left: root.left
        height: root.height
        width: root.height
        enabled: action ? action.enabled : false
        display: QQC2.AbstractButton.IconOnly
    }

    QQC2.Button {
        id: trailingButton

        LayoutMirroring.enabled: root.LayoutMirroring.enabled

        z: (down || visualFocus || (enabled && hovered)) ? 2 : trailingButtonBorderAnimation.running ? 1 : 0

        background: Kirigami.ShadowedRectangle {
            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: Kirigami.Theme.Window

            corners {
                topLeftRadius: root.__radiusB()
                bottomLeftRadius: root.__radiusB()
                topRightRadius: root.__radiusA()
                bottomRightRadius: root.__radiusA()
            }

            border {
                width: 1
                color: if (trailingButton.down || trailingButton.visualFocus) {
                    Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.4)
                } else if (trailingButton.enabled && trailingButton.hovered) {
                    Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.6)
                } else {
                    Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.2)
                }
            }

            color: if (trailingButton.down || trailingButton.visualFocus) {
                Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.hoverColor, Kirigami.Theme.backgroundColor, 0.6)
            } else if (trailingButton.enabled && trailingButton.hovered) {
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
                implicitHeight: if (trailingButton.icon.height) {
                    trailingButton.icon.height
                } else {
                    Kirigami.Units.iconSizes.medium
                }
                implicitWidth: if (trailingButton.icon.width) {
                    trailingButton.icon.width
                } else {
                    Kirigami.Units.iconSizes.medium
                }
                source: if (trailingButton.icon.name) {
                    trailingButton.icon.name
                } else {
                    trailingButton.icon.source
                }
                anchors.centerIn: parent
            }
        }

        action: root.trailingAction
        anchors.right: root.right
        height: root.height
        width: root.height
        enabled: action ? action.enabled : false
        display: QQC2.AbstractButton.IconOnly
    }
}
