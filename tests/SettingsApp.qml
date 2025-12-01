// Copyright 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.delegates as Delegates
import org.kde.kirigamiaddons.settings as Settings

Kirigami.ApplicationWindow {
    id: root

    function i18nc(context, text) {
        return text;
    }

    pageStack.initialPage: Kirigami.Page {
        QQC2.Button {
            text: i18nc("@action:button", "Open settings")
            onClicked: root.pageStack.pushDialogLayer(settings);
        }
    }

    Component {
        id: settings
        Settings.CategorizedSettings {
            actions: [
                Settings.SettingAction {
                    actionName: "general"
                    icon.name: "preferences-desktop-theme-global"
                    text: i18nc("@window:title", "General")
                    page: Qt.resolvedUrl("TestSettingPage.qml#2")
                },
                Settings.SettingAction {
                    actionName: "appearance"
                    icon.name: "preferences-desktop-theme-global"
                    text: i18nc("@window:title", "Appeareance")
                    page: Qt.resolvedUrl("TestSettingPage.qml#1")
                }
            ]
        }
    }
}
