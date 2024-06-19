// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import Qt.labs.platform
import org.kde.kirigamiaddons.statefulapp.private as Private
import org.kde.kirigamiaddons.statefulapp as StatefulApp

/**
 * A Labs.MenuItem defined by a QAction.
 *
 * This requires setting both the actionName defined in your AbstractKirigamiApplication
 * implementation and your AbstractKirigamiApplication.
 *
 * @code{qml}
 * import Qt.labs.platform as Labs
 * import org.kde.kirigamiaddons.statefulapp as StatefulApp
 * import org.kde.kirigamiaddons.statefulapp.labs as StatefulAppLabs
 *
 * StatefulApp.StatefulWindow {
 *     application: MyKoolApp
 *
 *     Labs.MenuBar {
 *         Labs.Menu {
 *             StatefulAppLabs.MenuItem {
 *                 actionName: 'add_notebook'
 *                 application: MyKoolApp
 *             }
 *         }
 *     }
 * }
 * @endcode{}
 */
MenuItem {
    required property string actionName
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
    enabled: _action && _action.enabled && parent.enabled

    readonly property Shortcut alternateShortcut : Shortcut {
        sequences: Private.Helper.alternateShortcuts(_action)
        onActivated: root.trigger()
    }
}
