// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick

/**
 * Configuration module for spellchecking.
 */
ConfigurationModule {
    moduleId: "spellchecking"
    text: i18ndc("kirigami-addons6", "@action:button", "Spell Checking")
    icon.name: "tools-check-spelling"
    page: () => Qt.createComponent("org.kde.kirigamiaddons.settings.private", "SonnetConfigPage")
    visible: Qt.platform.os !== "android"
}
