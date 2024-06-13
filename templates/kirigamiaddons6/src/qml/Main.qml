// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.statefulapp as StatefulApp
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.%{APPNAMELC}

StatefulApp.StatefulWindow {
    id: root

    property int counter: 0

    title: i18nc("@title:window", "%{APPNAME}")

    minimumWidth: Kirigami.Units.gridUnit * 20
    minimumHeight: Kirigami.Units.gridUnit * 20

    application: %{APPNAME}Application

    Connections {
        target: %{APPNAME}Application

        function onIncrementCounter(): void {
            root.counter += 1;
        }

        function onOpenConfigurations(): void {
            
        }
    }

    globalDrawer: Kirigami.GlobalDrawer {
        isMenu: !Kirigami.Settings.isMobile
        actions: [
            StatefulApp.Action {
                id: incrementCounterAction
                actionName: "increment_counter"
                application: %{APPNAME}Application
            },
            Kirigami.Action {
                separator: true
            },
            StatefulApp.Action {
                actionName: "options_configure"
                application: %{APPNAME}Application
            },
            StatefulApp.Action {
                actionName: "options_configure_keybinding"
                application: %{APPNAME}Application
            },
            Kirigami.Action {
                separator: true
            },
            StatefulApp.Action {
                id: aboutAction
                actionName: "open_about_page"
                application: %{APPNAME}Application
            },
            StatefulApp.Action {
                actionName: "open_about_kde_page"
                application: %{APPNAME}Application
            },
            StatefulApp.Action {
                actionName: "file_quit"
                application: %{APPNAME}Application
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
