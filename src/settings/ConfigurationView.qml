// SPDX-FileCopyrightText: 2024 Carl Schwan <carl\carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import QtQml
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.settings.private as Private

/*!
   \qmltype ConfigurationView
   \inqmlmodule org.kde.kirigamiaddons.settings
   \brief This is an abstract view to display the configuration of an application.

   The various configuration modules can be defined by providing ConfigurationModule
   to the modules property.

   On desktop, this will display the modules in a list view and displaying
   the actual page next to it. On mobile, only the list of modules will be
   initially displayed.

   \qml
   import QtQuick.Controls as Controls
   import org.kde.kirigamiaddons.settings as KirigamiSettings

   Controls.Button {
       id: button

       KirigamiSettings.ConfigurationView {
           id: configuration

           window: button.Controls.ApplicationWindow.window as Kirigami.ApplicationWindow

           modules: [
               KirigamiSettings.ConfigurationModule {
                   moduleId: "appearance"
                   text: i18nc("@action:button", "Appearance")
                   icon.name: "preferences-desktop-theme-global"
                   page: () => Qt.createComponent("org.kde.tokodon", "AppearancePage")
               },
               ...
               KirigamiSettings.ConfigurationModule {
                   moduleId: "about"
                   text: i18nc("@action:button", "About Tokodon")
                   icon.name: "help-about"
                   page: () => Qt.createComponent("org.kde.kirigamiaddons.formcard", "AboutPage")
                   category: i18nc("@title:group", "About")
               },
               KirigamiSettings.ConfigurationModule {
                   moduleId: "aboutkde"
                   text: i18nc("@action:button", "About KDE")
                   icon.name: "kde"
                   page: () => Qt.createComponent("org.kde.kirigamiaddons.formcard", "AboutKDE")
                   category: i18nc("@title:group", "About")
               }
           ]
       }

       icon.name: 'settings-configure-symbolic'
       text: i18nc("@action:button", "Settings")

       onClicked: configuration.open()
   }
   \endqml

   This will result in the following dialog on desktop:

   \image settingsdialogdesktop.png

   And the following page on mobile:

   \image settingsdialogmobile.png

   \since 1.3.0
 */
QtObject {
    id: root

    /*!
       \brief This property holds the title of the config view.

       \default "Settings"
     */
    property string title: i18ndc("kirigami-addons6", "@title:window", "Settings")

    /*!
       \brief This property holds the list of pages for the settings.
     */
    property list<ConfigurationModule> modules

    /*!
       \brief This property holds the parent window.

       This needs to be set before calling open.
     */
    property Kirigami.ApplicationWindow window

    /*!
       \brief The current config page/window depending on platform.

       Null if one currently doesn't exist.
     */
    property QtObject configViewItem: null

    /*!
       Open the configuration window for the given \a defaultModule.

       The defaultModule corresponds to the moduleId of the default configuration that should be preselected when opening the configuration view.
       By default it is not specified, this will choose the first module.
     */
    function open(defaultModule = ''): void {
        if (root.configViewItem) {
            if (typeof root.configViewItem.requestActivate === "function") {
                Qt.callLater(root.configViewItem.requestActivate);
            }
            return;
        }

        if (Kirigami.Settings.isMobile) {
            const component = Qt.createComponent('org.kde.kirigamiaddons.settings.private', 'ConfigMobilePage');
            if (component.status === Component.Failed) {
                console.error(component.errorString());
                return;
            }
            root.configViewItem = root.window.pageStack.layers.push(component, {
                defaultModule: defaultModule,
                modules: root.modules,
                title: root.title,
                window: root.window,
            })
            root.configViewItem.backRequested.connect(() => {
                root.configViewItem.destroy();
                root.configViewItem = null;
            });
        } else {
            const component = Qt.createComponent('org.kde.kirigamiaddons.settings.private', 'ConfigWindow');
            if (component.status === Component.Failed) {
                console.error(component.errorString());
                return;
            }
            root.configViewItem = component.createObject(null, {
                defaultModule: defaultModule,
                modules: root.modules,
                width: Kirigami.Units.gridUnit * 50,
                height: Kirigami.Units.gridUnit * 30,
                minimumWidth: Kirigami.Units.gridUnit * 50,
                minimumHeight: Kirigami.Units.gridUnit * 30,
                title: root.title,
            });
            root.configViewItem.closing.connect(() => {
                root.configViewItem.destroy();
                root.configViewItem = null;
            });
        }
    }
}

