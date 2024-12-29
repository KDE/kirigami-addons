// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
//
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import QtQuick.Layouts

/**
* @brief A bottom drawer component with a drag indicator.
*
* Example:
* @code{.qml}
* import org.kde.kirigamiaddons.delegates 1.0 as Delegates
* import org.kde.kirigamiaddons.components 1.0 as Components
*
* Components.BottomDrawer {
*     id: drawer
*
*     headerContentItem: Kirigami.Heading {
*         text: "Drawer"
*     }
*
*     Delegates.RoundedItemDelegate {
*         text: "Action 1"
*         icon.name: "list-add"
*         onClicked: {
*             doSomething()
*             drawer.close()
*         }
*     }

*     Delegates.RoundedItemDelegate {
*         text: "Action 1"
*         icon.name: "list-add"
*         onClicked: {
*             doSomething()
*             drawer.close()
*         }
*     }
* }
* @endcode
*
* @image html bottomdrawer.png
*
* @since KirigamiAddons 0.12.0
*/
QQC2.Drawer {
    id: root

    /**
    * @brief This property holds the content item of the drawer
    */
    default property alias drawerContentItem: drawerContent.contentItem

    /**
    * @brief This property holds the content item of the drawer header
    *
    * when no headerContentItem is set, the header will not be displayed
    */
    property alias headerContentItem: headerContent.contentItem

    component Handle: Rectangle {
        color: Kirigami.Theme.textColor
        radius: height
        opacity: 0.5

        implicitWidth: Math.round(Kirigami.Units.gridUnit * 2.5)
        implicitHeight: Math.round(Kirigami.Units.gridUnit / 4)

        Layout.margins: Kirigami.Units.mediumSpacing
        Layout.alignment: Qt.AlignHCenter
    }

    edge: Qt.BottomEdge
    width: applicationWindow().width
    height: Math.min(contentItem.implicitHeight, Math.round(applicationWindow().height * 0.8))

    // makes sure the drawer is not able to be opened when not trigered
    interactive : false

    background: Kirigami.ShadowedRectangle {
        corners {
            topRightRadius: Kirigami.Units.largeSpacing
            topLeftRadius: Kirigami.Units.largeSpacing
        }

        shadow {
            size: Kirigami.Units.gridUnit
            color: Qt.rgba(0, 0, 0, 0.5)
        }

        color: Kirigami.Theme.backgroundColor
    }

    onAboutToShow: root.interactive = true
    onClosed: root.interactive = false

    contentItem: ColumnLayout {
        spacing: 0

        Kirigami.ShadowedRectangle {
            id: headerBackground

            visible: headerContentItem && headerContentItem.enabled
            height: header.implicitHeight

            Kirigami.Theme.colorSet: Kirigami.Theme.Window
            color: Kirigami.Theme.backgroundColor

            Layout.fillWidth: true

            corners {
                topRightRadius: 10
                topLeftRadius: 10
            }

            ColumnLayout{
                id:header

                anchors.fill: parent
                spacing:0
                clip: true

                Handle {
                    // drag indicator displayed when there is a headerContentItem
                    id: handle
                }

                QQC2.Control {
                    id: headerContent

                    topPadding: 0
                    leftPadding: Kirigami.Units.mediumSpacing + handle.height
                    rightPadding: Kirigami.Units.mediumSpacing + handle.height
                    bottomPadding: Kirigami.Units.mediumSpacing + handle.height

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
        }

        Handle {
            // drag indecator displayed when there is no headerContentItem
            visible: !(headerContentItem && headerContentItem.enabled)
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.bottomMargin: Kirigami.Units.largeSpacing
        }

        Kirigami.Separator {
            Layout.fillWidth: true
        }

        QQC2.Control {
            id: drawerContent

            Layout.fillWidth: true
            Layout.fillHeight: true

            leftPadding: 0
            rightPadding: 0
            topPadding: 0
            bottomPadding: 0

            background: Rectangle {
                Kirigami.Theme.colorSet: Kirigami.Theme.View
                Kirigami.Theme.inherit: false
                color: Kirigami.Theme.backgroundColor
            }
        }
    }
}
