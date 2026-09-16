// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQml

/*!
    \qmltype ActionMenu
    \inqmlmodule org.kde.kirigamiaddons.actions
    \brief A declarative menu containing named actions and separators.

    The compact \c actions property can be used for menus containing only
    actions. Use the ordered default property when separators or explicit
    ordering are needed.

    Each entry in \c mergedItems contains \c type and \c name. Action entries
    also contain the resolved \c action object used by menu presenters.

    \qml
    KirigamiActions.ActionMenu {
        name: "file"
        text: i18nc("@title:menu", "File")

        ActionMenu.Action { name: "open_pdf" }
        ActionMenu.Separator {}
        ActionMenu.Action { name: "quit" }
    }

    // Set \c menuBarVisible to false for menus presented only by ActionMenuPopup.
    \endqml

    \since 1.14.0
 */
ActionMenuData {
    id: root

    default property alias menuItems: root.items

    component Action: QtObject {
        property string name
    }

    component Separator: QtObject {
        readonly property bool separator: true
    }
}
