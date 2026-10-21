/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Material
import QtQuick.Templates as T
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components.templates as Templates
import org.kde.kirigamiaddons.delegates as Delegates

Templates.SegmentedButton {
    id: root

    delegate: Button {
        id: button

        required property int index
        required property T.Action modelData

        readonly property bool leftEnd: index === (mirrored ? root._buttonCount - 1 : 0)
        readonly property bool rightEnd: index === (mirrored ? 0 : root._buttonCount - 1)
        readonly property color contentColor: !enabled ? Material.hintTextColor : Material.foreground

        action: modelData
        z: visualFocus ? 1 : 0
        focus: index === 0
        display: modelData instanceof Kirigami.Action && (modelData as Kirigami.Action).displayHint & Kirigami.DisplayHint.IconOnly
            ? T.AbstractButton.IconOnly : T.AbstractButton.TextBesideIcon

        horizontalPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
        leftPadding: undefined
        rightPadding: undefined
        verticalPadding: Kirigami.Units.mediumSpacing
        spacing: Kirigami.Units.largeSpacing
        topInset: 0
        bottomInset: 0

        Layout.fillHeight: true
        Layout.minimumWidth: height

        icon.width: Kirigami.Units.iconSizes.small
        icon.height: Kirigami.Units.iconSizes.small

        contentItem: Delegates.DefaultContentItem {
            itemDelegate: button
            iconItem.Layout.fillWidth: button.modelData instanceof Kirigami.Action
                ? button.modelData.displayHint & Kirigami.DisplayHint.IconOnly
                : true

            labelItem {
                color: button.contentColor
                rightPadding: 0
                elide: Text.ElideRight
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                Accessible.ignored: true
            }
        }

        background: Kirigami.ShadowedRectangle {
            corners {
                topLeftRadius: button.leftEnd ? button.height / 2 : 0
                bottomLeftRadius: button.leftEnd ? button.height / 2 : 0
                topRightRadius: button.rightEnd ? button.height / 2 : 0
                bottomRightRadius: button.rightEnd ? button.height / 2 : 0
            }

            color: Qt.tint(button.checked ? Qt.alpha(button.Material.accent, button.enabled ? 0.16 : 0.08) : "transparent",
                Qt.alpha(button.Material.foreground, !button.enabled ? 0 : button.down || button.visualFocus ? 0.12 : button.hovered ? 0.08 : 0))

            border.width: button.visualFocus ? 2 : 1
            border.color: button.visualFocus ? button.Material.accent : Qt.alpha(button.Material.foreground, button.enabled ? 0.5 : 0.12)
        }
    }
}
