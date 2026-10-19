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
   import org.kde.kirigamiaddons.delegates as Delegates
   import org.kde.kirigamiaddons.components as Components

   Components.BottomDrawer {
       id: drawer

       headerContentItem: Kirigami.Heading {
           text: "Drawer"
       }

       Delegates.RoundedItemDelegate {
           text: "Action 1"
           icon.name: "list-add"
           onClicked: {
               doSomething()
               drawer.close()
           }
       }

       Delegates.RoundedItemDelegate {
           text: "Action 1"
           icon.name: "list-add"
           onClicked: {
               doSomething()
               drawer.close()
           }
       }
   }
   \endqml

   \image bottomdrawer.png

   \since 0.12.0
*/
Templates.BottomDrawer {
    handleMargin: Kirigami.Units.mediumSpacing
    handleMarginWithoutHeader: Kirigami.Units.largeSpacing
    headerHorizontalPadding: Kirigami.Units.mediumSpacing + Math.round(Kirigami.Units.gridUnit / 4)
    headerBottomPadding: headerHorizontalPadding

    handle: Rectangle {
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

    headerBackground: Kirigami.ShadowedRectangle {
        Kirigami.Theme.colorSet: Kirigami.Theme.Window
        color: Kirigami.Theme.backgroundColor
        corners {
            topRightRadius: 10
            topLeftRadius: 10
        }
    }

    separator: Kirigami.Separator {}

    contentBackground: Rectangle {
        Kirigami.Theme.colorSet: Kirigami.Theme.View
        Kirigami.Theme.inherit: false
        color: Kirigami.Theme.backgroundColor
    }
}
