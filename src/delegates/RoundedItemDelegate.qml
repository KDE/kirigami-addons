// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

/**
 * An item delegate providing a modern look and feel. Use a combination of
 * SubtitleContentItem, DefaultContentItem and RowLayout for the contentItem.
 *
 * @image html roundeditemdelegate.html
 */
T.ItemDelegate {
    id: root

    /**
     * This property holds a ListView
     *
     * It is automatically set if the RoundedItemDelegate is the direct delegate
     * of a ListView and must be set otherwise.
     */
    property var listView: ListView

    /**
     * This property holds a GridView
     *
     * It is automatically set if the RoundedItemDelegate is the direct delegate
     * of a GridView and must be set otherwise.
     */
    property var gridView: GridView

    /**
     * This property holds whether the drop area is hovered.
     *
     * This allow to emulate an hover effect which can't be done with the
     * normal hovered property as it is read only.
     */
    property bool dropAreaHovered: false

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding,
                             Kirigami.Units.gridUnit * 2)

    width: if (listView.view) {
        return listView.view.width;
    } else if (gridView.view) {
        return gridView.view.cellWidth;
    } else {
        implicitWidth
    }

    height: if (gridView.view) {
        return gridView.view.cellHeight;
    } else {
        return implicitHeight;
    }
    highlighted: listView.isCurrentItem || gridView.isCurrentItem

    spacing: Kirigami.Units.mediumSpacing

    padding: Kirigami.Units.mediumSpacing

    horizontalPadding: padding + Math.round(Kirigami.Units.smallSpacing / 2)
    leftPadding: horizontalPadding
    rightPadding: horizontalPadding

    verticalPadding: padding
    topPadding: verticalPadding
    bottomPadding: verticalPadding

    hoverEnabled: true

    topInset: if (root.index !== undefined && index === 0 && listView.view && listView.view.topMargin === 0) {
        Kirigami.Units.smallSpacing;
    } else {
        Math.round(Kirigami.Units.smallSpacing / 2);
    }
    bottomInset: if (root.index !== undefined && listView.view && index === listView.view.count - 1 && listView.view.bottomMargin === 0) {
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
        radius: Kirigami.Units.cornerRadius

        color: if (root.highlighted || root.checked || (root.down && !root.checked) || root.visualFocus) {
            const highlight = Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.highlightColor, 0.3);
            if (root.hovered || root.dropAreaHovered) {
                Kirigami.ColorUtils.tintWithAlpha(highlight, Kirigami.Theme.textColor, 0.10)
            } else {
                highlight
            }
        } else if (root.hovered || root.dropAreaHovered) {
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
