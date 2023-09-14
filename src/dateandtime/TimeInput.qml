/*
 *   SPDX-FileCopyrightText: 2019 David Edmundson <davidedmundson@kde.org>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.20 as Kirigami
import org.kde.kirigamiaddons.dateandtime 0.1

/**
 * TimeInput is a single line time editor.
 */
QQC2.TextField {
    id: timeInput

    /**
     * This property holds the desired time format.
     */
    property string format: Qt.locale().timeFormat(Locale.ShortFormat)

    /**
     * This property holds the current time value.
     */
    property date value: new Date()

    // The text field acts as a time input field.
    inputMethodHints: Qt.ImhTime

    validator: TimeInputValidator {
        id: timeValidator
        format: timeInput.format
    }

    onEditingFinished: textToValue()
    onValueChanged: valueToText()

    function textToValue() {
        const locale = Qt.locale();
        timeInput.value = Date.fromLocaleTimeString(locale, timeInput.text, timeInput.format);
    }

    function valueToText() {
        const locale = Qt.locale();
        timeInput.text = timeInput.value.toLocaleTimeString(locale, timeInput.format);
    }

    Component.onCompleted: valueToText()

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: Kirigami.Settings.isMobile
        property bool androidPickerActive: false
        onClicked: if (Qt.platform.os === 'android') {
            androidPickerActive = true;
            AndroidIntegration.showTimePicker(timeInput.value.getTime());
        } else {
            popup.open();
        }
        Connections {
            enabled: Qt.platform.os === 'android' && mouseArea.androidPickerActive
            ignoreUnknownSignals: !enabled
            target: enabled ? AndroidIntegration : null
            function onTimePickerFinished(accepted, newDate) {
                mouseArea.androidPickerActive = false;
                if (accepted) {
                    timeInput.value = newDate;
                }
            }
        }
    }

    QQC2.Popup {
        id: popup
        x: parent ? Math.round((parent.width - width) / 2) : 0
        y: parent ? Math.round((parent.height - height) / 2) : 0
        modal: true

        contentItem: TumblerTimePicker {
            id: popupContent
            implicitWidth: applicationWindow().width
            minutes: timeInput.value.getMinutes()
            hours: timeInput.value.getHours()
            onMinutesChanged: {
                const date = new Date(timeInput.value);
                date.setHours(hours, minutes);
                timeInput.value = date;
            }
            onHoursChanged: {
                const date = new Date(timeInput.value);
                date.setHours(hours, minutes);
                timeInput.value = date;
            }
        }
    }
}
