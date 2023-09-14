// SPDX-FileCopyrightText: 2023 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Templates 2.15 as T
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami
import org.kde.kirigamiaddons.delegates 1.0 as Delegates

RowLayout {
    id: root

    property list<T.Action> actions

    spacing: Math.round(Kirigami.Units.smallSpacing / 2)

    Repeater {
        id: buttonRepeater

        model: root.actions

        delegate: QQC2.AbstractButton {
            id: buttonDelegate

            required property int index
            required property T.Action modelData

            padding: Kirigami.Units.mediumSpacing

            focus: index === 0

            action: modelData

            display: modelData.displayHint & Kirigami.DisplayHint.IconOnly ? QQC2.AbstractButton.IconOnly : QQC2.AbstractButton.TextBesideIcon

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
                }
            }

            background: Kirigami.ShadowedRectangle {
                property bool highlightBackground: buttonDelegate.down || buttonDelegate.checked

                corners {
                    topLeftRadius: buttonDelegate.index === 0 ? Kirigami.Units.mediumSpacing : 0
                    bottomLeftRadius: buttonDelegate.index === 0 ? Kirigami.Units.mediumSpacing : 0

                    bottomRightRadius: buttonDelegate.index === buttonRepeater.count - 1 ? Kirigami.Units.mediumSpacing : 0
                    topRightRadius: buttonDelegate.index === buttonRepeater.count - 1 ? Kirigami.Units.mediumSpacing : 0
                }

                color: if (highlightBackground) {
                    return Kirigami.Theme.alternateBackgroundColor
                } else if (buttonDelegate.highlighted || buttonDelegate.checked || (buttonDelegate.down && !buttonDelegate.checked) || buttonDelegate.visualFocus) {
                    const highlight = Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.highlightColor, 0.3);
                    if (buttonDelegate.hovered) {
                        Kirigami.ColorUtils.tintWithAlpha(highlight, Kirigami.Theme.textColor, 0.10)
                    } else {
                        highlight
                    }
                } else if (buttonDelegate.hovered) {
                    Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.10)
                } else {
                   Kirigami.Theme.backgroundColor
                }

                border {
                    width: buttonDelegate.down || buttonDelegate.visualFocus ? 1 :0
                    color: Kirigami.Theme.highlightColor
                }
            }
        }
    }
}
