// SPDX-FileCopyrightText: 2019 David Edmundson <davidedmundson@kde.org>
// SPDX-FileCopyrightText: 2021 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.3
import QtQuick.Window 2.15
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.3 as Controls
import org.kde.kirigami 2.8 as Kirigami

Controls.TextField { //inherited for style reasons to show we're interactive
    id: root
    property date selectedDate
    readOnly: true
    text: selectedDate.toLocaleDateString(Qt.locale(), Locale.ShortFormat)
    MouseArea {
        anchors.fill: parent
        onClicked: {
            const popup = popupComponent.createObject(root, {
                year: root.selectedDate.getFullYear(),
                month: root.selectedDate.getMonth() + 1,
                selectedDate: root.selectedDate,
            });
            popup.open();
        }

    }
    Component {
        id: popupComponent
        Kirigami.OverlaySheet {
            id: popup
            property alias year: datePicker.year
            property alias month: datePicker.month
            property alias selectedDate: datePicker.selectedDate

            header: RowLayout {
                implicitWidth: datePicker.width
                Kirigami.Heading {
                    level: 2
                    text: datePicker.selectedDate.toLocaleDateString(Qt.locale(), "<b>MMMM</b>")
                }
                Kirigami.Heading {
                    level: 3
                    text: datePicker.selectedDate.getFullYear()
                    opacity: 0.8
                    Layout.fillWidth: true
                }

                Controls.Button {
                    icon.name: "go-previous"
                    Controls.ToolTip.text: i18n("Previous")
                    Controls.ToolTip.visible: hovered
                    Controls.ToolTip.delay: Kirigami.Units.shortDuration
                    onClicked: datePicker.previousMonth()
                }
                Controls.Button {
                    icon.name: "go-jump-today"
                    Controls.ToolTip.text: i18n("Today")
                    Controls.ToolTip.visible: hovered
                    Controls.ToolTip.delay: Kirigami.Units.shortDuration
                    onClicked: datePicker.goToday()
                }
                Controls.Button {
                    icon.name: "go-next"
                    Controls.ToolTip.text: i18n("Next")
                    Controls.ToolTip.visible: hovered
                    Controls.ToolTip.delay: Kirigami.Units.shortDuration
                    onClicked: datePicker.nextMonth()
                }
            }
            contentItem: DatePicker {
                id: datePicker
                implicitWidth: Math.min(Window.width, Kirigami.Units.gridUnit * 25)
                implicitHeight: width * 0.8
            }
            footer: RowLayout {
                Controls.Label {
                    text: datePicker.selectedDate.toLocaleDateString();
                    Layout.fillWidth: true
                }
                Controls.Button {
                    text: i18n("Cancel")
                    icon.name: "dialog-cancel"
                    onClicked: popup.destroy();
                }
                Controls.Button {
                    text: i18n("Accept")
                    icon.name: "dialog-ok-apply"
                    onClicked: {
                        root.selectedDate = datePicker.selectedDate
                        popup.destroy();
                    }
                }
            }
            leftPadding: 0
            rightPadding: 0
            topPadding: 0
            bottomPadding: 0
        }
    }
}
