/*
 * SPDX-FileCopyrightText: 2026 Kai Uwe Broulik <kde@broulik.de>
 *
 * SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC

import org.kde.kirigamiaddons.private
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as Components

import org.kde.kirigamiaddons.chips as Chips

/*!
   \qmltype ChipsTextARea
   \inqmlmodule org.kde.kirigamiaddons.chips
   \brief A text area with chips
 */
QQC.TextArea { // should this be a template?
    id: field

    wrapMode: QQC.TextArea.NoWrap
    topPadding: 0
    bottomPadding: 0
    implicitHeight: metricsField.implicitHeight

    // HACK
    verticalAlignment: QQC.TextArea.AlignVCenter
    QQC.TextField {
        id: metricsField
        visible: false
    }

    property alias chips: doc.chips

    /*!
      \qmlproperty ChipsTextArea segments
      A list of text segments and chips that can be used for custom
      processing, for example when the plain text needs to be further
      escaped before using it.
      \sa resolvedText
      */
    property alias segments: doc.segments
    /*!
      \qmlproperty ChipsTextArea resolvedText
      The resolved text with all chips replaced by their actual value
      \sa segments
     */
    property alias resolvedText: doc.text

    // TODO default to a single line of text

    function insertChipAtCursor(chip : Chips.ChipObject) : void {
        field.insertChipAt(chip, field.cursorPosition);
    }

    function insertChipAt(chip : Chips.ChipObject, cursorPosition : int) : void {
        doc.insertChipAt(chip, cursorPosition);
    }

    onTextEdited: suggestionsMenu.updateSuggestions()
    onCursorPositionChanged: suggestionsMenu.updateSuggestions()

    Keys.onPressed: (event) => {
        if (suggestionsMenu.visible) {
            if (event.key === Qt.Key_Down) {
                // TODO wrap
                ++suggestionsMenu.currentIndex;
                event.accepted = true;
            } else if (event.key === Qt.Key_Up) {
                --suggestionsMenu.currentIndex;
                event.accepted = true;
            } else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                suggestionsMenu.itemAt(suggestionsMenu.currentIndex).animateClick();
                event.accepted = true;
            }
        }
    }

    Chips.ChipsTextDocument {
        id: doc
        // Match Kirigami.Chip
        spacing: Kirigami.Units.smallSpacing
        padding: Kirigami.Units.smallSpacing
        radius: Kirigami.Units.cornerRadius

        font: field.font
        foregroundColor: Kirigami.Theme.highlightedTextColor
        backgroundColor: Kirigami.Theme.highlightColor

        Component.onCompleted: {
            doc.install(field.textDocument);
        }
    }

    MouseArea {
        anchors {
            fill: field
            topMargin: field.topPadding
            leftMargin: field.leftPadding
            rightMargin: field.rightPadding
            bottomMargin: field.bottomPadding
        }
        preventStealing: true
        // TODO tooltip for preview
        hoverEnabled: true
        enabled: field.activeFocus

        onPressed: (mouse) => {
            const chip = doc.chipAt(mouse.x, mouse.y);
            if (chip && chip.Chips.ChipGroup.group) {
                suggestionsMenu.cursorPos = doc.cursorPositionForChipPosition(mouse.x, mouse.y);
                suggestionsMenu.replaceMode = true;
                suggestionsMenu.selectedChip = chip;
                doc.suggestionsModel.query = "";
                doc.suggestionsModel.group = chip.Chips.ChipGroup.group;
                suggestionsMenu.maybeOpen();
            } else {
                mouse.accepted = false;
            }
        }
    }

    // TODO
    DropArea {
        id: dropArea
    }

    QQC.Menu {
        id: suggestionsMenu

        // TODO Given the amount of setup and differences between the modes (query vs group, replace vs not),
        // should we just use two separate menus for click vs type suggestion?
        property bool replaceMode: false

        property Chips.ChipObject selectedChip: null
        property int cursorPos: -1
        readonly property rect cursorRect: cursorPos > -1 ? field.positionToRectangle(cursorPos) : Qt.rect(0,0,0,0)

        // FIXME how can I make the Menu not steal focus?!
        modal: false
        focus: false
        closePolicy: QQC.Menu.NoAutoClose

        x: cursorRect.x
        y: cursorRect.bottom

        onOpened: {
            // FIXME how can I make the Menu not steal focus?!
            field.forceActiveFocus();
        }

        onCurrentIndexChanged: {
            if (currentIndex === -1) {
                currentIndex = 0;
            }
        }

        function maybeOpen() : void {
            if (suggestionsRepeater.count > 0) {
                open();
            } else {
                close();
            }
        }

        function updateSuggestions() : void {
            if (!field.activeFocus) {
                return;
            }

            if (suggestionsMenu.visible && suggestionsMenu.replaceMode) {
                return;
            }

            const before = field.text.substring(0, field.cursorPosition);
            // Start matching after a space or another token (FFFC=replacement char)
            //const match = before.match(/(?:^|[\s\uFFFC])([a-zA-Z0-9_-]*)$/);
            const match = before.match(/(?:^|[\s\uFFFC])([\w@#-]*)$/);

            if (!match) {
                doc.suggestionsModel.group = null;
                doc.suggestionsModel.query = "";
                return;
            }

            const query = match[1];
            doc.suggestionsModel.group = null;
            // TODO selectedChip?
            replaceMode = false;
            doc.suggestionsModel.query = query;
            cursorPos = field.cursorPosition - query.length;
            maybeOpen();
        }

        QQC.ButtonGroup {
            id: chipButtonGroup
        }

        Repeater {
            id: suggestionsRepeater
            model: doc.suggestionsModel

            /*onCountChanged: {
                if (count === 0) {
                    suggestionsMenu.close()
                }
            }*/

            QQC.MenuItem {
                required text
                required property Chips.ChipObject chip
                QQC.ButtonGroup.group: chipButtonGroup
                checkable: suggestionsMenu.replaceMode
                checked: suggestionsMenu.replaceMode && suggestionsMenu.selectedChip === chip
                onClicked: {
                    if (suggestionsMenu.replaceMode) {
                        doc.replaceChipAt(chip, suggestionsMenu.cursorPos);
                    } else {
                        doc.insertChipAt(chip, suggestionsMenu.cursorPos, field.cursorPosition);
                    }
                }
            }
        }

        // TODO Repeater messes with item order.
        /*QQC.MenuSeparator {
            visible: suggestionsMenu.replaceMode
        }*/

        QQC.MenuItem {
            text: "Remove"//i18nc("@action:inmenu", "Remove")
            //icon.name: "list-remove-symbolic"
            visible: suggestionsMenu.replaceMode
            onClicked: {
                doc.removeChipAt(suggestionsMenu.cursorPos);
            }
        }
    }
}
