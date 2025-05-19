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

/*!
   \qmltype ConvergentContextMenu
   \inqmlmodule org.kde.kirigamiaddons.labs.components
   \brief Menu popup that appears as a tradional menu on desktop and as a bottom
   drawer mobile.

   ConvergentContextMenu uses abstract \l {QtQuick.Controls::Action} {QtQuick.Controls.Action}
   and \l {Action} {Kirigami.Action} to build
   the traditional menu on desktop and the bottom drawer on mobile. Most properties
   of Kirigami.Action are supported including nested actions.

   \qml
   import QtQuick.Controls as Controls
   import org.kde.kirigami as Kirigami
   import org.kde.kirigamiaddons.components as Components
   import org.kde.kirigamiaddons.formcard as FormCard

   Components.ConvergentContextMenu {
       id: root

       headerContentItem: RowLayout {
           spacing: Kirigami.Units.smallSpacing
           Kirigami.Avatar { ... }

           Kirigami.Heading {
               level: 2
               text: "Room Name"
           }
       }

       Controls.Action {
           text: i18nc("@action:inmenu", "Simple Action")
       }

       Kirigami.Action {
           text: i18nc("@action:inmenu", "Nested Action")

           Controls.Action { ... }

           Controls.Action { ... }

           Controls.Action { ... }
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
           displayComponent: FormCard.FormButtonDelegate { ... }
       }
   }
   \endqml

   When creating a menu for a ListView, avoid creating a ConvergentContextMenu for each delegate
   and instead create a global ConvergentContextMenu for the ListView or use a Component and dynamically
   instantiate the context menu on demand:

   \qml
   import QtQuick
   import QtQuick.Controls as Controls
   import org.kde.kirigamiaddons.components as Addons

   ListView {
       model: 10
       delegate: Controls.ItemDelegate {
           text: index

           function openContextMenu(): void {
               const item = menu.createObject(Controls.Overlay.overlay, {
                   index,
               });
               item.popup();
           }

           onPressAndHold: openContextMenu()

           // Since Qt 6.9
           Controls.ContextMenu.onRequested: (position) => openContextMenu()

           // Before Qt 6.9
           TapHandler {
               acceptedButtons: Qt.RightButton
               onSingleTapped: (eventPoint, button) => {
                   openContextMenu();
               }
           }
       }

       Component {
           id: menu

           Addons.ConvergentContextMenu {
               required property int index

               Controls.Action {
                   text: i18nc("@action:inmenu", "Action 1")
               }

               Kirigami.Action {
                   text: i18nc("@action:inmenu", "Action 2")

                   Controls.Action {
                       text: i18nc("@action:inmenu", "Sub-action")
                   }
               }
           }
       }
   }
   \endqml

   \since 1.7.0.
 */
Item {
    id: root

    /*!
       \qmlproperty list<Action> actions
       This property holds the list of actions.

       This can be either a traditional \l {QtQuick.Controls::Action} {QtQuick.Controls.Action}
       or a \l {Action} {Kirigami.Action} with sub actions.
     */
    default property list<T.Action> actions

    /*!
       Optional item which will be displayed as header of the internal ButtonDrawer.

       \note This is only displayed on the first level of the ContextMenu mobile mode.
     */
    property Item headerContentItem

    /*!
       This property holds whether the popup is fully open.

       \note Setting this property yourself does nothing. You must open the popup using popup().
     */
    property bool opened

    /*! \internal */
    property KirigamiComponents.BottomDrawer _mobileMenuItem: null

    /*! \internal */
    property P.ActionsMenu _desktopMenuItem: null

    /*!
       Emitted when the context menu is closed.
     */
    signal closed

    /*!
       Close the context menu.
     */
    function close(): void {
        if (_mobileMenuItem) {
            _mobileMenuItem.close();
            return;
        }

        if (_desktopMenuItem) {
            _desktopMenuItem.close();
        }
    }

    /*!
       Open the context menu.
     */
    function popup(parent = null, position = null): void {
        if (Kirigami.Settings.isMobile) {
            if (parent) {
                root._mobileMenuItem = mobileMenu.createObject(parent);
                root._mobileMenuItem.open();
            } else {
                root._mobileMenuItem = mobileMenu.createObject(root);
                root._mobileMenuItem.open();
            }
        } else {
            if (position && parent) {
                root._desktopMenuItem = desktopMenu.createObject(parent);
                root._desktopMenuItem.popup(position);
            } else if (parent) {
                root._desktopMenuItem = desktopMenu.createObject(parent);
                root._desktopMenuItem.popup();
            } else {
                root._desktopMenuItem = desktopMenu.createObject(root);
                root._desktopMenuItem.popup();
            }
        }
        root.opened = true;
    }

    Component {
        id: desktopMenu

        P.ActionsMenu {
            actions: root.actions
            submenuComponent: P.ActionsMenu { }
            modal: true
            onClosed: {
                root.opened = false;
                root.closed();
                destroy();
                root._desktopMenuItem = null;
            }
        }
    }

    Component {
        id: mobileMenu

        KirigamiComponents.BottomDrawer {
            id: drawer

            onClosed: {
                root.opened = false;
                root.closed();
                destroy();
                root._mobileMenuItem = null;
            }

            headerContentItem: ColumnLayout {
                children: if (stackViewMenu.depth > 1 || root.headerContentItem === null) {
                    return nestedHeader;
                } else {
                    return root.headerContentItem;
                }
            }

            property Item nestedHeader: RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                enabled: stackViewMenu.currentItem?.title.length > 0

                QQC2.ToolButton {
                    icon.name: 'draw-arrow-back-symbolic'
                    text: i18ndc("kirigami-addons6", "@action:button", "Go Back")
                    display: QQC2.ToolButton.IconOnly
                    onClicked: stackViewMenu.pop();

                    QQC2.ToolTip.visible: hovered
                    QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                    QQC2.ToolTip.text: text
                }

                Kirigami.Heading {
                    level: 2
                    text: stackViewMenu.currentItem?.title
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }

            QQC2.StackView {
                id: stackViewMenu

                implicitHeight: currentItem?.implicitHeight
                implicitWidth: currentItem?.implicitWidth

                initialItem: P.ContextMenuPage {
                    stackView: stackViewMenu
                    actions: root.actions
                    drawer: drawer
                }
            }
        }
    }
}
