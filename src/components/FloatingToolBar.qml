// SPDX-FileCopyrightText: 2024 Mathis Brüchert <mbb@kaidan.im>
// SPDX-FileCopyrightText: 2024 Carl Schwan <carl\carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import org.kde.kirigami as Kirigami
import QtQuick.Controls

/*!
   \qmltype FloatingToolBar
   \inqmlmodule org.kde.kirigamiaddons.labs.components
   \brief A floating toolbar to use for example in a canvas.

   The toolbar should be positioned with \l {Units::largeSpacing}
   {Kirigami.Units.largeSpacing} from the border of the page.

   \qml
   import org.kde.kirigamiaddons.components
   import org.kde.kirigami as Kirigami

   FloatingToolBar {
       contentItem: Kirigami.ActionToolBar {
           actions: [
               Kirigami.Action {
                   ...
               }
           ]
       }
   }
   \endqml

   \image floatingtoolbar.png
 */
ToolBar {
    background: Kirigami.ShadowedRectangle {
        color: Kirigami.Theme.backgroundColor
        radius: Kirigami.Units.cornerRadius

        shadow {
            size: 15
            yOffset: 3
            color: Qt.rgba(0, 0, 0, 0.2)
        }

        border {
            color: Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, Kirigami.Theme.frameContrast)
            width: 1
        }

        Kirigami.Theme.inherit: false
        Kirigami.Theme.colorSet: Kirigami.Theme.Window
    }
}
