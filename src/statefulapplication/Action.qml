// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQml
import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.statefulapp.private as Private
import org.kde.kirigamiaddons.statefulapp as StatefulApp

/**
 * A Kirigami.Action defined by a QAction.
 *
 * @code{qml}
 * import org.kde.kirigamiaddons.statefulapp as StatefulApp
 *
 * StatefulApp.StatefulWindow {
 *     application: MyKoolApp
 *
 *     ManagedApp.Action {
 *         actionName: 'add_notebook'
 *         application: MyKoolApp
 *     }
 * }
 * @endcode{}
 * @since KirigamiAddons 1.4.0
 */
Kirigami.Action {
    id: root

    /**
     * This property holds the action name defined in your AbstractKirigamiApplication implementation.
     */
    required property string actionName

    /**
     * This property holds the AbstractKirigamiApplication where the action is defined.
     */
    required property StatefulApp.AbstractKirigamiApplication application

    readonly property QtObject _action: application.action(actionName)

    shortcut: _action?.shortcut
    text: _action?.text ?? ''
    icon.name: _action ? Private.Helper.iconName(_action.icon) : ''
    onTriggered: if (_action) {
        _action.trigger();
    }
    visible: _action && _action.text.length > 0
    checkable: _action?.checkable
    checked: _action?.checked
    enabled: _action && _action.enabled

    readonly property Shortcut alternateShortcut : Shortcut {
        sequences: Private.Helper.alternateShortcuts(_action)
        onActivated: root.trigger()
    }
}
