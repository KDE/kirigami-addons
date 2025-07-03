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
import org.kde.kirigamiaddons.delegates as Delegates
import org.kde.kirigamiaddons.formcard as FormCard

import './private' as Private

/*!
   \qmltype FormFileDelegate
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A Form delegate that let the user select a file.

   \qml
   FormCard.FormHeader {
       title: "Information"
   }

   FormCard.FormCard {
       FormCard.FormFileDelegate {
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
       \brief A label containing primary text that appears next to the selected file or folder name.
     */
    required property string label

    /*!
       \qmlproperty string acceptLabel
       \brief The \l {FileDialog::acceptLabel} {acceptLabel} of the file dialog.
     */
    property alias acceptLabel: fileDialog.acceptLabel

    /*!
       \qmlproperty string rejectLabel
       \brief The \l {FileDialog::rejectLabel} {rejectLabel} of the file dialog.
     */
    property alias rejectLabel: fileDialog.rejectLabel

    /*!
       \qmlproperty url currentFolder
       \brief The \l {FileDialog::currentFolder} {currentFolder} of the file dialog.
     */
    property alias currentFolder: fileDialog.currentFolder

    /*!
       \qmlproperty string defaultSuffix
       \brief The \l {FileDialog::defaultSuffix} {defaultSuffix} of the file dialog.
     */
    property alias defaultSuffix: fileDialog.defaultSuffix

    /*!
       \qmlproperty enumeration fileMode
       \brief The \l {FileDialog::fileMode} {fileMode} of the file dialog.
     */
    property alias fileMode: fileDialog.fileMode

    /*!
       \qmlproperty list<string> nameFilters
       \brief The \l {FileDialog::nameFilters} {nameFilters} of the file dialog.
     */
    property alias nameFilters: fileDialog.nameFilters

    /*!
       \qmlproperty flags options
       \brief The \l {FileDialog::options} {options} of the file dialog.
     */
    property alias options: fileDialog.options

    /*!
       \qmlproperty url selectedFile
       \brief The \l {FileDialog::selectedFile} {selectedFile} of the file dialog.
     */
    property alias selectedFile: fileDialog.selectedFile

    /*!
       \qmlproperty list<url> selectedFiles
       \brief The \l {FileDialog::selectedFiles} {selectedFiles} of the file dialog.

       \note In case, {FileDialog::OpenFiles} is set, only the first url will be displayed.
     */
    property alias selectedFiles: fileDialog.selectedFiles

    /*!
       \qmlproperty var selectedNameFilter
       \brief The \l {FileDialog::selectedNameFilter} {selectedNameFilter} of the file dialog.
     */
    readonly property alias selectedNameFilter: fileDialog.selectedNameFilter

    /*!
       \brief This signal is emitted when a valid file is selected
     */
    signal accepted();

    onActiveFocusChanged: { // propagate focus to the text field
        if (activeFocus && !Kirigami.Settings.isMobile) {
            textField.forceActiveFocus();
        }
    }

    onClicked: if (Kirigami.Settings.isMobile) {
        fileDialog.open();
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

                    function checkFile(): void {
                        if (textField.text.length === 0) {
                            formErrorHandler.visible = false;
                            return;
                        }

                        if (root.fileMode === FileDialog.SaveFile) {
                            if (FormCard.FileHelper.parentDirectoryExists(textField.text)) {
                                formErrorHandler.visible = false;
                                root.selectedFile = 'file://' + textField.text;
                                root.accepted();
                            } else if (!textField.popup?.visible ?? true) {
                                formErrorHandler.text = i18ndc("kirigami-addons6", "@info:status", "The path doesn't exist.");
                                formErrorHandler.visible = true;
                            }
                        } else {
                            if (FormCard.FileHelper.fileExists(textField.text)) {
                                root.selectedFile = 'file://' + textField.text;
                                formErrorHandler.visible = false;
                                root.accepted();
                            } else if (!textField.popup?.visible ?? true) {
                                formErrorHandler.text = i18ndc("kirigami-addons6", "@info:status", "The file doesn't exist.");
                                formErrorHandler.visible = true;
                            }
                        }
                    }

                    text: fileDialog.currentFolder.toString().replace("file://", "")
                    activeFocusOnTab: false

                    onAccepted: if (!textField.popup?.visible ?? true) {
                        checkFile();
                    } else if (folderModel.hintCount) {
                        let fileName = folderModel.get(folderModel.hintArray[0], "fileName")
                        if (folderModel.isFolder(folderModel.hintArray[0])) {
                            textField.text = folderModel.folder.toString().replace("file://", "") + folderModel.separator + fileName + folderModel.separator;
                        } else {
                            textField.text = folderModel.folder.toString().replace("file://", "") + folderModel.separator + fileName;
                            textField.popup.close();
                        }
                        checkFile();
                    } else {
                        textField.popup?.close();
                        checkFile();
                    }

                    onEditingFinished: if (!textField.popup?.visible ?? true) {
                        checkFile();
                    }

                    onTextEdited: if (text.length > 0) {
                        folderModel.updateSuggestions();
                    } else {
                        textField.popup?.close();
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
                                if (folderModel.isFolder(folderModel.hintArray[0])) {
                                    textField.text = folderModel.folder.toString().replace("file://", "") + folderModel.separator + fileName + folderModel.separator;
                                    folderModel.updateSuggestions();
                                } else {
                                    textField.text = folderModel.folder.toString().replace("file://", "") + folderModel.separator + fileName;
                                    textField.popup.close();
                                }
                                checkFile();
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
                    text: i18ndc("kirigami-addons6", "@action:button", "Select file")
                    onClicked: fileDialog.open()
                }
            }

            Controls.Label {
                visible: Kirigami.Settings.isMobile
                text: textField.text.length > 0 ? textField.text : i18ndc("kirigami-addons6", "@info:placeholderwrapMode", "No file selected")
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

    FileDialog {
        id: fileDialog
        onAccepted: {
            textField.text = selectedFile.toString().replace("file://", "");
            textField.checkFile();
        }
    }

    FolderListModel {
        id: folderModel

         // Array with reference numbers to folderModel items which match current user text
        property var hintArray: []
        property int hintCount: 0 // due to JS array length is not dynamic
        property string separator: Qt.platform.os === "windows" ? "\\" : "/"
        property int lastSlash: textField.text.lastIndexOf(separator) + 1

        showFiles: true
        showDirsFirst: true
        nameFilters: fileDialog.nameFilters
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
            for (var i = 0; i < folderModel.count; i++) {
                let file = folderModel.get(i, "fileName");
                if (searchText === "" || file.startsWith(searchText))
                    folderModel.hintArray.push(i)
            }
            folderModel.hintCount = folderModel.hintArray.length
            if (folderModel.hintCount && textField.activeFocus) {
                if (!textField.popup)
                    textField.popup = popupComp.createObject(textField)
                textField.popup.open()
            } else
                textField.popup?.close()
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
                        if (folderModel.isFolder(folderModel.hintArray[index])) {
                            textField.text = folderModel.folder.toString().replace("file://", "") + folderModel.separator + text + folderModel.separator;
                            folderModel.updateSuggestions();
                        } else {
                            textField.text = folderModel.folder.toString().replace("file://", "") + folderModel.separator + text;
                            textField.popup.close();
                        }
                    }
                    Keys.onReturnPressed: clicked()
                    Keys.onEnterPressed: clicked()
                }
                Controls.ScrollBar.vertical: Controls.ScrollBar {}
            }
        }
    }
}
