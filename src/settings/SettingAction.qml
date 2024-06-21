// SPDX-FileCopyrightText: 2021 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.20 as Kirigami

/**
 * @brief SettingAction defines a settings page, and is typically used by a CategorizedSettings object.
 * @inherit org::kde::kirigami::PagePoolAction
 * @deprecated Since 1.3.0, use ConfigurationModule instead.
 */
Kirigami.PagePoolAction {
    /**
     * @brief The name of the action for when it needs to be referenced.
     *
     * Primary use case if for setting a default page in CategorizedSettings.
     */
    required property string actionName

    pageStack: _stack
    pagePool: _pool
    basePage: _stack.initialPage

    checkable: false
}
