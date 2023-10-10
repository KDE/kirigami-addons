// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.20 as Kirigami

T.ItemDelegate {
    id: root

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    width: if (ListView.view) {
        ListView.view.width
    } else if (GridView.view) {
        GridView.view.cellWidth
    } else {
        implicitWidth
    }

    height: if (GridView.view) {
        GridView.view.cellHeight
    } else {
        implicitHeight
    }
    highlighted: ListView.isCurrentItem || GridView.isCurrentItem

    spacing: Kirigami.Units.mediumSpacing

    padding: Kirigami.Units.mediumSpacing

    horizontalPadding: padding + Math.round(Kirigami.Units.smallSpacing / 2)
    leftPadding: horizontalPadding
    rightPadding: horizontalPadding

    verticalPadding: padding
    topPadding: verticalPadding
    bottomPadding: verticalPadding

    topInset: if (root.index !== undefined && index === 0 && ListView.view && ListView.view.topMargin === 0) {
        Kirigami.Units.smallSpacing;
    } else {
        Math.round(Kirigami.Units.smallSpacing / 2);
    }
    bottomInset: if (root.index !== undefined && ListView.view && index === ListView.view.count - 1 && ListView.view.bottomMargin === 0) {
        Kirigami.Units.smallSpacing;
    } else {
        Math.round(Kirigami.Units.smallSpacing / 2)
    }
    rightInset: Kirigami.Units.smallSpacing
    leftInset: Kirigami.Units.smallSpacing

    icon {
        width: if (contentItem instanceof SubtitleContentItem) {
            Kirigami.Units.iconSizes.large
        } else {
            Kirigami.Units.iconSizes.sizeForLabels
        }

        height: if (contentItem instanceof SubtitleContentItem) {
            Kirigami.Units.iconSizes.large
        } else {
            Kirigami.Units.iconSizes.sizeForLabels
        }
    }

    Accessible.description: if (contentItem instanceof SubtitleContentItem) {
        contentItem.subtitle
    } else {
        ""
    }

    background: Rectangle {
        radius: Kirigami.Units.smallSpacing

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

        border {
            color: Kirigami.Theme.highlightColor
            width: root.visualFocus || root.activeFocus ? 1 : 0
        }

        Behavior on color {
            ColorAnimation {
                duration: Kirigami.Units.shortDuration
            }
        }
    }

    contentItem: DefaultContentItem {
        itemDelegate: root
    }
}
