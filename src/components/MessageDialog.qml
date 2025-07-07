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
   \brief A dialog to show a message. This dialog exists has 4 modes: success, warning, error, information.

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
       This property holds the dialogType. It can be either:

       \value MessageDialog.Success
              For a sucess message.
       \value MessageDialog.Warning
              For a warning message.
       \value MessageDialog.Error
              For an actual error.
       \value MessageDialog.Information
              For an informational message.

       \default MessageDialog.Success
     */
    property int dialogType: Components.MessageDialog.Success

    /*!
       \brief This property holds the name of setting to store the "Don't show again" preference.

       If provided, a checkbox is added with which further notifications can be turned off.
       The string is used to lookup and store the setting in the applications config file.
       The setting is stored in the "Notification Messages" group.

       When set, use openDialog() instead of open() to open this dialog.

       \warning Overwriting the dialog's footer will disable this feature.
       \default ""
     */
    property string dontShowAgainName: ''

    /*!
       \brief This property holds the name of the config group where the setting to store the "Don't show again" preference are stored.

       \default "Notification Messages"
     */
    property string configGroupName: "Notification Messages"

    /*!
      The text to use in the dialog's contents.
     */
    property string subtitle: ''

    function standardButton(button) {
        return dialogButtonBox.standardButton(button);
    }

    /*!
     */
    default property alias mainContent: mainLayout.data

    /*!
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

    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    z: Kirigami.OverlayZStacking.z

    parent: applicationWindow().QQC2.Overlay.overlay

    implicitWidth: Math.min(parent.width - Kirigami.Units.gridUnit * 2, Kirigami.Units.gridUnit * 25)
    implicitHeight: Math.min(Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding
                             + (implicitHeaderHeight > 0 ? implicitHeaderHeight + spacing : 0)
                             + (implicitFooterHeight > 0 ? implicitFooterHeight + spacing : 0)), parent.height - Kirigami.Units.gridUnit * 2, Kirigami.Units.gridUnit * 30)

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
    bottomPadding: Kirigami.Units.largeSpacing

    property bool _automaticallyClosed: false

    /*!
       Open the dialog only if the user didn't check the "Do not remind me" checkbox
       previously.
     */
    function openDialog(): void {
        if (root.dontShowAgainName.length > 0) {
            if (root.standardButtons === QQC2.Dialog.Ok) {
                const show = MessageDialogHelper.shouldBeShownContinue(root.dontShowAgainName, root.configGroupName);
                if (!show) {
                    root._automaticallyClosed = true;
                    root.applied();
                    root.accepted();
                } else {
                    checkbox.checked = false;
                    root._automaticallyClosed = false;
                    root.open();
                }
            } else {
                const result = MessageDialogHelper.shouldBeShownTwoActions(root.dontShowAgainName, root.configGroupName);
                if (!result.show) {
                    root._automaticallyClosed = true;
                    if (result.result) {
                        root.accepted();
                        root.applied();
                    } else {
                        root.discarded();
                    }
                } else {
                    checkbox.checked = false;
                    root._automaticallyClosed = false;
                    root.open();
                }
            }
        } else {
            root.open();
        }
    }

    onApplied: {
        if (root.dontShowAgainName && checkbox.checked && !root._automaticallyClosed) {
            if (root.standardButtons === QQC2.Dialog.Ok) {
                MessageDialogHelper.saveDontShowAgainContinue(root.dontShowAgainName, root.configGroupName);
            } else {
                MessageDialogHelper.saveDontShowAgainTwoActions(root.dontShowAgainName, root.configGroupName, true);
            }
        }
    }

    onAccepted: {
        if (root.dontShowAgainName && checkbox.checked && !root._automaticallyClosed) {
            if (root.standardButtons === QQC2.Dialog.Ok) {
                MessageDialogHelper.saveDontShowAgainContinue(root.dontShowAgainName, root.configGroupName);
            } else {
                MessageDialogHelper.saveDontShowAgainTwoActions(root.dontShowAgainName, root.configGroupName, true);
            }
        }
    }

    onDiscarded: {
        if (root.dontShowAgainName && checkbox.checked && !root._automaticallyClosed) {
            if (root.standardButtons === QQC2.Dialog.Ok) {
                MessageDialogHelper.saveDontShowAgainContinue(root.dontShowAgainName, root.configGroupName);
            } else {
                MessageDialogHelper.saveDontShowAgainTwoActions(root.dontShowAgainName, root.configGroupName, false);
            }
        }
    }

    onRejected: {
        if (root.dontShowAgainName && checkbox.checked && !root._automaticallyClosed) {
            if (root.standardButtons === QQC2.Dialog.Ok) {
                MessageDialogHelper.saveDontShowAgainContinue(root.dontShowAgainName);
            } else {
                MessageDialogHelper.saveDontShowAgainTwoActions(root.dontShowAgainName, false);
            }
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

            visible: dontShowAgainName.length > 0
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

            onAccepted: root.accepted();
            onDiscarded: root.discarded();
            onApplied: root.applied();
            onHelpRequested: root.helpRequested();
            onRejected: root.rejected();

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
