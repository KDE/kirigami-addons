// SPDX-FileCopyrightText: 2024 Joshua Goins <josh@redstrate.com>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Controls as T
import QtQuick.Layouts
import Qt.labs.qmlmodels

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as KirigamiComponents
import org.kde.kirigamiaddons.formcard as FormCard

import './private' as P

/**
 * Menu popup that appears as a tradional menu on desktop and as a bottom
 * drawer mobile.
 *
 * @since 1.7.0.
 */
Item {
    id: root

    /**
     * This property holds the list of actions. This can be either tradional
     * action from QtQuick.Controls or a Kirigami.Action with sub actions.
     */
    default property list<T.Action> actions

    signal closed

    function popup(): void {
        if (Kirigami.Settings.isMobile) {
            mobileMenu.item.open();
        } else {
            desktopMenu.item.popup();
        }
    }

    Loader {
        id: desktopMenu
        active: !Kirigami.Settings.isMobile

        sourceComponent: P.ActionsMenu {
            actions: root.actions
            submenuComponent: P.ActionsMenu { }
            onClosed: root.closed()
        }
    }

    Loader {
        id: mobileMenu
        active: Kirigami.Settings.isMobile

        sourceComponent: KirigamiComponents.BottomDrawer {
            id: drawer

            parent: root.QQC2.Overlay.overlay
            onClosed: root.closed()

            headerContentItem: RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                enabled: stackView.currentItem?.title.length > 0

                QQC2.ToolButton {
                    icon.name: 'draw-arrow-back-symbolic'
                    text: i18ndc("kirigami-addons6", "@action:button", "Go Back")
                    display: QQC2.ToolButton.IconOnly
                    onClicked: stackView.pop();

                    QQC2.ToolTip.visible: hovered
                    QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                    QQC2.ToolTip.text: text
                }

                Kirigami.Heading {
                    level: 2
                    text: stackView.currentItem?.title
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }

            QQC2.StackView {
                id: stackView

                implicitHeight: currentItem?.implicitHeight
                implicitWidth: currentItem?.implicitWidth

                initialItem: P.ContextMenuPage {
                    stackView: stackView
                    actions: root.actions
                }
            }
        }
    }
}
