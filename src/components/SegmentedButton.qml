// SPDX-FileCopyrightText: 2023 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.delegates as Delegates
import org.kde.kirigamiaddons.components.templates as Templates

/*!
   \qmltype SegmentedButton
   \inqmlmodule org.kde.kirigamiaddons.components
   \brief Segmented button component.

   This holds multiple buttons.
 */
Templates.SegmentedButton {
    id: root

    delegate: QQC2.AbstractButton {
        id: buttonDelegate

        required property int index
        required property T.Action modelData

        property bool highlightBackground: down || checked
        property bool highlightBorder: enabled && down || checked || visualFocus || hovered
        z: highlightBorder ? 1 : 0

        padding: Kirigami.Units.mediumSpacing

        focus: index === 0

        action: modelData

        display: modelData instanceof Kirigami.Action && (modelData as Kirigami.Action).displayHint & Kirigami.DisplayHint.IconOnly
            ? QQC2.AbstractButton.IconOnly : QQC2.AbstractButton.TextBesideIcon

        Layout.fillHeight: true
        Layout.minimumWidth: height

        icon {
            width: Kirigami.Units.iconSizes.smallMedium
            height: Kirigami.Units.iconSizes.smallMedium
        }

        contentItem: Delegates.DefaultContentItem {
            itemDelegate: buttonDelegate
            iconItem.Layout.fillWidth: buttonDelegate.modelData instanceof Kirigami.Action
                ? buttonDelegate.modelData.displayHint & Kirigami.DisplayHint.IconOnly
                : true

            labelItem {
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
                Accessible.ignored: true
            }
        }

        background: Kirigami.ShadowedRectangle {

            property color flatColor: Qt.rgba(
                Kirigami.Theme.backgroundColor.r,
                Kirigami.Theme.backgroundColor.g,
                Kirigami.Theme.backgroundColor.b,
                0
            )

            corners {
                topLeftRadius: buttonDelegate.index === (root.LayoutMirroring.enabled ? root._buttonCount - 1 : 0)
                    ? Kirigami.Units.mediumSpacing : 0
                bottomLeftRadius: buttonDelegate.index === (root.LayoutMirroring.enabled ? root._buttonCount - 1 : 0)
                    ? Kirigami.Units.mediumSpacing : 0

                bottomRightRadius: buttonDelegate.index === (root.LayoutMirroring.enabled ? 0 : root._buttonCount - 1)
                    ? Kirigami.Units.mediumSpacing : 0
                topRightRadius: buttonDelegate.index === (root.LayoutMirroring.enabled ? 0 : root._buttonCount - 1)
                    ? Kirigami.Units.mediumSpacing : 0
            }

            visible: !buttonDelegate.flat || buttonDelegate.editable || buttonDelegate.down || buttonDelegate.checked || buttonDelegate.highlighted || buttonDelegate.visualFocus || buttonDelegate.hovered

            color: {
                if (buttonDelegate.highlightBackground) {
                    return Kirigami.Theme.alternateBackgroundColor
                } else if (buttonDelegate.flat) {
                    return flatColor
                } else {
                    return Kirigami.Theme.backgroundColor
                }
            }

            border {
                color: {
                    if (buttonDelegate.highlightBorder) {
                        return Kirigami.Theme.focusColor
                    } else {
                        return Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, Kirigami.Theme.frameContrast);
                    }
                }
                width: 1
            }

            Behavior on color {
                enabled: buttonDelegate.highlightBackground
                ColorAnimation {
                    duration: Kirigami.Units.shortDuration
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on border.color {
                enabled: buttonDelegate.highlightBorder
                ColorAnimation {
                    duration: Kirigami.Units.shortDuration
                    easing.type: Easing.OutCubic
                }
            }

            Kirigami.ShadowedRectangle {
                height: buttonDelegate.height
                z: -1
                color: Qt.rgba(0, 0, 0, 0.1)

                opacity: buttonDelegate.down ? 0 : 1
                visible: !buttonDelegate.editable && !buttonDelegate.flat && buttonDelegate.enabled

                corners {
                    topLeftRadius: buttonDelegate.index === (root.LayoutMirroring.enabled ? root._buttonCount - 1 : 0)
                        ? Kirigami.Units.mediumSpacing : 0
                    bottomLeftRadius: buttonDelegate.index === (root.LayoutMirroring.enabled ? root._buttonCount - 1 : 0)
                        ? Kirigami.Units.mediumSpacing : 0

                    bottomRightRadius: buttonDelegate.index === (root.LayoutMirroring.enabled ? 0 : root._buttonCount - 1)
                        ? Kirigami.Units.mediumSpacing : 0
                    topRightRadius: buttonDelegate.index === (root.LayoutMirroring.enabled ? 0 : root._buttonCount - 1)
                        ? Kirigami.Units.mediumSpacing : 0
                }

                anchors {
                    top: parent.top
                    topMargin: 1
                    left: parent.left
                    right: parent.right
                }
            }
        }
    }
}
