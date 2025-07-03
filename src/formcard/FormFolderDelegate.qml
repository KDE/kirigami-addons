// SPDX-FileCopyrightText: 2024 Tomasz Bojczuk <seelook@gmail.com>
// SPDX-FileCopyrightText: 2025 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.folderlistmodel

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kirigamiaddons.delegates as Delegates
import org.kde.kirigamiaddons.formcard as FormCard

import './private' as Private

/*!
   \qmltype FormFolderDelegate
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A Form delegate that let the user select a folder.

   \qml
   FormCard.FormHeader {
       title: "Information"
   }

   FormCard.FormCard {
       FormCard.FormFolderDelegate {
           label: "Important document"
           currentFolder: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
       }
   }
   \endqml

   \since 1.9.0
 */
AbstractFormDelegate {
    id: root

    /*!
       \brief A label containing primary text that appears next to the selected folder or folder name.
     */
    required property string label

    /*!
       \qmlproperty string acceptLabel
       \brief The \l {FolderDialog::acceptLabel} {acceptLabel} of the folder dialog.
     */
    property alias acceptLabel: folderDialog.acceptLabel

    /*!
       \qmlproperty string rejectLabel
       \brief The \l {FolderDialog::rejectLabel} {rejectLabel} of the folder dialog.
     */
    property alias rejectLabel: folderDialog.rejectLabel

    /*!
       \qmlproperty url currentFolder
       \brief The \l {FolderDialog::currentFolder} {currentFolder} of the folder dialog.
     */
    property alias currentFolder: folderDialog.currentFolder

    /*!
       \qmlproperty flags options
       \brief The \l {FolderDialog::options} {options} of the folder dialog.
     */
    property alias options: folderDialog.options

    /*!
       \qmlproperty url selectedFile
       \brief The \l {FolderDialog::selectedFolder} {selectedFolder} of the folder dialog.
     */
    property alias selectedFolder: folderDialog.selectedFolder

    /*!
       \brief This signal is emitted when a valid folder is selected
     */
    signal accepted();

    onActiveFocusChanged: { // propagate focus to the text field
        if (activeFocus && !Kirigami.Settings.isMobile) {
            textField.forceActiveFocus();
        }
    }

    onClicked: if (Kirigami.Settings.isMobile) {
        folderDialog.open();
    } else {
        textField.forceActiveFocus()
    }
    background.visible: Kirigami.Settings.isMobile
    Accessible.role: Accessible.EditableText

    contentItem: RowLayout {
        spacing: 0

        Kirigami.Icon {
            visible: root.icon.name !== ""
            source: root.icon.name
            color: root.icon.color
            Layout.rightMargin: (root.icon.name !== "") ? Private.FormCardUnits.horizontalSpacing : 0
            implicitWidth: (root.icon.name !== "") ? Kirigami.Units.iconSizes.smallMedium : 0
            implicitHeight: (root.icon.name !== "") ? Kirigami.Units.iconSizes.smallMedium : 0
        }

        ColumnLayout {
            spacing: Private.FormCardUnits.verticalSpacing

            Controls.Label {
                Layout.fillWidth: true
                text: label
                elide: Text.ElideRight
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                wrapMode: Text.Wrap
                maximumLineCount: 2
                Accessible.ignored: true
            }

            RowLayout {
                id: innerRow

                spacing: Kirigami.Units.smallSpacing
                visible: !Kirigami.Settings.isMobile

                Layout.fillWidth: true

                // TODO Qt 6.10 replace with Controls.SearchField for autocompletion
                Controls.TextField {
                    id: textField

                    property Controls.Popup popup: null

                    function checkFolder(): void {
                        if (textField.text.length === 0) {
                            formErrorHandler.visible = false;
                            return;
                        }

                        if (FormCard.FileHelper.folderExists(textField.text)) {
                            formErrorHandler.visible = false;
                            root.selectedFolder = 'file://' + textField.text;
                            root.accepted();
                        } else if (!textField.popup?.visible ?? true) {
                            formErrorHandler.text = i18ndc("kirigami-addons6", "@info:status", "The folder doesn't exist.");
                            formErrorHandler.visible = true;
                        }
                    }

                    activeFocusOnTab: false
                    text: folderDialog.currentFolder.toString().replace("file://", "")

                    onEditingFinished: if (!textField.popup?.visible ?? true) {
                        checkFolder();
                    }

                    onTextEdited: if (text.length > 0) {
                        folderModel.updateSuggestions();
                    } else {
                        textField.popup?.close();
                    }

                    onAccepted: if (!textField.popup?.visible ?? true) {
                        checkFolder();
                    } else if (folderModel.hintCount) {
                        let fileName = folderModel.get(folderModel.hintArray[0], "fileName")
                        textField.text = folderModel.folder.toString().replace("file://", "") + folderModel.separator + fileName;
                        textField.popup?.close();
                        checkFolder();
                    } else {
                        textField.popup?.close();
                        checkFolder();
                    }

                    Keys.onDownPressed: {
                        if (textField.popup?.visible) {
                            textField.popup.forceActiveFocus();
                            textField.popup.hintListView.itemAtIndex(0)?.forceActiveFocus();
                        }
                    }
                    Keys.onTabPressed: (event) => {
                        if (textField.popup?.visible) {
                            if (folderModel.hintCount) {
                                let fileName = folderModel.get(folderModel.hintArray[0], "fileName")
                                textField.text = folderModel.folder.toString().replace("file://", "") + folderModel.separator + fileName;
                                textField.popup?.close();
                                checkFolder();
                            }
                        } else {
                            event.accepted = false;
                        }
                    }

                    Accessible.name: root.label
                    Layout.fillWidth: true
                }

                Controls.Button {
                    icon.name: "document-open-folder-symbolic"
                    display: Controls.Button.IconOnly
                    text: i18ndc("kirigami-addons6", "@action:button", "Select folder")
                    onClicked: folderDialog.open()
                }
            }

            Controls.Label {
                visible: Kirigami.Settings.isMobile
                text: textField.text.length > 0 ? textField.text : i18ndc("kirigami-addons6", "@info:placeholderwrapMode", "No folder selected")
                color: Kirigami.Theme.disabledTextColor
                wrapMode: Text.Wrap
            }

            Kirigami.InlineMessage {
                id: formErrorHandler

                visible: false
                Layout.topMargin: visible ? Kirigami.Units.smallSpacing : 0
                Layout.fillWidth: true
                type: Kirigami.MessageType.Error
            }
        }

        FormArrow {
            id: formArrow

            Layout.leftMargin: Kirigami.Units.smallSpacing
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            direction: Qt.RightArrow
            visible: root.background.visible
        }
    }

    FolderDialog {
        id: folderDialog
        onAccepted: {
            textField.text = selectedFolder.toString().replace("file://", "");
            textField.checkFolder();
        }
    }

    FolderListModel {
        id: folderModel

         // Array with reference numbers to folderModel items which match current user text
        property var hintArray: []
        property int hintCount: 0 // due to JS array length is not dynamic
        property string separator: Qt.platform.os === "windows" ? "\\" : "/"
        property int lastSlash: textField.text.lastIndexOf(separator) + 1

        showFiles: false
        nameFilters: ["*"]
        folder: FormCard.FileHelper.folderForFileName(textField.text)
        onStatusChanged: {
            if (textField.text.length > 0 && status == FolderListModel.Ready)
                updateSuggestions();
        }

        function updateSuggestions(): void {
            if (folderModel.status !== FolderListModel.Ready)
                return;
            folderModel.hintArray.length = 0
            folderModel.hintCount = 0

            let searchText = textField.text.slice(folderModel.lastSlash, textField.length);

            if (!textField.text.endsWith("/") && textField.text !== "/" && FormCard.FileHelper.folderExists(textField.text)) {
                textField.popup?.close();
                return;
            }

            for (var i = 0; i < folderModel.count; i++) {
                let file = folderModel.get(i, "fileName");
                if (searchText === "" || file.startsWith(searchText))
                    folderModel.hintArray.push(i)
            }
            folderModel.hintCount = folderModel.hintArray.length
            if (folderModel.hintCount && textField.activeFocus) {
                if (!textField.popup)
                    textField.popup = popupComp.createObject(textField)
                textField.popup.open();
            } else {
                textField.popup?.close();
            }
        }
    }

    Component {
        id: popupComp

        Controls.Popup {
            property alias hintListView: hintListView

            y: textField.height
            x: Kirigami.Units.gridUnit

            width: textField.width - Kirigami.Units.gridUnit * 2
            height: Math.min(Kirigami.Units.gridUnit * 8 + Kirigami.Units.smallSpacing * 7, hintListView.contentHeight)

            padding: 0

            ListView {
                id: hintListView

                width: parent.width
                height: textField.popup?.height

                visible: folderModel.hintCount > 0
                clip: true

                model: folderModel.hintCount
                delegate: Delegates.RoundedItemDelegate {
                    required property int index

                    width: ListView.view.width - (ListView.view.Controls.ScrollBar.vertical.visible ? ListView.view.Controls.ScrollBar.vertical.width : 0)
                    text: folderModel.get(folderModel.hintArray[index], "fileName")
                    onClicked: {
                        textField.text = folderModel.folder.toString().replace("file://", "") + folderModel.separator + text;
                        textField.popup?.close();
                    }

                    Keys.onReturnPressed: clicked()
                    Keys.onEnterPressed: clicked()
                }

                Controls.ScrollBar.vertical: Controls.ScrollBar {}
            }
        }
    }
}
