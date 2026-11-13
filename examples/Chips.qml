/*
 * SPDX-FileCopyrightText: 2026 Kai Uwe Broulik <kde@broulik.de>
 *
 * SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.chips as Chips

Kirigami.FormLayout {
    id: root

    function formatDate(format : string) : string {
        return new Date().toLocaleString(Qt.locale(), format);
    }

    Chips.ChipGroup {
        id: dayGroup
        // backgroundColor: "teal"
        label: "Day"
    }

    Chips.ChipGroup {
        id: monthGroup
        // backgroundColor: "gold"
        label: "Month"
    }

    Chips.ChipGroup {
        id: yearGroup
        // backgroundColor: "salmon"
        label: "Year"
    }

    Chips.ChipsTextArea {
        id: area
        Layout.preferredWidth: Kirigami.Units.gridUnit * 16
        Kirigami.FormData.label: "Date format:"

        readonly property string escapedSegments: segments.map(segment => {
            if (typeof segment === "string") {
                // TODO handle ' and ''
                return "'" + segment + "'";
            } else {
                return segment.toString();
            }
        }).join("")

        Layout.fillWidth: true
        focus: true

        // https://doc.qt.io/qt-6/qdate.html#toString-4
        chips: [
            Chips.ChipObject {
                label: "1–31"
                value: "d"
                preview: root.formatDate(value)
                Chips.ChipGroup.group: dayGroup
            },
            Chips.ChipObject {
                label: "01–31"
                value: "dd"
                preview: root.formatDate(value)
                Chips.ChipGroup.group: dayGroup
            },
            Chips.ChipObject {
                label: "Mon–Sun"
                value: "ddd"
                preview: root.formatDate(value)
                Chips.ChipGroup.group: dayGroup
            },
            Chips.ChipObject {
                label: "Monday–Sunday"
                value: "dddd"
                preview: root.formatDate(value)
                Chips.ChipGroup.group: dayGroup
            },

            Chips.ChipObject {
                label: "1–12"
                value: "M"
                preview: root.formatDate(value)
                Chips.ChipGroup.group: monthGroup
            },
            Chips.ChipObject {
                label: "01–12"
                value: "MM"
                preview: root.formatDate(value)
                Chips.ChipGroup.group: monthGroup
            },
            Chips.ChipObject {
                label: "Jan–Dec"
                value: "MMM"
                preview: root.formatDate(value)
                Chips.ChipGroup.group: monthGroup
            },
            Chips.ChipObject {
                label: "January–December"
                value: "MMMM"
                preview: root.formatDate(value)
                Chips.ChipGroup.group: monthGroup
            },

            Chips.ChipObject {
                label: "2 digit"
                value: "yy"
                preview: root.formatDate(value)
                Chips.ChipGroup.group: yearGroup
            },
            Chips.ChipObject {
                label: "4 digit"
                value: "yyyy"
                preview: root.formatDate(value)
                Chips.ChipGroup.group: yearGroup
            },

            Chips.ChipObject {
                backgroundColor: "#00aa00";
                label: "Konqi"
                // No group :-)
            }
        ]
    }

    QQC.Label {
        Kirigami.FormData.label: "Preview:"

        text: root.formatDate(area.escapedSegments)
    }

    Repeater {
        model: area.chips

        Kirigami.Chip {
            id: chip
            required property Chips.ChipObject modelData

            // Don't take focus away from text field when inserting placeholder
            focusPolicy: Qt.TabFocus
            text: {
                const group = modelData.Chips.ChipGroup.group;
                if (group && group.label) {
                    return group.label + ": " + modelData.label;
                } else {
                    return modelData.label;
                }
            }
            closable: false
            checkable: false

            onClicked: {
                area.insertChipAtCursor(modelData);
            }

            // TODO Drag and drop
        }
    }
}
