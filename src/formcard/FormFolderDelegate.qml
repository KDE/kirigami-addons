// SPDX-FileCopyrightText: 2025 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import org.kde.kirigami as Kirigami
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
                    Accessible.name: root.label
                    Layout.fillWidth: true
                    onAccepted: checkFolder();
                    onEditingFinished: checkFolder();
                    activeFocusOnTab: false

                    function checkFolder(): void {
                        if (textField.text.length === 0) {
                            formErrorHandler.visible = false;
                            return;
                        }

                        if (FormCard.FileHelper.folderExists(textField.text)) {
                            formErrorHandler.visible = false;
                            root.selectedFolder = 'file://' + textField.text;
                            root.accepted();
                        } else {
                            formErrorHandler.text = i18ndc("kirigami-addons6", "@info:status", "The folder doesn't exist.");
                            formErrorHandler.visible = true;
                        }
                    }
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
}
