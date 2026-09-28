// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as Controls
import QtTest
import org.kde.kirigamiaddons.components as Components
import test.artefacts 1.0

Item {
    id: root

    width: 640
    height: 480

    property int acceptedCount: 0
    property int appliedCount: 0
    property int discardedCount: 0
    property int rejectedCount: 0

    TestConfig {
        id: testConfig
    }

    Component.onCompleted: Components.MessageDialogHelper.config = testConfig.config

    Controls.ApplicationWindow {
        id: applicationWindow

        width: 640
        height: 480
        visible: true

        Components.MessageDialog {
            id: dialog

            dontShowAgainName: "choice"
            configGroupName: "MessageDialogTest"
            enter: null
            exit: null

            onAccepted: root.acceptedCount++
            onApplied: root.appliedCount++
            onDiscarded: root.discardedCount++
            onRejected: root.rejectedCount++
        }
    }

    TestCase {
        name: "MessageDialog"
        when: windowShown

        function init(): void {
            root.acceptedCount = 0;
            root.appliedCount = 0;
            root.discardedCount = 0;
            root.rejectedCount = 0;
        }

        function cleanup(): void {
            dialog.close();
        }

        function test_cancelDoesNotRememberChoice(): void {
            dialog.standardButtons = Controls.Dialog.Yes | Controls.Dialog.No | Controls.Dialog.Cancel;
            dialog.dontShowAgainName = "cancel";
            dialog.openDialog();
            tryCompare(dialog, "visible", true);
            dialog.footer.children[0].checked = true;
            dialog.standardButton(Controls.Dialog.Cancel).clicked();
            compare(dialog.visible, false);
            compare(Components.MessageDialogHelper.shouldBeShownTwoActions("cancel", dialog.configGroupName).show, true);
        }

        function test_noRemembersOnlyRejection(): void {
            dialog.standardButtons = Controls.Dialog.Yes | Controls.Dialog.No;
            dialog.dontShowAgainName = "no";
            dialog.openDialog();
            tryCompare(dialog, "visible", true);
            dialog.footer.children[0].checked = true;
            dialog.standardButton(Controls.Dialog.No).clicked();
            compare(dialog.visible, false);
            compare(Components.MessageDialogHelper.shouldBeShownTwoActions("no", dialog.configGroupName).result, false);

            dialog.close();
            root.rejectedCount = 0;
            dialog.openDialog();
            compare(dialog.visible, false);
            compare(root.rejectedCount, 1);
            compare(root.discardedCount, 0);
            compare(root.acceptedCount, 0);
            compare(root.appliedCount, 0);
        }

        function test_rejectDoesNotRememberChoice(): void {
            dialog.standardButtons = Controls.Dialog.Yes | Controls.Dialog.No;
            dialog.dontShowAgainName = "reject";
            dialog.openDialog();
            tryCompare(dialog, "visible", true);
            dialog.footer.children[0].checked = true;
            dialog.reject();
            compare(Components.MessageDialogHelper.shouldBeShownTwoActions("reject", dialog.configGroupName).show, true);
        }

        function test_okRemembersOnlyAcceptance(): void {
            dialog.standardButtons = Controls.Dialog.Ok;
            dialog.dontShowAgainName = "ok";
            dialog.openDialog();
            tryCompare(dialog, "visible", true);
            dialog.footer.children[0].checked = true;
            dialog.standardButton(Controls.Dialog.Ok).clicked();
            compare(dialog.visible, false);
            compare(Components.MessageDialogHelper.shouldBeShownContinue("ok", dialog.configGroupName), false);

            dialog.close();
            root.acceptedCount = 0;
            dialog.openDialog();
            compare(dialog.visible, false);
            compare(root.acceptedCount, 1);
            compare(root.appliedCount, 0);
            compare(root.rejectedCount, 0);
            compare(root.discardedCount, 0);
        }

        function test_discardRemembersOnlyDiscard(): void {
            dialog.standardButtons = Controls.Dialog.Save | Controls.Dialog.Discard | Controls.Dialog.Cancel;
            dialog.dontShowAgainName = "discard";
            dialog.openDialog();
            tryCompare(dialog, "visible", true);
            dialog.footer.children[0].checked = true;
            dialog.standardButton(Controls.Dialog.Discard).clicked();
            compare(Components.MessageDialogHelper.shouldBeShownTwoActions("discard", dialog.configGroupName).result, false);

            dialog.close();
            root.discardedCount = 0;
            dialog.openDialog();
            compare(dialog.visible, false);
            compare(root.discardedCount, 1);
            compare(root.acceptedCount, 0);
            compare(root.appliedCount, 0);
            compare(root.rejectedCount, 0);
        }

        function test_applyRemembersOnlyApply(): void {
            dialog.standardButtons = Controls.Dialog.Apply | Controls.Dialog.Cancel;
            dialog.dontShowAgainName = "apply";
            dialog.openDialog();
            tryCompare(dialog, "visible", true);
            dialog.footer.children[0].checked = true;
            dialog.standardButton(Controls.Dialog.Apply).clicked();
            compare(Components.MessageDialogHelper.shouldBeShownTwoActions("apply", dialog.configGroupName).result, true);

            dialog.close();
            root.appliedCount = 0;
            dialog.openDialog();
            compare(dialog.visible, false);
            compare(root.appliedCount, 1);
            compare(root.acceptedCount, 0);
            compare(root.rejectedCount, 0);
            compare(root.discardedCount, 0);
        }

        function test_yesRemembersOnlyAcceptance(): void {
            dialog.standardButtons = Controls.Dialog.Yes | Controls.Dialog.No;
            dialog.dontShowAgainName = "yes";
            dialog.openDialog();
            tryCompare(dialog, "visible", true);
            dialog.footer.children[0].checked = true;
            dialog.standardButton(Controls.Dialog.Yes).clicked();
            compare(dialog.visible, false);
            compare(Components.MessageDialogHelper.shouldBeShownTwoActions("yes", dialog.configGroupName).result, true);

            dialog.close();
            root.acceptedCount = 0;
            dialog.openDialog();
            compare(dialog.visible, false);
            compare(root.acceptedCount, 1);
            compare(root.appliedCount, 0);
            compare(root.rejectedCount, 0);
            compare(root.discardedCount, 0);
        }

        function test_unsupportedButtonsDoNotSuppressDialog(): void {
            dialog.standardButtons = Controls.Dialog.Ok | Controls.Dialog.Apply | Controls.Dialog.Cancel;
            dialog.dontShowAgainName = "unsupported";
            dialog.openDialog();
            tryCompare(dialog, "visible", true);
            compare(dialog.footer.children[0].visible, false);
        }
    }
}
