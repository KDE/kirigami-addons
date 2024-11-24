// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

/**
 * @brief A placeholder message indicating that a FormCard is empty.
 *
 * Example usage:
 *
 * import org.kde.kirigamiaddons.formcard as FormCard
 *
 * FormCard.FormCardPage {
 *     FormCard.FormHeader {
 *         title: i18nc("@title:group", "Items")
 *     }
 *
 *     FormCard.FormCard {
 *         FormCard.FormPlaceholderMessageDelegate {
 *             text: i18nc("@info:placeholder", "There are no items in this list")
 *             visible: repeater.count === 0
 *         }
 *
 *         Repeater {
 *             id: repeater
 *             model: [ ... ]
 *             delegate: [ ... ]
 *         }
 *
 *         FormCard.FormDelegateSeparator {}
 *
 *         FormCard.FormButtonDelegate {
 *             text: i18nc("@action:button", "Add Item")
 *             icon.name: "list-add-symbolic"
 *         }
 *     }
 * }
 *
 * @since 6.9
 */
AbstractFormDelegate {
    id: root

    /**
     * @brief This property holds the smaller explanatory text to show below the larger title-style text
     *
     * Useful for providing a user-friendly explanation on how to proceed.
     *
     * Optional; if not defined, the message will have no supplementary
     * explanatory text.
     */
    property string explanation

    /**
     * This property holds the link embedded in the explanatory message text that
     * the user is hovering over.
     */
    property alias hoveredLink: label.hoveredLink

    /**
     * This signal is emitted when a link is hovered in the explanatory message
     * text.
     * @param The hovered link.
     */
    signal linkHovered(string link)

    /**
     * This signal is emitted when a link is clicked or tapped in the explanatory
     * message text.
     * @param The clicked or tapped link.
     */
    signal linkActivated(string link)

    topPadding: Kirigami.Units.gridUnit
    bottomPadding: Kirigami.Units.gridUnit

    icon {
        width: Kirigami.Units.iconSizes.medium
        height: Kirigami.Units.iconSizes.medium
    }

    Accessible.description: explanation

    background: null
    contentItem: ColumnLayout {
        id: placeholderMessage

        spacing: Kirigami.Units.smallSpacing

        Kirigami.Icon {
            visible: source !== undefined
            opacity: 0.5

            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: root.icon.width
            Layout.preferredHeight: root.icon.height

            color: root.icon.color

            source: {
                if (root.icon.source.length > 0) {
                    return root.icon.source
                } else if (root.icon.name.length > 0) {
                    return root.icon.name
                }
                return undefined
            }
        }

        Kirigami.Heading {
            text: root.text
            visible: text.length > 0

            level: 3
            type: Kirigami.Heading.Primary
            opacity: 0.65


            Layout.fillWidth: true
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter

            wrapMode: Text.WordWrap

            Accessible.ignored: true
        }

        Kirigami.SelectableLabel {
            id: label

            text: root.explanation
            visible: root.explanation.length > 0
            opacity: 0.65

            horizontalAlignment: Qt.AlignHCenter
            wrapMode: Text.WordWrap

            Layout.fillWidth: true

            onLinkHovered: link => root.linkHovered(link)
            onLinkActivated: link => root.linkActivated(link)

            Accessible.ignored: true
        }

        visible: root.visible // for accessibility
    }
}