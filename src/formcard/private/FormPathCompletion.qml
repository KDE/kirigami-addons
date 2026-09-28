// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as Controls
import Qt.labs.folderlistmodel

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as Components
import org.kde.kirigamiaddons.delegates as Delegates
import org.kde.kirigamiaddons.formcard as FormCard

Item {
    id: root

    required property Controls.TextField textField
    property bool includeFiles: false
    property var nameFilters: ["*"]
    property var popup: null
    readonly property bool popupVisible: popup?.visible ?? false
    readonly property int hintCount: folderModel.hintCount

    signal suggestionClicked(bool isFolder)

    function closePopup(): void {
        popup?.close();
    }

    function updateSuggestions(): void {
        folderModel.updateSuggestions();
    }

    function focusNextSuggestion(): void {
        if (popupVisible) {
            popup.forceActiveFocus();
            popup.hintListView.incrementCurrentIndex();
            popup.hintListView.currentItem?.forceActiveFocus();
        }
    }

    function selectFirstSuggestion(updateOnFolder: bool): void {
        selectSuggestion(0, updateOnFolder);
    }

    function selectSuggestion(index: int, updateOnFolder: bool): void {
        const modelIndex = folderModel.hintArray[index];
        const isFolder = folderModel.isFolder(modelIndex);
        const fileName = folderModel.get(modelIndex, "fileName");
        textField.text = folderModel.folder.toString().replace("file://", "") + folderModel.separator + fileName + (includeFiles && isFolder ? folderModel.separator : "");

        if (includeFiles && isFolder) {
            if (updateOnFolder) {
                updateSuggestions();
            }
        } else {
            closePopup();
        }
    }

    FolderListModel {
        id: folderModel

        property var hintArray: []
        property int hintCount: 0
        property string separator: Qt.platform.os === "windows" ? "\\" : "/"
        property int lastSlash: root.textField.text.lastIndexOf(separator) + 1

        showFiles: root.includeFiles
        showDirsFirst: root.includeFiles
        nameFilters: root.nameFilters
        folder: FormCard.FileHelper.folderForFileName(root.textField.text)

        onStatusChanged: {
            if (root.textField.text.length > 0 && status === FolderListModel.Ready) {
                root.updateSuggestions();
            }
        }

        function updateSuggestions(): void {
            if (status !== FolderListModel.Ready) {
                return;
            }

            hintArray.length = 0;
            hintCount = 0;

            const searchText = root.textField.text.slice(lastSlash, root.textField.length);
            if (!root.includeFiles && !root.textField.text.endsWith("/") && root.textField.text !== "/" && FormCard.FileHelper.folderExists(root.textField.text)) {
                root.closePopup();
                return;
            }

            for (let i = 0; i < count; i++) {
                const fileName = get(i, "fileName");
                if (searchText === "" || fileName.startsWith(searchText)) {
                    hintArray.push(i);
                }
            }
            hintCount = hintArray.length;

            if (hintCount && (root.textField.activeFocus || root.popup?.activeFocus)) {
                if (!root.popup) {
                    root.popup = popupComponent.createObject(root.textField);
                }
                root.popup.open();
            } else {
                root.closePopup();
            }
        }
    }

    Component {
        id: popupComponent

        Controls.Popup {
            property alias hintListView: hintListView

            x: 0
            y: root.textField.height
            width: root.textField.width
            height: Math.min(Kirigami.Units.gridUnit * 8 + Kirigami.Units.smallSpacing * 7, hintListView.contentHeight)
            padding: 0
            background: Components.DialogRoundedBackground {}

            ListView {
                id: hintListView

                width: parent.width
                height: root.popup?.height
                visible: folderModel.hintCount > 0
                clip: true
                model: folderModel.hintCount

                delegate: Delegates.RoundedItemDelegate {
                    required property int index

                    width: ListView.view.width - (ListView.view.Controls.ScrollBar.vertical.visible ? ListView.view.Controls.ScrollBar.vertical.width : 0)
                    text: folderModel.get(folderModel.hintArray[index], "fileName")
                    onClicked: {
                        const isFolder = folderModel.isFolder(folderModel.hintArray[index]);
                        root.selectSuggestion(index, false);
                        root.suggestionClicked(isFolder);
                    }
                    Keys.onReturnPressed: clicked()
                    Keys.onEnterPressed: clicked()
                }

                Controls.ScrollBar.vertical: Controls.ScrollBar {}
            }
        }
    }
}
