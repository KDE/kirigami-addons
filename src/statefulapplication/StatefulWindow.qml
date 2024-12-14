// SPDX-FileCopyrightText: 2021 Carl Schwan <carlschwan@kde.org>
// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
//
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.config as Config
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kirigamiaddons.statefulapp as StatefulApp
import org.kde.kirigamiaddons.statefulapp.private as Private
import org.kde.coreaddons as Core

/**
 * @brief StatefulWindow takes care of providing standard functionalities
 * for your application main window.
 *
 * This includes:
 * * Restoration of the window size accross restarts
 * * Handling some of the standard actions defined in your KirigamiAbstractApplication
 *   (AboutKDE and AboutApp)
 * * A command bar to access all the defined actions
 * * A shortcut editor
 *
 * @code
 * import org.kde.kirigamiaddons.statefulapp as StatefulApp
 * import org.kde.kirigamiaddons.settings as Settings
 *
 * StatefulApp.StatefulWindow {
 *     id: root
 *
 *     windowName: 'Main'
 *     application: MyApplication {
 *         configurationView: Settings.ConfigurationView { ... }
 *     }
 * }
 * @endcode
 *
 * @since KirigamiAddons 1.4.0
 */
Kirigami.ApplicationWindow {
    id: root

    /**
     * This property holds the window's name.
     *
     * This needs to be an unique identifier for your application and will be used to store
     * the state of the window in your application config.
     */
    property alias windowName: windowStateSaver.configGroupName

    /**
     * This property holds the AbstractKirigamiApplication of your application.
     *
     * The default AbstractKirigamiApplication provides the following actions:
     * * KStandardActions::quit
     * * KStandardActions::keyBindings
     * * "Open Command Bar"
     * * "About App"
     * * "About KDE" (if your application id starts with org.kde.)
     *
     * If you need more actions provide your own AbstractKirigamiApplication and overwrite
     * AbstractKirigamiApplication::setupActions.
     *
     * @see AbstractKirigamiApplication
     */
    property StatefulApp.AbstractKirigamiApplication application: Private.DefaultKirigamiApplication

    Config.WindowStateSaver {
        id: windowStateSaver
    }

    Connections {
        target: root.application

        function onOpenKCommandBarAction(): void {
            kcommandbarLoader.active = true;
        }

        function onShortcutsEditorAction(): void {
            const openDialogWindow = pageStack.pushDialogLayer(Qt.createComponent("org.kde.kirigamiaddons.statefulapp.private", 'ShortcutsEditor'), {
                width: root.width,
                model: root.application.shortcutsModel,
            }, {
                width: Kirigami.Units.gridUnit * 30,
                height: Kirigami.Units.gridUnit * 30,
                title: i18ndc("kirigami-addons6", "@title:window", "Shortcuts"),
            });
        }

        function onOpenAboutPage(): void {
            const openDialogWindow = pageStack.pushDialogLayer(Qt.createComponent("org.kde.kirigamiaddons.formcard", "AboutPage"), {
                width: root.width
            }, {
                width: Kirigami.Units.gridUnit * 30,
                height: Kirigami.Units.gridUnit * 30,
                title: i18ndc("kirigami-addons6", "@title:window", "About %1", Core.AboutData.displayName),
            });
            openDialogWindow.Keys.escapePressed.connect(function() {
                openDialogWindow.closeDialog();
            });
        }

        function onOpenAboutKDEPage(): void {
            const openDialogWindow = pageStack.pushDialogLayer(Qt.createComponent("org.kde.kirigamiaddons.formcard", "AboutKDEPage"), {
                width: root.width
            }, {
                width: Kirigami.Units.gridUnit * 30,
                height: Kirigami.Units.gridUnit * 30,
                title: i18ndc("kirigami-addons6", "@title:window", "About KDE"),
            });
            openDialogWindow.Keys.escapePressed.connect(function() {
                openDialogWindow.closeDialog();
            });
        }
    }

    Loader {
        id: kcommandbarLoader
        active: false
        sourceComponent: Private.KQuickCommandBarPage {
            application: root.application
            onClosed: kcommandbarLoader.active = false
            parent: root.QQC2.Overlay.overlay
        }
        onActiveChanged: if (active) {
            item.open()
        }
    }
}