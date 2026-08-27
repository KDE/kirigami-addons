// SPDX-FileCopyrightText: 2026 Robert French <frenchrobertm@outlook.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

/*!
   \qmltype FormDelegateCollapsible
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A delegate designed to display or hide formcard contents.

   \qml
   import org.kde.kirigamiaddons.formcard as FormCard

   FormCard.FormCard {
        FormCard.FormTextDelegate {
            text: "Always visible text"
        }
        FormCard.FormDelegateSeparator {
            below: collapsible.itemBelowPrev
        }
        FormDelegateCollapsible {
            id: collapsible
            text: "Collapsible"
            description: expanded ? "Click to close!" : "Click to open!"

            FormCard.FormTextDelegate {
                text: "Initially hidden text"
            }
            FormCard.FormDelegateSeparator {}
            FormCard.FormTextDelegate {
                text: "When you click the Collapsible's button, it opens!"
            }
        }
        FormCard.FormDelegateSeparator {
            above: collapsible.itemAboveNext
        }
        FormCard.FormTextDelegate {
            text: "Always visible text"
        }
    }
   \endqml

   \image formcollapsibledelegate.png Form cards utilizing the collapsible delegate

   \since 1.14.0
 */
ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: 0

    /*!
       \brief The buttonDelegate's text.
     */
    property alias text: buttonDelegate.text

    /*!
       \brief The buttonDelegate's description.
     */
    property alias description: buttonDelegate.description

    /*!
       \brief The buttonDelegate itself.
     */
    readonly property FormButtonDelegate button: buttonDelegate

    default property alias childElements: internalLayout.data

    /*!
       \brief Controls if the button should be expanded.
     */
    property bool expanded: false

    /*!
       \brief The delegate visually below the previous delegate. When a FormDelegateSeparator is above this, bind its "below" property to this.
     */
    readonly property Item itemBelowPrev: buttonDelegate

    /*!
       \brief The delegate visually above the delegate following the collapsible. When a FormDelegateSeparator is below this, bind its "above" property to this.
     */
    readonly property Item itemAboveNext: expanded ? internalLayout.children[internalLayout.children.length - 1] : buttonDelegate

    FormButtonDelegate {
        id: buttonDelegate
        onClicked: root.expanded = !root.expanded
        trailingLogo.direction: Qt.ArrowType.DownArrow

        states: State {
            name: "open"
            when: root.expanded

            PropertyChanges {
                buttonDelegate.trailingLogo.direction: Qt.ArrowType.UpArrow
            }
        }
    }

    FormDelegateSeparator {
        visible: internalLayout.opacity > 0
    }

    ColumnLayout {
        id: internalLayout
        clip: true
        spacing: 0
        Layout.fillWidth: true

        opacity: 0
        visible: opacity > 0

        // animation poorly handles using Layout.preferredHeight directly
        property real currentHeight: 0
        Layout.preferredHeight: currentHeight

        states: State {
            name: "open"
            when: root.expanded

            PropertyChanges {
                internalLayout.opacity: 1
                internalLayout.currentHeight: internalLayout.implicitHeight
            }
        }

        transitions: Transition {
            to: "open"
            reversible: true

            ParallelAnimation {
                PropertyAnimation {
                    property: "currentHeight"
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
                PropertyAnimation {
                    property: "opacity"
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
