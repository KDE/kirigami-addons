// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
//
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components.templates as Templates

/*!
   \qmltype BottomDrawer
   \inqmlmodule org.kde.kirigamiaddons.components
   \brief A bottom drawer component with a drag indicator.

   Example:
   \qml
   import org.kde.kirigamiaddons.formcard as FormCard
   import org.kde.kirigamiaddons.components as Components

   Components.BottomDrawer {
       id: drawer

       headerContentItem: Kirigami.Heading {
           text: "Drawer"
       }

       ColumnLayout {
           spacing: 0

           FormCard.FormButtonDelegate {
               text: "Action 1"
               icon.name: "list-add-symbolic"
               onClicked: {
                   doSomething()
                   drawer.close()
               }
           }

           FormCard.FormButtonDelegate {
               text: "Action 2"
               icon.name: "list-remove-symbolic"
               onClicked: {
                   doSomething()
                   drawer.close()
               }
           }
       }
   }
   \endqml

   A drawer with a profile header and a scrollable list:

   \qml
   Components.BottomDrawer {
       id: drawer
       width: QQC2.ApplicationWindow.window.width

       headerContentItem: RowLayout {
           spacing: Kirigami.Units.smallSpacing

           Components.Avatar {
               name: "World"
           }

           ColumnLayout {
               Layout.leftMargin: Kirigami.Units.largeSpacing
               Layout.fillWidth: true
               spacing: Kirigami.Units.smallSpacing

               Kirigami.Heading {
                   text: "John Doe"
                   Layout.fillWidth: true
               }
               QQC2.Label {
                   text: "Last connection: 20.04.2042"
                   Layout.fillWidth: true
               }
           }
       }

       QQC2.ScrollView {
           implicitHeight: Math.max(view.implicitHeight, QQC2.ApplicationWindow.window.height * 0.8)

           ListView {
               id: view

               model: 40
               clip: true

               delegate: Delegates.RoundedItemDelegate {
                   required property int index

                   text: "Item " + index
               }
           }
       }
   }
   \endqml

   \image bottomdrawer.png

   \since 0.12.0
*/
Templates.BottomDrawer {
    _handleMargin: Kirigami.Units.mediumSpacing
    _handleMarginWithoutHeader: Kirigami.Units.largeSpacing
    _headerHorizontalPadding: Kirigami.Units.mediumSpacing + Math.round(Kirigami.Units.gridUnit / 4)
    _headerBottomPadding: _headerHorizontalPadding

    _handle: Rectangle {
        color: Kirigami.Theme.textColor
        radius: height
        opacity: 0.5
        implicitWidth: Math.round(Kirigami.Units.gridUnit * 2.5)
        implicitHeight: Math.round(Kirigami.Units.gridUnit / 4)
    }

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

    _headerBackground: Kirigami.ShadowedRectangle {
        Kirigami.Theme.colorSet: Kirigami.Theme.Window
        color: Kirigami.Theme.backgroundColor
        corners {
            topRightRadius: 10
            topLeftRadius: 10
        }
    }

    _separator: Kirigami.Separator {}

    _contentBackground: Rectangle {
        Kirigami.Theme.colorSet: Kirigami.Theme.View
        Kirigami.Theme.inherit: false
        color: Kirigami.Theme.backgroundColor
    }
}
