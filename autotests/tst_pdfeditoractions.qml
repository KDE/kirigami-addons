/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtTest
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.actions as KirigamiActions

Item {
    id: root

    property bool pageActive: true
    property bool hasDocument: false
    property bool documentModified: false
    property int openTriggeredCount: 0

    KirigamiActions.Application {
        id: application
    }

    KirigamiActions.ActionContext {
        id: editorContext
        active: root.pageActive
    }

    KirigamiActions.ActionContext {
        id: documentContext
        parentContext: editorContext
        active: root.hasDocument
    }

    KirigamiActions.ActionContext {
        id: modifiedDocumentContext
        parentContext: documentContext
        active: root.documentModified
    }

    Kirigami.Action {
        id: openAction
        onTriggered: root.openTriggeredCount++
    }

    Kirigami.Action {
        id: saveAction
    }

    Kirigami.Action {
        id: saveAsAction
    }

    Kirigami.Action {
        id: mergePdfsAction
    }

    Kirigami.Action {
        id: editMetadataAction
    }

    KirigamiActions.ActionCollection {
        application: application
        name: "pdfeditor"

        KirigamiActions.ActionData {
            name: "open_pdf"
            action: openAction
            contexts: editorContext
        }

        KirigamiActions.ActionData {
            name: "save"
            action: saveAction
            contexts: modifiedDocumentContext
        }

        KirigamiActions.ActionData {
            name: "save_as"
            action: saveAsAction
            contexts: documentContext
        }

        KirigamiActions.ActionData {
            name: "merge_pdfs"
            action: mergePdfsAction
            contexts: documentContext
        }

        KirigamiActions.ActionData {
            name: "edit_metadata"
            action: editMetadataAction
            contexts: documentContext
        }
    }

    Kirigami.Action {
        id: attachedOpenAction
        KirigamiActions.ActionCollection.collection: "pdfeditor"
        KirigamiActions.ActionCollection.action: "open_pdf"
    }

    TestCase {
        name: "PdfEditorActionsTest"

        function init() {
            root.pageActive = true;
            root.hasDocument = false;
            root.documentModified = false;
            root.openTriggeredCount = 0;
        }

        function test_noDocument() {
            compare(openAction.enabled, true);
            compare(openAction.visible, true);
            compare(saveAction.enabled, false);
            compare(saveAction.visible, false);
            compare(saveAsAction.enabled, false);
            compare(saveAsAction.visible, false);
            compare(mergePdfsAction.enabled, false);
            compare(mergePdfsAction.visible, false);
            compare(editMetadataAction.enabled, false);
            compare(editMetadataAction.visible, false);
        }

        function test_unmodifiedDocument() {
            root.hasDocument = true;

            tryCompare(saveAsAction, "enabled", true);
            tryCompare(saveAsAction, "visible", true);
            tryCompare(mergePdfsAction, "enabled", true);
            tryCompare(mergePdfsAction, "visible", true);
            tryCompare(editMetadataAction, "enabled", true);
            tryCompare(editMetadataAction, "visible", true);
            compare(saveAction.enabled, false);
            compare(saveAction.visible, false);
        }

        function test_modifiedDocument() {
            root.hasDocument = true;
            root.documentModified = true;

            tryCompare(saveAction, "enabled", true);
            tryCompare(saveAction, "visible", true);
        }

        function test_inactivePage() {
            root.pageActive = false;
            root.hasDocument = true;
            root.documentModified = true;

            tryCompare(openAction, "enabled", false);
            tryCompare(openAction, "visible", false);
            tryCompare(saveAction, "enabled", false);
            tryCompare(saveAction, "visible", false);
            tryCompare(saveAsAction, "enabled", false);
            tryCompare(saveAsAction, "visible", false);
            tryCompare(mergePdfsAction, "enabled", false);
            tryCompare(mergePdfsAction, "visible", false);
            tryCompare(editMetadataAction, "enabled", false);
            tryCompare(editMetadataAction, "visible", false);
        }

        function test_attachedActionTriggersPrimaryAction() {
            tryVerify(function() {
                return attachedOpenAction.fromQAction !== null;
            });
            attachedOpenAction.trigger();
            compare(root.openTriggeredCount, 1);
        }
    }
}
