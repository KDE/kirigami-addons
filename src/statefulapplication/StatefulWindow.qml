// SPDX-FileCopyrightText: 2021 Carl Schwan <carlschwan@kde.org>
// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
//
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kirigamiaddons.statefulapp as StatefulApp
import org.kde.kirigamiaddons.statefulapp.private as Private

/**
 * @brief StatefulWindow will takes care of providing standard functionalities
 * for your application main window.
 *
 * This includes:
 * * Restoration of the window size accross restart
 * * Handle some of the standard actions defined in your KirigamiAbstractApplication
 * * (AboutKDE and AboutApp)
 * * A command bar to access all the defined shortcuts
 * * A shortcut editor
 *
 * @since 1.3.0
 */
Kirigami.ApplicationWindow {
    id: root

    /**
     * This property holds the AbstractKirigamiApplication of your application.
     *
     * The default AbstractKirigamiApplication set, just provides the following actions:
     * * KStandardActions::quit
     * * KStandardActions::keyBindings
     * * "Open Command Bar"
     * * "About App"
     * * "About KDE"
     *
     * These actions are also handled by StatefulWindow. If you need more overwrite AbstractKirigamiApplication::setupActions.
     *
     * @see AbstractKirigamiApplication
     */
    property StatefulApp.AbstractKirigamiApplication application: Private.DefaultKirigamiApplication {}

    property Item hoverLinkIndicator: QQC2.Control {
        parent: overlay.parent
        property alias text: linkText.text
        opacity: text.length > 0 ? 1 : 0

        Kirigami.OverlayZStacking.layer: Kirigami.OverlayZStacking.Drawer
        z: Kirigami.OverlayZStacking.z
        x: 0
        y: parent.height - implicitHeight
        contentItem: QQC2.Label {
            id: linkText
        }
        Kirigami.Theme.colorSet: Kirigami.Theme.View
        background: Rectangle {
             color: Kirigami.Theme.backgroundColor
        }
    }

    onClosing: Private.Helper.saveWindowGeometry(root)

    onWidthChanged: saveWindowGeometryTimer.restart()
    onHeightChanged: saveWindowGeometryTimer.restart()
    onXChanged: saveWindowGeometryTimer.restart()
    onYChanged: saveWindowGeometryTimer.restart()

    Component.onCompleted: Private.Helper.restoreWindowGeometry(root)

    // This timer allows to batch update the window size change to reduce
    // the io load and also work around the fact that x/y/width/height are
    // changed when loading the page and overwrite the saved geometry from
    // the previous session.
    Timer {
        id: saveWindowGeometryTimer
        interval: 1000
        onTriggered: Private.Helper.saveWindowGeometry(root)
    }

    pageStack.globalToolBar.style: Kirigami.ApplicationHeaderStyle.ToolBar

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
                height: Kirigami.Units.gridUnit * 30
            });
            openDialogWindow.Keys.escapePressed.connect(function() {
                openDialogWindow.closeDialog();
            });
        }

        function onOpenAboutKDEPage(): void {
            const openDialogWindow = pageStack.pushDialogLayer(Qt.createComponent("org.kde.kirigamiaddons.formcard", "AboutKDE"), {
                width: root.width
            }, {
                width: Kirigami.Units.gridUnit * 30,
                height: Kirigami.Units.gridUnit * 30
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