// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import Qt.labs.platform
import org.kde.kirigamiaddons.statefulapp.private as Private
import org.kde.kirigamiaddons.actions as KirigamiActions

/*!
   \qmltype NativeMenuItem
   \inqmlmodule org.kde.kirigamiaddons.actions.labs
   \brief An experimental Qt.labs.platform.MenuItem defined by a QAction.

   This API is experimental and may change without notice.

   \qml
   import Qt.labs.platform as Labs
   import org.kde.kirigamiaddons.actions as KirigamiActions
   import org.kde.kirigamiaddons.actions.labs as KirigamiActionsLabs

   KirigamiActions.StatefulWindow {
       application: MyKoolApp

       Labs.MenuBar {
           Labs.Menu {
               KirigamiActionsLabs.NativeMenuItem {
                   actionName: 'add_notebook'
                   application: MyKoolApp
               }
           }
       }
   }
   \endqml
   \since 1.4.0
 */
MenuItem {
    /*!
       This property holds the action name defined in your AbstractKirigamiApplication implementation.
     */
    property string actionName

    /*!
       \qmlproperty AbstractKirigamiApplication application
       This property holds the AbstractKirigamiApplication where the action is defined.
     */
    property KirigamiActions.AbstractKirigamiApplication application: null

    /*!
       This property can be used by generated menus to provide the resolved action
       directly when actions with the same name exist in multiple collections.
     */
    property QtObject actionObject: null

    readonly property QtObject _action: actionObject ?? application?.action(actionName)

    text: _action?.text ?? ''
    shortcut: _action?.shortcut
    icon.name: _action ? Private.Helper.iconName(_action.icon) : ''
    onTriggered: if (_action) {
        _action.trigger();
    }
    visible: !!_action && _action.text.length > 0
    checkable: !!_action && _action.checkable
    checked: !!_action && _action.checked
    enabled: !!_action && _action.enabled
    role: {
        switch (actionName) {
        case "open_about_page":
            return MenuItem.AboutRole;
        case "options_configure":
            return MenuItem.PreferencesRole;
        case "file_quit":
            return MenuItem.QuitRole;
        default:
            return MenuItem.NoRole;
        }
    }

    /*!
     */
    readonly property Shortcut alternateShortcut : Shortcut {
        sequences: Private.Helper.alternateShortcuts(_action)
        onActivated: root.trigger()
    }
}
