// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl\carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as Components
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kirigamiaddons.delegates as Delegates

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
T.Dialog {
    id: root

    enum DialogType {
        Success,
        Warning,
        Error,
        Information
    }

    /*!
       Selects the message style and its default icon and title. It can be:

       \value MessageDialog.Success
              For a success message.
       \value MessageDialog.Warning
              For a warning message.
       \value MessageDialog.Error
              For an error message.
       \value MessageDialog.Information
              For an informational message.

       \default MessageDialog.Success
     */
    property int dialogType: Components.MessageDialog.Success

    /*!
       \brief The configuration key used to store the "Do not show again" choice.

       When this property is non-empty, a checkbox is shown for supported
       standard button combinations. The choice is saved in the application
       configuration under \l configGroupName.

       Call \l openDialog() to show the dialog. A saved choice can suppress it
       and emit its corresponding result signal. A positive choice emits
       \c accepted() or \c applied(), depending
       on the button. A negative choice emits \c rejected() or \c discarded().
       Accepted and rejected button actions close the dialog.
       A choice is remembered only when a supported result button is clicked.
       Cancel and dismissing the dialog do not save a preference.
       Supported combinations have exactly one positive button (Ok, Open,
       Save, Save All, Yes, Yes to All, Apply, Retry, or Ignore), at most one
       negative button (No, No to All, or Discard), and optionally Cancel,
       Close, or Abort. Other combinations open normally without the checkbox.

       \warning Replacing \l {Dialog::contentItem}{contentItem} or
       \l {Dialog::footer}{footer}, or setting \l {Dialog::header}{header}, is
       unsupported. The dialog logs an error if any of these properties is
       changed.
       \default ""
     */
    property string dontShowAgainName: ''

    /*!
       \brief The configuration group used to store the "Do not show again" choice.

       \default "Notification Messages"
     */
    property string configGroupName: "Notification Messages"

    /*!
      \qmlproperty string MessageDialog::subtitle

      The message text shown below the title. For additional content, add
      child items to the dialog.
     */
    property string subtitle: ''

    /*!
       \qmlmethod AbstractButton MessageDialog::standardButton(StandardButton button)

       Returns the standard button matching \a button, or \c null if that
       button is not present in \c standardButtons.
     */
    function standardButton(button) {
        return dialogButtonBox.standardButton(button);
    }

    /*!
       \qmlproperty list<QtObject> MessageDialog::mainContent

       The default property for additional content items. Child items appear
       below the title and subtitle. Do not replace the dialog's
       \l {Dialog::contentItem}{contentItem}.
     */
    default property alias mainContent: mainLayout.data

    /*!
       \qmlproperty string MessageDialog::iconName

       The name of the icon shown beside the message. By default, this is
       selected from \l dialogType. Set it to an empty string to hide the icon.
     */
    property string iconName: switch (root.dialogType) {
    case MessageDialog.Success:
        return "data-success";
    case MessageDialog.Warning:
        return "data-warning";
    case MessageDialog.Error:
        return "data-error";
    case MessageDialog.Information:
        return "data-information";
    default:
        return "data-warning";
    }

    x: parent ? Math.round((parent.width - width) / 2) : 0
    y: parent ? Math.round((parent.height - height) / 2) : 0
    z: Kirigami.OverlayZStacking.z

    parent: applicationWindow() ? applicationWindow().QQC2.Overlay.overlay : null

    implicitWidth: if (!parent) {
        return implicitContentWidth
    } else if (parent.width > 576) {
        return Math.min(parent.width - Kirigami.Units.gridUnit * 2, Kirigami.Units.gridUnit * 25)
    } else {
        return parent.width - Kirigami.Units.gridUnit * 2;
    }

    implicitHeight: parent ? Math.min(Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding
                             + (implicitHeaderHeight > 0 ? implicitHeaderHeight + spacing : 0)
                             + (implicitFooterHeight > 0 ? implicitFooterHeight + spacing : 0)), parent.height - Kirigami.Units.gridUnit * 2, Kirigami.Units.gridUnit * 30) : implicitContentHeight

    title: switch (root.dialogType) {
    case MessageDialog.Success:
        return i18ndc("kirigami-addons6", "@title:dialog", "Success");
    case MessageDialog.Warning:
        return i18ndc("kirigami-addons6", "@title:dialog", "Warning");
    case MessageDialog.Error:
        return i18ndc("kirigami-addons6", "@title:dialog", "Error");
    case MessageDialog.Information:
        return i18ndc("kirigami-addons6", "@title:dialog", "Information");
    default:
        return i18ndc("kirigami-addons6", "@title:dialog", "Warning");
    }

    padding: Kirigami.Units.largeSpacing * 2

    property bool _automaticallyClosed: false
    readonly property var _positiveButtons: [T.Dialog.Ok, T.Dialog.Open, T.Dialog.Save, T.Dialog.SaveAll, T.Dialog.Yes, T.Dialog.YesToAll,
                                             T.Dialog.Apply, T.Dialog.Retry, T.Dialog.Ignore].filter(button => (root.standardButtons & button) !== 0)
    readonly property var _negativeButtons: [T.Dialog.No, T.Dialog.NoToAll, T.Dialog.Discard].filter(button => (root.standardButtons & button) !== 0)
    readonly property int _knownButtons: [..._positiveButtons, ..._negativeButtons, T.Dialog.Cancel, T.Dialog.Close, T.Dialog.Abort]
                                         .reduce((mask, button) => mask | button, 0)
    readonly property bool _supportsRememberedChoice: root._positiveButtons.length === 1 && root._negativeButtons.length <= 1
                                                    && (root.standardButtons & ~root._knownButtons) === 0

    /*!
       Open the dialog only if the user didn't check the "Do not remind me" checkbox
       previously. If a stored choice suppresses the dialog, its corresponding
       result signal is emitted instead.
     */
    function openDialog(): void {
        root._automaticallyClosed = false;
        checkbox.checked = false;

        if (root.dontShowAgainName.length > 0 && root._supportsRememberedChoice) {
            if (root.standardButtons === T.Dialog.Ok) {
                const show = MessageDialogHelper.shouldBeShownContinue(root.dontShowAgainName, root.configGroupName);
                if (!show) {
                    root._automaticallyClosed = true;
                    root.accepted();
                } else {
                    root.open();
                }
            } else {
                const result = MessageDialogHelper.shouldBeShownTwoActions(root.dontShowAgainName, root.configGroupName);
                if (!result.show && (result.result || root._negativeButtons.length > 0)) {
                    root._automaticallyClosed = true;
                    if (result.result) {
                        if (root._positiveButtons[0] === T.Dialog.Apply) {
                            root.applied();
                        } else {
                            root.accepted();
                        }
                    } else if (root._negativeButtons[0] === T.Dialog.Discard) {
                        root.discarded();
                    } else {
                        root.rejected();
                    }
                } else {
                    root.open();
                }
            }
        } else {
            root.open();
        }
    }

    contentItem: GridLayout {
        id: gridLayout

        columns: !icon.visible || root._mobileLayout ? 1 : 2
        rowSpacing: 0

        Kirigami.Icon {
            id: icon

            visible: root.iconName.length > 0
            source: root.iconName
            Layout.preferredWidth: Kirigami.Units.iconSizes.huge
            Layout.preferredHeight: Kirigami.Units.iconSizes.huge
            Layout.alignment: gridLayout.columns === 2 ? Qt.AlignTop : Qt.AlignHCenter
        }

        ColumnLayout {
            id: mainLayout

            spacing: Kirigami.Units.smallSpacing

            Layout.fillWidth: true

            Kirigami.Heading {
                text: root.title
                visible: root.title
                elide: QQC2.Label.ElideRight
                wrapMode: Text.WordWrap
                horizontalAlignment: gridLayout.columns === 2 ? Qt.AlignLeft : Qt.AlignHCenter

                Layout.fillWidth: true
            }

            QQC2.Label {
                text: root.subtitle
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }

    readonly property bool _mobileLayout: {
        if (root.width < Kirigami.Units.gridUnit * 20) {
            return true;
        }
        if (!footer) {
            return false;
        }
        let totalImplicitWidth = checkbox.implicitWidth + gridLayoutFooter.columnSpacing;
        for (let i = 0; i < repeater.count; i++) {
            totalImplicitWidth += repeater.itemAt(i).implicitWidth + gridLayoutFooter.columnSpacing
        }

        return totalImplicitWidth > footer.width;
    }

    footer: GridLayout {
        id: gridLayoutFooter

        columns: root._mobileLayout ? 1 : 1 + repeater.count + 1

        rowSpacing: Kirigami.Units.mediumSpacing
        columnSpacing: Kirigami.Units.mediumSpacing

        QQC2.CheckBox {
            id: checkbox

            visible: root.dontShowAgainName.length > 0 && root._supportsRememberedChoice
            text: i18ndc("kirigami-addons6", "@label:checkbox", "Do not show again")
            background: null

            Layout.fillWidth: true
            Layout.leftMargin: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
            Layout.bottomMargin: root._mobileLayout ? 0 : Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
            Layout.rightMargin: root._mobileLayout ? Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing : Kirigami.Units.smallSpacing
        }

        Item {
            visible: !checkbox.visible
            Layout.fillWidth: true
        }

        Repeater {
            id: repeater
            model: dialogButtonBox.contentModel
        }

        T.DialogButtonBox {
            id: dialogButtonBox

            standardButtons: root.standardButtons

            onClicked: (button) => {
                if (!root.dontShowAgainName || !root._supportsRememberedChoice || !checkbox.checked || root._automaticallyClosed) {
                    return;
                }

                if (button === dialogButtonBox.standardButton(root._positiveButtons[0])) {
                    if (root.standardButtons === T.Dialog.Ok) {
                        MessageDialogHelper.saveDontShowAgainContinue(root.dontShowAgainName, root.configGroupName);
                    } else {
                        MessageDialogHelper.saveDontShowAgainTwoActions(root.dontShowAgainName, root.configGroupName, true);
                    }
                } else if (root._negativeButtons.length > 0 && button === dialogButtonBox.standardButton(root._negativeButtons[0])) {
                    MessageDialogHelper.saveDontShowAgainTwoActions(root.dontShowAgainName, root.configGroupName, false);
                }
            }

            onAccepted: root.accept();
            onDiscarded: root.discarded();
            onApplied: root.applied();
            onHelpRequested: root.helpRequested();
            onRejected: root.reject();

            implicitWidth: 0
            implicitHeight: 0

            contentItem: Item {}
            delegate: QQC2.Button {
                property int index: repeater.model.children.indexOf(this)

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
                    return index === repeater.count - 1 ? Kirigami.Units.smallSpacing : 0;
                }
                Layout.bottomMargin: root._mobileLayout && index !== repeater.count - 1 ? 0 : Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
            }

            onStandardButtonsChanged: {
                // standardButton() returns a pointer to an existing standard button.
                // If no such button exists, it returns null.
                // Icon names are copied from KStyle::standardIcon()
                function setStandardIcon(buttonType, iconName) {
                    const button = standardButton(buttonType)
                    if (button && button.icon.name === "" && button.icon.source.toString() === "") {
                        button.icon.name = iconName
                    }
                }
                setStandardIcon(T.Dialog.Ok, "dialog-ok")
                setStandardIcon(T.Dialog.Save, "document-save")
                setStandardIcon(T.Dialog.SaveAll, "document-save-all")
                setStandardIcon(T.Dialog.Open, "document-open")
                setStandardIcon(T.Dialog.Yes, "dialog-ok-apply")
                setStandardIcon(T.Dialog.YesToAll, "dialog-ok")
                setStandardIcon(T.Dialog.No, "dialog-cancel")
                setStandardIcon(T.Dialog.NoToAll, "dialog-cancel")
                setStandardIcon(T.Dialog.Abort, "dialog-cancel")
                setStandardIcon(T.Dialog.Retry, "view-refresh")
                setStandardIcon(T.Dialog.Ignore, "dialog-cancel")
                setStandardIcon(T.Dialog.Close, "dialog-close")
                setStandardIcon(T.Dialog.Cancel, "dialog-cancel")
                setStandardIcon(T.Dialog.Discard, "edit-delete")
                setStandardIcon(T.Dialog.Help, "help-contents")
                setStandardIcon(T.Dialog.Apply, "dialog-ok-apply")
                setStandardIcon(T.Dialog.Reset, "edit-undo")
                setStandardIcon(T.Dialog.RestoreDefaults, "document-revert")
            }
        }
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            easing.type: Easing.InOutQuad
            duration: Kirigami.Units.longDuration
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1
            to: 0
            easing.type: Easing.InOutQuad
            duration: Kirigami.Units.longDuration
        }
    }

    modal: true
    focus: true

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
