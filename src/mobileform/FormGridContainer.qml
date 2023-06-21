// SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
// SPDX-FileCopyrightText: 2023 Rishi Kumar <rsi.dev17@gmail.com>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

import "private" as Private

/**
 * This component render a grid of small cards.
 *
 * This is used to display multiple information in a MobileForm.FormLayout
 * without taking too much vertical space.
 *
 * @code{.qml}
 * import org.kde.kirigamiaddons.labs.mobileform 0.1 as MobileForm
 *
 * MobileForm.FormGridContainer {
 *     id: container
 *
 *     Layout.topMargin: Kirigami.Units.largeSpacing
 *     Layout.fillWidth: true
 *
 *     infoCards: [
 *         MobileForm.FormGridContainer.InfoCard {
 *             title: "42"
 *             subtitle: i18nc("@info:Number of Posts", "Posts")
 *         },
 *         MobileForm.FormGridContainer.InfoCard {
 *             title: "42"
 *             subtitle: i18nc("@info:Number of followers.", "Followers")
 *         }
 *     ]
 * }
 * @endcode
 *
 *
 * @since org.kde.kirigamiaddons.labs.mobileform 0.1
 *
 * @inherit QtQuick.Item
 */
Item {
    id: root

    /**
     * This property holds the maximum width of the grid.
     */
    property real maximumWidth: Kirigami.Units.gridUnit * 30

    /**
     * @brief This property holds the padding used around the content edges.
     *
     * default: `0`
     */
    property real padding: 0
    property real verticalPadding: padding
    property real horizontalPadding: padding
    property real topPadding: verticalPadding
    property real bottomPadding: verticalPadding
    property real leftPadding: horizontalPadding
    property real rightPadding: horizontalPadding

    /**
     * This property holds whether the card's width is being restricted.
     */
    readonly property bool cardWidthRestricted: root.width > root.maximumWidth

    /**
     * This property holds the InfoCards which should be displayed.
     *
     * Each InfoCard contains a title and an optional subtitle
     *
     * @code{.qml}
     * import org.kde.kirigamiaddons.labs.mobileform 0.1 as MobileForm
     *
     * MobileForm.FormGridContainer {
     *     infoCards: [
     *         MobileForm.FormGridContainer.InfoCard {
     *             title: "42"
     *             subtitle: i18nc("@info:Number of Posts", "Posts")
     *         },
     *         MobileForm.FormGridContainer.InfoCard {
     *             title: "42"
     *         }
     *     ]
     * }
     * @endcode
     */
    property list<InfoCard> infoCards

    component InfoCard: QtObject {
        required property string title
        property string subtitle
    }

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    implicitHeight: topPadding + bottomPadding + grid.implicitHeight

    Item {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right

            leftMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : -1
            rightMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : -1
        }

        GridLayout {
            id: grid

            readonly property int cellWidth: Kirigami.Units.gridUnit * 10
            readonly property int cellHeight: {
                let max = 0;
                for (let i in children) {
                    let child = children[i];
                    if (child.implicitHeight > max) {
                        max = child.implicitHeight;
                    }
                }
                return max;
            }

            anchors {
                fill: parent
                leftMargin: root.leftPadding
                rightMargin: root.rightPadding
                topMargin: root.topPadding
                bottomMargin: root.bottomPadding
            }

            columns: 3
            columnSpacing: Kirigami.Units.smallSpacing
            rowSpacing: Kirigami.Units.smallSpacing

            Repeater {
                model: root.infoCards

                QQC2.Control {
                    id: infoCardDelegate

                    required property var modelData

                    readonly property string title: modelData.title
                    readonly property string subtitle: modelData.subtitle

                    leftPadding: Kirigami.Units.largeSpacing
                    rightPadding: Kirigami.Units.largeSpacing
                    topPadding: Kirigami.Units.largeSpacing
                    bottomPadding: Kirigami.Units.largeSpacing

                    Accessible.name: title + " " + subtitle

                    Layout.preferredWidth: grid.cellWidth
                    Layout.fillWidth: true
                    Layout.preferredHeight: grid.cellHeight

                    background: Rectangle {
                        radius: root.cardWidthRestricted ? Kirigami.Units.smallSpacing : 0
                        color: Kirigami.Theme.backgroundColor

                        border {
                            color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.15)
                            width: 1
                        }
                    }

                    contentItem: ColumnLayout {
                        spacing: 0

                        // Title
                        Kirigami.Heading {
                            Layout.fillWidth: true
                            level: 4
                            text: infoCardDelegate.title
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            wrapMode: Text.Wrap
                        }

                        // Subtitle
                        QQC2.Label {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: infoCardDelegate.subtitle
                            text: infoCardDelegate.subtitle
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                            wrapMode: Text.Wrap
                            opacity: 0.6
                            verticalAlignment: Text.AlignTop
                        }
                    }
                }
            }
        }
    }
}
