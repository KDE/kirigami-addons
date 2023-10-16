// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as Components
import org.kde.kirigamiaddons.delegates as Delegates

QQC2.AbstractButton {
    id: root

    required property T.DialogButtonBox buttonBox

    readonly property int index: {
        for (let i = 0; i < buttonBox.count; i++) {
            if (buttonBox.contentChildren[i] == root) {
                return i;
            }
        }
        return -1;
    }

    padding: Kirigami.Units.mediumSpacing

    implicitWidth: Math.floor(Math.max(
        contentItem.implicitWidth,
        ((buttonBox.availableWidth - (buttonBox.spacing * (buttonBox.count - 1))) / buttonBox.count)
    )) + (index === 0 ? 1 : 0)

    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    contentItem: Delegates.DefaultContentItem {
        itemDelegate: root
        labelItem {
            horizontalAlignment: Text.AlignHCenter
        }
    }

    background: Kirigami.ShadowedRectangle {
        corners {
            topLeftRadius: 0
            bottomLeftRadius: root.index === 0 ? Kirigami.Units.mediumSpacing : 0

            bottomRightRadius: root.index === buttonBox.count - 1 ? Kirigami.Units.mediumSpacing : 0
            topRightRadius: 0
        }

        color: {
            let backgroundColor;
            switch (root.QQC2.DialogButtonBox.buttonRole) {
            case QQC2.DialogButtonBox.AcceptRole:
            case QQC2.DialogButtonBox.ApplyRole:
                backgroundColor = Kirigami.Theme.positiveBackgroundColor;
                break;
            case QQC2.DialogButtonBox.DestructiveRole:
                backgroundColor = Kirigami.Theme.negativeBackgroundColor;
                break;
            default:
                backgroundColor = Kirigami.Theme.backgroundColor;
                break;
            }

            if (root.highlighted || root.checked || (root.down && !root.checked) || root.visualFocus) {
                const highlight = Kirigami.ColorUtils.tintWithAlpha(backgroundColor, Kirigami.Theme.highlightColor, 0.3);
                if (root.hovered) {
                    return Kirigami.ColorUtils.tintWithAlpha(highlight, Kirigami.Theme.textColor, 0.10);
                } else {
                    return highlight;
                }
            } else if (root.hovered) {
                return Kirigami.ColorUtils.tintWithAlpha(backgroundColor, Kirigami.Theme.textColor, 0.10);
            } else {
                return backgroundColor;
            }
        }
    }
}
