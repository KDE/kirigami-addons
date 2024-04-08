// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import org.kde.kirigami as Kirigami

/**
 * A Kirigami.Action defined by a QAction.
 *
 * You only need to set the actionName and the action will be automatically imported from
 * the current KirigamiAbstractApplication subclass.
 *
 * @code{qml}
 * import org.kde.kirigamiaddons.managedapplication as ManagedApplication
 *
 * ManagedApplication.MainWindow {
 *     application: MyKoolApp
 *
 *     ManagedApp.Action {
 *         actionName: 'add_notebook'
 *     }
 * }
 * @endcode{}
 */
Kirigami.Action {
    required property string actionName

    readonly property var _action: applicationWindow().application.action(actionName)

    text: _action.text
    shortcut: _action.shortcut
    icon.name: applicationWindow().application.iconName(_action.icon)
    onTriggered: _action.trigger()
    visible: _action.text.length > 0
    checkable: _action.checkable
    checked: _action.checked
}
