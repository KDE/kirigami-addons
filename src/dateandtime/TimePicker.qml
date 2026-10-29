// SPDX-FileCopyrightText: 2021 Han Young <hanyoung@protonmail.com>
// SPDX-FileCopyrightText: 2022 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigamiaddons.private
import org.kde.kirigami as Kirigami

/*!
   A time picker with labeled hour and minute fields.
 */
ColumnLayout {
    id: root

    /*!
       This property holds the current hours selected. This is a number between 0 and 23.
     */
    property int hours

    /*!
       This property holds the current minutes selected. This is a number between 0 and 59.
     */
    property int minutes

    /*!
       Whether to show a "Now" button that sets the selected time to the current time.
       \default false
       \since 1.16.1
     */
    property bool showNowButton: false

    readonly property var _locale: Qt.locale()
    readonly property bool _isAmPm: _locale.timeFormat().toLowerCase().includes("ap")

    spacing: Kirigami.Units.largeSpacing

    function formatNumber(value): string {
        const s = _locale.toString(value);
        if (s.length < 2 && _locale.zeroDigit === "0")
            return "0" + s;
        return s;
    }

    component TimeField: TextField {
        id: field

        required property int value
        required property int from
        required property int to
        readonly property string formattedValue: root.formatNumber(value)

        signal valueEdited(int value)

        function commit(): void {
            if (text.length > 0) {
                const number = Number.fromLocaleString(root._locale, text);
                valueEdited(Math.max(from, Math.min(to, number)));
            }
            text = Qt.binding(() => field.formattedValue);
        }

        Layout.preferredWidth: Kirigami.Units.gridUnit * 4
        Layout.minimumHeight: Kirigami.Units.gridUnit * 3
        Layout.fillHeight: true
        text: formattedValue
        font.pointSize: Kirigami.Theme.defaultFont.pointSize * 2.5
        horizontalAlignment: TextInput.AlignHCenter
        verticalAlignment: TextInput.AlignVCenter
        inputMethodHints: Qt.ImhDigitsOnly
        selectByMouse: true
        maximumLength: 2

        validator: IntValidator {
            bottom: field.from
            top: field.to
            locale: root._locale.name
        }

        onTextEdited: {
            // Keep value changes from formatting the text during an edit.
            text = text;
            if (text.length === 0 || !acceptableInput) {
                return;
            }
            const number = Number.fromLocaleString(root._locale, text);
            if (number >= from && number <= to) {
                valueEdited(number);
            }
        }

        onActiveFocusChanged: {
            if (activeFocus) {
                selectAll();
            } else {
                commit();
            }
        }

        Keys.onReturnPressed: commit()
        Keys.onEnterPressed: commit()
    }

    GridLayout {
        columns: root._isAmPm ? 5 : 4
        columnSpacing: Kirigami.Units.largeSpacing
        rowSpacing: Kirigami.Units.smallSpacing

        Layout.fillWidth: true
        Layout.preferredWidth: Kirigami.Units.gridUnit * 10

        Label {
            id: hourLabel
            Layout.row: 0
            Layout.column: 0
            text: I18n.i18nc("@label:textbox", "Hour")
            Accessible.ignored: true
        }

        Label {
            id: minuteLabel
            Layout.row: 0
            Layout.column: 2
            text: I18n.i18nc("@label:textbox", "Minute")
            Accessible.ignored: true
        }

        TimeField {
            id: hoursInput
            objectName: "hoursInput"
            Layout.row: 1
            Layout.column: 0
            from: root._isAmPm ? 1 : 0
            to: root._isAmPm ? 12 : 23
            value: root._isAmPm ? (root.hours % 12 || 12) : root.hours
            onValueEdited: value => root.hours = root._isAmPm ? value % 12 + (root.hours >= 12 ? 12 : 0) : value
            focus: true
            KeyNavigation.tab: minutesInput
            Accessible.name: hourLabel.text
        }

        Label {
            Layout.row: 1
            Layout.column: 1
            text: I18n.i18nc("Time separator", ":")
            font.pointSize: Kirigami.Theme.defaultFont.pointSize * 2.5
            Accessible.ignored: true
        }

        TimeField {
            id: minutesInput
            objectName: "minutesInput"
            Layout.row: 1
            Layout.column: 2
            from: 0
            to: 59
            value: root.minutes
            onValueEdited: value => root.minutes = value
            KeyNavigation.tab: root._isAmPm ? amButton : (root.showNowButton ? nowButton : null)
            Accessible.name: minuteLabel.text
        }

        ColumnLayout {
            Layout.row: 1
            Layout.column: 3
            visible: root._isAmPm
            spacing: Kirigami.Units.smallSpacing

            ButtonGroup {
                id: periodGroup
            }

            Button {
                id: amButton
                objectName: "amButton"
                Layout.fillWidth: true
                text: root._locale.amText
                checkable: true
                checked: root.hours < 12
                ButtonGroup.group: periodGroup
                onClicked: root.hours = root.hours % 12
                KeyNavigation.tab: pmButton
            }

            Button {
                id: pmButton
                objectName: "pmButton"
                Layout.fillWidth: true
                text: root._locale.pmText
                checkable: true
                checked: root.hours >= 12
                ButtonGroup.group: periodGroup
                onClicked: root.hours = root.hours % 12 + 12
                KeyNavigation.tab: root.showNowButton ? nowButton : null
            }
        }

        Item {
            Layout.fillWidth: true
        }
    }

    Button {
        id: nowButton
        objectName: "nowButton"
        visible: root.showNowButton
        text: I18n.i18nc("@action:button", "Now")
        icon.name: "accept_time_event-symbolic"

        ToolTip.visible: hovered
        ToolTip.text: I18n.i18nc("@info:tooltip", "Set to current time")
        ToolTip.delay: Kirigami.Units.toolTipDelay

        onClicked: {
            nowButton.forceActiveFocus();
            const currentTime = new Date();
            root.hours = currentTime.getHours();
            root.minutes = currentTime.getMinutes();
        }
    }
}
