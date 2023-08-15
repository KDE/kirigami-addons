// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami
import QtQuick.Controls 2.15 as QQC2

/**
 * @warning This component is expected to be used as a ListView.delegate.
 * If this is not the case, make sure to set index and listView
 */
QQC2.ItemDelegate {
    id: root

    required property int index
    required property bool unread

    readonly property bool showSeparator: root.index !== ListView.view.count

    width: ListView.view ? ListView.view.width : implicitWidth
    highlighted: ListView.isCurrentItem

    padding: Kirigami.Units.largeSpacing

    horizontalPadding: padding
    leftPadding: horizontalPadding
    rightPadding: horizontalPadding

    verticalPadding: padding
    topPadding: verticalPadding
    bottomPadding: verticalPadding

    hoverEnabled: true

    icon {
        width: if (contentItem instanceof SubtitleContentItem) {
            Kirigami.Units.iconSizes.large
        } else {
            Kirigami.Units.iconSizes.medium
        }

        height: if (contentItem instanceof SubtitleContentItem) {
            Kirigami.Units.iconSizes.large
        } else {
            Kirigami.Units.iconSizes.medium
        }
    }

    Accessible.description: if (contentItem instanceof SubtitleContentItem) {
        contentItem.subtitle
    } else {
        ""
    }

    background: Rectangle {
        color: if (root.highlighted || root.checked || (root.down && !root.checked) || root.visualFocus) {
            const highlight = Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.highlightColor, 0.3);
            if (root.hovered) {
                Kirigami.ColorUtils.tintWithAlpha(highlight, Kirigami.Theme.textColor, 0.10)
            } else {
                highlight
            }
        } else if (root.hovered) {
            Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.10)
        } else {
            Kirigami.Theme.backgroundColor
        }

        // indicator rectangle
        Rectangle {
            anchors {
                left: parent.left
                top: parent.top
                topMargin: 1
                bottom: parent.bottom
                bottomMargin: 1
            }

            width: 4
            visible: root.unread
            color: Kirigami.Theme.highlightColor
        }

        Kirigami.Separator {
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                leftMargin: root.leftPadding
                rightMargin: root.rightPadding
            }
            visible: root.showSeparator && !root.hovered && (root.index === 0 || !root.ListView.view.itemAtIndex(root.index - 1))
            opacity: 0.5
        }
    }

    contentItem: DefaultContentItem {
        itemDelegate: root
    }
}
