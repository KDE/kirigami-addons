// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
//
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

/*!
   \qmltype BottomDrawer
   \inqmlmodule org.kde.kirigamiaddons.components.templates
   \brief Shared content, header layout and behavior for bottom drawers.
 */
QQC2.Drawer {
    id: root

    /*!
       \qmlproperty Item drawerContentItem
       \brief This property holds the content item of the drawer.
     */
    default property alias drawerContentItem: drawerContent.contentItem

    /*!
       \qmlproperty Item headerContentItem
       \brief This property holds the content item of the drawer header.

       When no headerContentItem is set, the header will not be displayed.
     */
    property alias headerContentItem: headerContent.contentItem

    /*! \internal The component used for the drag handle. */
    property Component _handle

    /*! \internal The spacing around the drag handle when a header is shown. */
    property real _handleMargin: 0

    /*! \internal The spacing around the drag handle without a header. */
    property real _handleMarginWithoutHeader: _handleMargin

    /*! \internal The horizontal padding around the header content. */
    property alias _headerHorizontalPadding: headerContent.horizontalPadding

    /*! \internal The padding below the header content. */
    property alias _headerBottomPadding: headerContent.bottomPadding

    /*! \internal The background behind the header and handle. */
    property alias _headerBackground: headerContainer.background

    /*! \internal The background behind the drawer content. */
    property alias _contentBackground: drawerContent.background

    /*! \internal The separator between the header and content. */
    property Component _separator

    component Handle: Loader {
        sourceComponent: root._handle
        Layout.margins: root._handleMargin
        Layout.alignment: Qt.AlignHCenter
    }

    edge: Qt.BottomEdge
    width: QQC2.ApplicationWindow.window?.width ?? 0
    height: Math.min(contentItem.implicitHeight + root.topInset + root.topPadding + root.bottomInset + root.bottomPadding,
                     Math.round((QQC2.ApplicationWindow.window?.height ?? 0) * 0.8))

    // makes sure the drawer is not able to be opened when not triggered
    interactive: false

    onAboutToShow: root.interactive = true
    onClosed: root.interactive = false

    contentItem: ColumnLayout {
        spacing: 0

        QQC2.Control {
            id: headerContainer

            visible: headerContentItem && headerContentItem.enabled
            implicitWidth: header.implicitWidth
            implicitHeight: header.implicitHeight

            Layout.fillWidth: true

            contentItem: ColumnLayout {
                id: header

                spacing: 0

                Handle {
                    // drag indicator displayed when there is a headerContentItem
                }

                QQC2.Control {
                    id: headerContent

                    topPadding: 0
                    horizontalPadding: 0
                    bottomPadding: 0

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
        }

        Handle {
            // drag indicator displayed when there is no headerContentItem
            visible: !(headerContentItem && headerContentItem.enabled)
            Layout.margins: root._handleMarginWithoutHeader
        }

        Loader {
            sourceComponent: root._separator
            Layout.fillWidth: true
        }

        QQC2.Control {
            id: drawerContent

            Layout.fillWidth: true
            Layout.fillHeight: true

            leftPadding: 0
            rightPadding: 0
            topPadding: 0
            bottomPadding: parent.SafeArea.margins.bottom
        }
    }
}
