/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Controls.Material
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components.templates as Templates

Templates.MessageDialog {
    id: root

    Material.roundedScale: Material.ExtraLargeScale
    Material.elevation: 6

    padding: Kirigami.Units.largeSpacing * 3
    spacing: 0
    _messageColumns: 1
    _messageIconSize: Kirigami.Units.iconSizes.smallMedium
    _messageRowSpacing: Kirigami.Units.largeSpacing * 2
    _messageSpacing: Kirigami.Units.largeSpacing * 3
    _titleAlignment: iconName.length > 0 ? Qt.AlignHCenter : Qt.AlignLeft
    _titleFont: Qt.font({ pixelSize: Material.dialogTitleFontPixelSize })
    _titleColor: Material.foreground
    _subtitleColor: Qt.alpha(Material.foreground, 0.8)
    _subtitleVisible: subtitle.length > 0

    _buttonLayout: QQC2.DialogButtonBox.AndroidLayout
    _rememberChoiceOnOwnRow: true
    _footerHorizontalPadding: padding
    _footerBottomPadding: Kirigami.Units.largeSpacing
    _mobileLayout: _buttonRowWidth + padding * 2 > (footer?.width ?? 0)

    _buttonDelegate: QQC2.Button {
        property int index: root._buttonModel.children.indexOf(this)

        Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.DialogButton
        Material.foreground: root.Material.accent
        flat: true
        display: QQC2.AbstractButton.TextOnly
        Layout.alignment: Qt.AlignRight
        Layout.leftMargin: root._mobileLayout || index === 0 ? root.padding : 0
        Layout.rightMargin: root._mobileLayout || index === root._buttonCount - 1 ? root.padding : 0
        Layout.bottomMargin: root._mobileLayout && index !== root._buttonCount - 1 ? 0 : root.padding
    }

    background: DialogRoundedBackground {
        Material.roundedScale: root.Material.roundedScale
        Material.elevation: root.Material.elevation
    }

    QQC2.Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.32)
        Behavior on opacity {
            NumberAnimation {
                duration: Kirigami.Units.shortDuration
            }
        }
    }
}
