// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
// SPDX-License-Identifier: GPL-2.0-or-later

pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigamiaddons.settings as KirigamiSettings

KirigamiSettings.ConfigurationsView {
    id: root

    modules: [
        KirigamiSettings.ConfigurationModule {
            moduleId: "general"
            text: i18nc("@action:button", "General")
            icon.name: "preferences-system-symbolic"
            page: () => Qt.createComponent("org.kde.%{APPNAMELC}.settings", "GeneralPage")
        }
    ]
}