// SPDX-FileCopyrightText: 2024 Carl Schwan <carl\carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import org.kde.kirigamiaddons.private
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.settings.private as Private
import org.kde.kirigamiaddons.actions as KirigamiActions

/*!
   \qmltype ShortcutsConfigurationModule
   \inqmlmodule org.kde.kirigamiaddons.settings
   \brief Configuration module for keyboard shortcuts.

   \since 1.7.0
 */
ConfigurationModule {
    id: root

    /*!
       This property holds the \l AbstractKirigamiApplication from the
       \l {Kirigami Addons Actions QML Types} module.
     */
    required property KirigamiActions.AbstractKirigamiApplication application

    moduleId: "shortcuts"
    text: I18n.i18nc("@action:button", "Keyboard Shortcuts")
    icon.name: "input-keyboard-symbolic"
    page: () => Qt.createComponent("org.kde.kirigamiaddons.statefulapp.private", "ShortcutsEditor")
    visible: !Kirigami.Settings.isMobile
    keywords: [
        I18n.i18nc("@info:search keyword", "Hotkey"),
        I18n.i18nc("@info:search keyword", "Key binding"),
        I18n.i18nc("@info:search keyword", "Accelerator")
    ]
    initialProperties: () => {
        return {
            model: root.application.shortcutsModel
        };
    }
}
