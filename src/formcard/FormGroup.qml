// SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
// SPDX-FileCopyrightText: 2024 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.20 as Kirigami

import "private" as Private

/**
 * @brief A single group that follows a form style.
 *
 * This is the entrypoint component for forms.
 *
 * A FormGroup consists of a container that can be used to create your
 * own From pages. It has a different color than the background.
 *
 * Each FormGroup can contain one or more Form delegates as children which are
 * automatically arranged.
 *
 * Multiple FormGroup can be added to a FormPage.
 *
 * The FormGroup also provides a title property which is automatically placed at
 * the top of the group.
 *
 * The height of the FormCard matches the implicit height of the contents
 * and does not need to be set, while the width is expected
 * to be given by the parent, for example, via a Layout.fillWidth.
 *
 * @since KirigamiAddons 0.11.0
 *
 * @inherit QtQuick.Item
 */
Item {
    id: root

    /**
     * @brief The delegates inside the Form card.
     *
     * This is where you should add new Form delegates.
     */
    default property alias delegates: internalColumn.data

    /**
     * @brief This property holds the header title.
     *
     * @property string title
     */
    property alias title: headerContent.text

    /**
     * @brief The content item for the title.
     *
     * This can be used to insert override the current header content with a custom
     * component.
     *
     * @property Item titleContent
     */
    property alias titleContent: headerControl.contentItem

    /**
     * @brief The maximum width of the card.
     *
     * This can be set to a specific value to force its delegates to wrap
     * instead of using the entire width of the parent.
     *
     * default: `Kirigami.Units.gridUnit * 30`
     *
     * @see cardWidthRestricted
     */
    property real maximumWidth: Kirigami.Units.gridUnit * 30

    /**
     * @brief The padding used around the content edges.
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
     * @brief Whether the card's width is being restricted.
     */
    readonly property bool cardWidthRestricted: root.width > root.maximumWidth

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    Layout.fillWidth: true
    implicitHeight: mainColumn.implicitHeight + mainColumn.anchors.topMargin

    ColumnLayout {
        id: mainColumn
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right

            topMargin: headerControl.visible ? 0 : Kirigami.Units.largeSpacing
            leftMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : -1
            rightMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : -1
        }

        spacing: 0

        QQC2.Control {
            id: headerControl
            Layout.fillWidth: true
            topPadding: root.topPadding + Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
            bottomPadding: root.bottomPadding + Kirigami.Units.smallSpacing
            leftPadding: root.topPadding + (root.cardWidthRestricted ? Kirigami.Units.smallSpacing : Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing)
            rightPadding: root.bottomPadding + (root.cardWidthRestricted ? Kirigami.Units.smallSpacing : Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing)

            visible: root.title.length > 0

            contentItem: QQC2.Label {
                id: headerContent
                Layout.fillWidth: true
                font.weight: Font.DemiBold
                wrapMode: Text.WordWrap
                Accessible.role: Accessible.Heading
            }
        }
        QQC2.Control {
            Layout.fillWidth: true
            Layout.fillHeight: true
            topPadding: root.topPadding + rectangle.borderWidth
            bottomPadding: root.bottomPadding + rectangle.borderWidth
            leftPadding: root.leftPadding + rectangle.borderWidth
            rightPadding: root.rightPadding + rectangle.borderWidth

            contentItem: ColumnLayout {
                id: internalColumn

                spacing: 0
            }
            background: Rectangle {
                id: rectangle
                readonly property real borderWidth: 1

                // only have card radius if it isn't filling the entire width
                radius: root.cardWidthRestricted ? Kirigami.Units.smallSpacing : 0
                color: Kirigami.Theme.backgroundColor

                border {
                    color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, Kirigami.Theme.frameContrast)
                    width: borderWidth
                }
            }
        }
    }
}
