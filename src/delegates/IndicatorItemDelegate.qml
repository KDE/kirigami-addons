// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import QtQuick.Controls as QQC2
import QtQuick.Templates as T

/*!
   \qmltype IndicatorItemDelegate
   \inqmlmodule org.kde.kirigamiaddons.delegates
   \warning This component is expected to be used as a \l ListView::delegate {ListView.delegate}.
   If this is not the case, make sure to set \l index and listView.
 */
T.ItemDelegate {
    id: root

    /*!
     */
    required property int index
    /*!
     */
    required property bool unread

    /*!
       The listview associated with this item delegate.
     */
    property ListView listView: ListView.view

    /*!
     */
    readonly property bool showSeparator: root.index !== listView.count

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding,
                             Kirigami.Units.gridUnit * 2)

    width: listView ? listView.width : implicitWidth
    highlighted: ListView.isCurrentItem

    padding: Kirigami.Units.largeSpacing

    horizontalPadding: padding
    leftPadding: horizontalPadding
    rightPadding: horizontalPadding

    verticalPadding: padding
    topPadding: verticalPadding
    bottomPadding: verticalPadding

    hoverEnabled: !Kirigami.Settings.isMobile

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
                return Kirigami.ColorUtils.tintWithAlpha(highlight, Kirigami.Theme.textColor, 0.10)
            } else if (highlight.valid) {
                return highlight
            } else {
                return 'transparent';
            }
        } else if (root.hovered) {
            return Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.10)
        } else {
            return 'transparent'
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
            visible: root.showSeparator && !root.hovered
            opacity: 0.5
        }
    }

    contentItem: DefaultContentItem {
        itemDelegate: root
    }
}
