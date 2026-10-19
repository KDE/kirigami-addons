// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl\carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as Components
import org.kde.kirigamiaddons.components.templates as Templates

/*!
   \qmltype MessageDialog
   \inqmlmodule org.kde.kirigamiaddons.components
   \brief A message dialog with success, warning, error, and information styles.

   Set the \c title and \l subtitle to describe the message, choose a \l dialogType,
   and set \c standardButtons for the available actions. Add extra content as
   child items; it appears below the title and subtitle.

   \qml
   import QtQuick.Controls as Controls
   import org.kde.kirigamiaddons.components as Components

   Controls.ApplicationWindow {
       visible: true

       Components.MessageDialog {
           id: errorDialog

           dialogType: Components.MessageDialog.Error
           title: "Unable to connect"
           subtitle: "Check your network connection and try again."
           dontShowAgainName: "connectionError"
           standardButtons: Controls.Dialog.Ok
       }

       Controls.Button {
           text: "Show message"
           onClicked: errorDialog.openDialog()
       }
   }
   \endqml

   Call \l openDialog() to show the dialog and honor any saved choice. Set
   \l dontShowAgainName to offer a persistent "Do not show again" checkbox.

   \image messagedialog.png
 */
Templates.MessageDialog {
    id: root

    _buttonDelegate: QQC2.Button {
        property int index: root._buttonModel.children.indexOf(this)

        Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.DialogButton

        Layout.fillWidth: root._mobileLayout
        Layout.leftMargin: if (root._mobileLayout) {
            return Kirigami.Units.largeSpacing * 2;
        } else {
            return index === 0 ? Kirigami.Units.smallSpacing : 0;
        }
        Layout.rightMargin: if (root._mobileLayout) {
            return Kirigami.Units.largeSpacing * 2;
        } else {
            return index === root._buttonCount - 1 ? Kirigami.Units.smallSpacing : 0;
        }
        Layout.bottomMargin: root._mobileLayout && index !== root._buttonCount - 1 ? 0 : Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    }

    background: Components.DialogRoundedBackground {}

    // black background, fades in and out
    QQC2.Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.3)

        // the opacity of the item is changed internally by QQuickPopup on open/close
        Behavior on opacity {
            OpacityAnimator {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
    }
}
