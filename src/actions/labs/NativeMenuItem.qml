// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import Qt.labs.platform
import org.kde.kirigamiaddons.statefulapp.private as Private
import org.kde.kirigamiaddons.statefulapp as StatefulApp

/*!
   \qmltype NativeMenuItem
   \inqmlmodule org.kde.kirigamiaddons.statefulapp.labs
   \brief A Qt.labs.platform.MenuItem defined by a QAction.

   \qml
   import Qt.labs.platform as Labs
   import org.kde.kirigamiaddons.statefulapp as StatefulApp
   import org.kde.kirigamiaddons.statefulapp.labs as StatefulAppLabs

   StatefulApp.StatefulWindow {
       application: MyKoolApp

       Labs.MenuBar {
           Labs.Menu {
               StatefulAppLabs.MenuItem {
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
    required property string actionName

    /*!
       \qmlproperty AbstractKirigamiApplication application
       This property holds the AbstractKirigamiApplication where the action is defined.
     */
    required property StatefulApp.AbstractKirigamiApplication application

    readonly property QtObject _action: application.action(actionName)

    text: _action?.text ?? ''
    shortcut: _action?.shortcut
    icon.name: _action ? Private.Helper.iconName(_action.icon) : ''
    onTriggered: if (_action) {
        _action.trigger();
    }
    visible: _action && _action.text.length > 0
    checkable: _action?.checkable
    checked: _action?.checked
    enabled: _action && _action.enabled

    /*!
     */
    readonly property Shortcut alternateShortcut : Shortcut {
        sequences: Private.Helper.alternateShortcuts(_action)
        onActivated: root.trigger()
    }
}
