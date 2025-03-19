// SPDX-FileCopyrightText: 2024 Carl Schwan <carl\carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.settings.private as Private
import org.kde.kirigamiaddons.statefulapp as StatefulApp

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
       \l {Kirigami Addons StatefulApplication QML Types} module.
     */
    required property StatefulApp.AbstractKirigamiApplication application

    moduleId: "shortcuts"
    text: i18ndc("kirigami-addons6", "@action:button", "Keyboard Shortcuts")
    icon.name: "input-keyboard-symbolic"
    page: () => Qt.createComponent("org.kde.kirigamiaddons.statefulapp.private", "ShortcutsEditor")
    visible: !Kirigami.Settings.isMobile
    initialProperties: () => {
        return {
            model: root.application.shortcutsModel
        };
    }
}
