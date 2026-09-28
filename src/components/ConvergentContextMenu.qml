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
   \inqmlmodule org.kde.kirigamiaddons.components
   \brief A context menu that can appear as a standard menu, bottom drawer, or dialog.

   Add \l {QtQuick.Controls::Action} {QtQuick Controls actions} or
   \l {Action} {Kirigami actions} as child items. Kirigami actions can contain
   nested actions. By default, the menu uses a standard context menu on desktop
   and a bottom drawer on mobile. A Kirigami action's \c displayComponent can
   provide a custom delegate in BottomDrawer and Dialog modes.

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

       // A custom FormCard delegate is used in BottomDrawer and Dialog modes.
       Kirigami.Action {
           displayComponent: FormCard.FormButtonDelegate { ... }
       }
   }
   \endqml

   For a \c ListView, avoid creating a separate menu instance for every
   delegate. Keep one menu for the view, or define a \c Component and create a
   menu when it is needed. The example below creates a menu on demand and passes
   the current delegate's index to it:

   \qml
   import QtQuick
   import QtQuick.Controls as Controls
   import org.kde.kirigami as Kirigami
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

           // Open the menu for a platform context-menu request.
           Controls.ContextMenu.onRequested: (position) => openContextMenu()
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

    enum DisplayMode {
        BottomDrawer,
        ContextMenu,
        Dialog
    }

    /*!
       \qmlproperty list<Action> ConvergentContextMenu::actions
       The actions displayed in the menu. This is the default property, so add
       actions as child items.

       Each item can be a \l {QtQuick.Controls::Action} {QtQuick Controls action}
       or a \l {Action} {Kirigami action}. Kirigami actions can contain subactions.
     */
    default property list<T.Action> actions

    /*!
       Optional item displayed above the actions in the menu.

       \note This item is shown only at the top level in BottomDrawer and Dialog
       display modes. It is not shown in ContextMenu mode.
     */
    property Item headerContentItem

    /*!
       Whether the context menu is open.

       \note Changing this property does not open or close the menu. Use
       \l popup() and \l close() to control it.
     */
    property bool opened

    /*! \internal */
    property KirigamiComponents.BottomDrawer _mobileMenuItem: null

    /*! \internal */
    property QQC2.Dialog _dialogMenuItem: null

    /*! \internal */
    property P.ActionsMenu _desktopMenuItem: null

    /*!
       \brief The presentation used to display the context menu.

       By default, this is ContextMenu on desktop and BottomDrawer on mobile.

       \value ConvergentContextMenu.ContextMenu
              A standard context menu, typically used on desktop platforms.
       \value ConvergentContextMenu.BottomDrawer
              A bottom drawer that displays nested actions on separate pages.
       \value ConvergentContextMenu.Dialog
              A dialog that displays nested actions on separate pages.
     */
    property int displayMode: Kirigami.Settings.isMobile ? ConvergentContextMenu.BottomDrawer : ConvergentContextMenu.ContextMenu

    /*!
       Emitted when the context menu is closed.
     */
    signal closed

    /*!
       Close the currently open context menu.
     */
    function close(): void {
        if (_mobileMenuItem) {
            _mobileMenuItem.close();
            return;
        }

        if (_dialogMenuItem) {
            _dialogMenuItem.close();
            return;
        }

        if (_desktopMenuItem) {
            _desktopMenuItem.close();
        }
    }

    /*!
       Open the context menu.

       \a parent The item that owns the menu and, in ContextMenu mode, the item
       it is positioned relative to. If omitted, the menu uses this component as
       its parent.

       \a position The location in \a parent's coordinate system where a
       ContextMenu should open. This argument is used only in ContextMenu mode.
     */
    function popup(parent = null, position = null): void {
        if (displayMode === ConvergentContextMenu.BottomDrawer) {
            if (parent) {
                root._mobileMenuItem = mobileMenu.createObject(parent);
                root._mobileMenuItem.open();
            } else {
                root._mobileMenuItem = mobileMenu.createObject(root);
                root._mobileMenuItem.open();
            }
        } else if (displayMode === ConvergentContextMenu.Dialog) {
            if (parent) {
                root._dialogMenuItem = dialogMenu.createObject(parent);
                root._dialogMenuItem.open();
            } else {
                root._dialogMenuItem = dialogMenu.createObject(root);
                root._dialogMenuItem.open();
            }
        } else if (displayMode === ConvergentContextMenu.ContextMenu) {
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
            submenuComponent: P.ActionsMenu { visible: false }
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

            modal: true

            onClosed: {
                root.opened = false;
                root.closed();
                destroy();
                root._mobileMenuItem = null;
            }

            headerContentItem: ColumnLayout {
                children: if (stackViewMenu.depth > 1) {
                    return nestedHeader;
                } else if (root.headerContentItem === null) {
                    return null;
                } else {
                    root.headerContentItem.Layout.fillWidth = true;
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
                    popup: drawer
                }
            }
        }
    }

    Component {
        id: dialogMenu

        QQC2.Dialog {
            id: menuDialog

            background: DialogRoundedBackground {}

            anchors.centerIn: root.parent

            width: Math.min(root.parent.width - Kirigami.Units.gridUnit * 4, Kirigami.Units.gridUnit * 30)
            height: Math.min(root.parent.height - Kirigami.Units.gridUnit * 4, implicitHeight)

            rightPadding: 0
            leftPadding: 0
            bottomPadding: 0
            topPadding: 0

            modal: true

            onClosed: {
                root.opened = false;
                root.closed();
                destroy();
                root._dialogMenuItem = null;
            }

            header: RowLayout {
                spacing: Kirigami.Units.smallSpacing

                ColumnLayout {
                    spacing: Kirigami.Units.smallSpacing

                    Layout.leftMargin: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
                    Layout.topMargin: Kirigami.Units.largeSpacing
                    Layout.bottomMargin: Kirigami.Units.largeSpacing
                    Layout.fillWidth: true

                    children: if (stackViewMenu.depth > 1) {
                        return nestedHeader;
                    } else if (root.headerContentItem === null) {
                        return null;
                    } else {
                        root.headerContentItem.Layout.fillWidth = true;
                        return root.headerContentItem;
                    }
                }

                QQC2.ToolButton {
                    id: closeButton

                    icon.name: hovered ? "window-close" : "window-close-symbolic"
                    text: i18ndc("kirigami-addons6", "@action:button close dialog", "Close")
                    display: QQC2.AbstractButton.IconOnly
                    visible: true

                    onClicked: menuDialog.close()

                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    Layout.rightMargin: Kirigami.Units.largeSpacing
                    Layout.topMargin: Kirigami.Units.largeSpacing
                    Layout.bottomMargin: Kirigami.Units.largeSpacing
                }
            }

            Kirigami.Separator {
                width: menuDialog.width
                anchors.top: contentItem.top
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

            contentItem: QQC2.StackView {
                id: stackViewMenu

                implicitHeight: currentItem?.implicitHeight
                implicitWidth: currentItem?.implicitWidth
                topPadding: 1 // for the separator
                clip: true

                initialItem: P.ContextMenuPage {
                    stackView: stackViewMenu
                    actions: root.actions
                    popup: menuDialog
                }
            }
        }
    }
}
