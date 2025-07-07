// SPDX-FileCopyrightText: 2025 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kirigamiaddons.delegates as Delegates
import org.kde.kirigamiaddons.components as Components

Kirigami.ApplicationWindow {
    id: root

    title: "Kirigami Addons Delegates Test"

    width: Kirigami.Settings.isMobile ? 400 : 800
    height: Kirigami.Settings.isMobile ? 550 : 500

    pageStack {
        defaultColumnWidth: Kirigami.Units.gridUnit * 35
        initialPage: FormCard.FormCardPage {

            FormCard.FormCard {
                Layout.topMargin: Kirigami.Units.gridUnit

                FormCard.FormButtonDelegate {
                    text: "Open Context meu"
                    onClicked: menu.popup()
                }
            }

            FormCard.FormHeader {
                title: i18nc("@title:group", "Display Mode")
            }

            FormCard.FormCard {
                FormCard.FormRadioDelegate {
                    text: i18nc("@option:radio", "Bottom Drawer")
                    checked: true
                    onToggled: if (checked) {
                        menu.displayMode = Components.ConvergentContextMenu.BottomDrawer
                    }
                }

                FormCard.FormRadioDelegate {
                    text: i18nc("@option:radio", "Dialog")
                    onToggled: if (checked) {
                        menu.displayMode = Components.ConvergentContextMenu.Dialog
                    }
                }

                FormCard.FormRadioDelegate {
                    text: i18nc("@option:radio", "Context menu")
                    onToggled: if (checked) {
                        menu.displayMode = Components.ConvergentContextMenu.ContextMenu
                    }
                }
            }

            FormCard.FormHeader {
                title: i18nc("@title:group", "Display Mode")
            }

            FormCard.FormCard {
                FormCard.FormSwitchDelegate {
                    text: i18nc("@option:check", "With custom title")
                    checked: true
                    onToggled: if (checked) {
                        menu.headerContentItem = customHeader;
                        customHeader.visible = true;
                    } else {
                        menu.headerContentItem = null;
                        customHeader.visible = false;
                    }
                }
            }

        }
    }

    // Dummy implementation of ki18n
    function i18nd(context, text) {
        return text;
    }

    function i18ndp(context, text1, text2, number) {
        return number === 1 ? text1 : text2;
    }

    function i18ndc(context, text) {
        return text
    }

    function i18nc(context, text) {
        return text;
    }

    Components.ConvergentContextMenu {
        id: menu

        parent: root.Controls.Overlay.overlay

        displayMode: Components.ConvergentContextMenu.BottomDrawer

        headerContentItem: RowLayout {
            id: customHeader

            spacing: Kirigami.Units.largeSpacing

            Components.Avatar {
                name: "Room Name"
            }

            ColumnLayout {
                spacing: 0

                Kirigami.Heading {
                    level: 2
                    text: "Room Name"
                }

                Controls.Label {
                    text: "Room description"
                }
            }
        }

        Controls.Action {
            text: i18nc("@action:inmenu", "Simple Action")
        }

        Kirigami.Action {
            text: i18nc("@action:inmenu", "Nested Action")

            Controls.Action {
                text: i18nc("@action:inmenu", "Simple Action 1")
            }

            Controls.Action {
                text: i18nc("@action:inmenu", "Simple Action 2")
            }

            Controls.Action {
                text: i18nc("@action:inmenu", "Simple Action 3")
            }
        }

        Kirigami.Action {
            text: i18nc("@action:inmenu", "Nested Action with Multiple Choices")

            Kirigami.Action {
                text: i18nc("@action:inmenu", "Follow Global Settings")
                checkable: true
                autoExclusive: true // Since KF 6.10
            }

            Kirigami.Action {
                text: i18nc("@action:inmenu", "Enabled")
                checkable: true
                autoExclusive: true // Since KF 6.10
            }

            Kirigami.Action {
                text: i18nc("@action:inmenu", "Disabled")
                checkable: true
                autoExclusive: true // Since KF 6.10
            }
        }

        // custom FormCard delegate only supported on mobile
        Kirigami.Action {
            visible: Kirigami.Settings.isMobile
            displayComponent: FormCard.FormButtonDelegate { 
                text: "Custom"
                description: "Custom description"
            }
        }
    }
}
