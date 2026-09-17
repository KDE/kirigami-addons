// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.actions as KirigamiActions
import org.kde.kirigamiaddons.formcard as FormCard

import org.kde.%{APPNAMELC}
import org.kde.%{APPNAMELC}.settings as Settings

KirigamiActions.StatefulWindow {
    id: root

    property int counter: 0

    title: i18nc("@title:window", "%{APPNAME}")

    windowName: "%{APPNAME}"

    minimumWidth: Kirigami.Units.gridUnit * 20
    minimumHeight: Kirigami.Units.gridUnit * 20

    application: KirigamiActions.Application {
        configurationView: Settings.%{APPNAME}ConfigurationView {}
    }

    Kirigami.Action {
        id: incrementCounterAction
        text: i18nc("@action:inmenu", "Increment")
        onTriggered: root.counter += 1
    }

    KirigamiActions.ActionCollection {
        application: root.application
        name: "main"

        KirigamiActions.ActionData {
            name: "increment_counter"
            icon.name: "list-add-symbolic"
            defaultShortcut: "Ctrl+I"
            action: incrementCounterAction
        }
    }

    globalDrawer: Kirigami.GlobalDrawer {
        isMenu: !Kirigami.Settings.isMobile
        actions: [
            Kirigami.Action {
                fromQAction: incrementCounterAction
            },
            Kirigami.Action {
                separator: true
            },
            Kirigami.Action {
                fromQAction: root.application.action("options_configure")
            },
            Kirigami.Action {
                fromQAction: root.application.action("options_configure_keybinding")
            },
            Kirigami.Action {
                separator: true
            },
            Kirigami.Action {
                id: aboutAction
                fromQAction: root.application.action("open_about_page")
            },
            Kirigami.Action {
                fromQAction: root.application.action("open_about_kde_page")
            },
            Kirigami.Action {
                fromQAction: root.application.action("file_quit")
            }
        ]
    }

    pageStack.initialPage: FormCard.FormCardPage {
        id: page

        title: i18nc("@title", "%{APPNAME}")

        actions: [incrementCounterAction]

        Kirigami.Icon {
            source: "applications-development"
            implicitWidth: Math.round(Kirigami.Units.iconSizes.huge * 1.5)
            implicitHeight: Math.round(Kirigami.Units.iconSizes.huge * 1.5)

            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Kirigami.Units.largeSpacing * 4
        }

        Kirigami.Heading {
            text: i18nc("@title", "Welcome to %{APPNAME}") + '\n' + i18nc("@info:status", "Counter: %1", root.counter)
            horizontalAlignment: Qt.AlignHCenter

            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.fillWidth: true
        }

        FormCard.FormCard {
            Layout.topMargin: Kirigami.Units.largeSpacing * 4

            FormCard.FormButtonDelegate {
                action: incrementCounterAction
            }

            FormCard.FormDelegateSeparator {}

            FormCard.FormButtonDelegate {
                action: aboutAction
            }
        }
    }
}
