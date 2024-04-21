// SPDX-FileCopyrightText: 2021 Han Young <hanyoung@protonmail.com>
// SPDX-FileCopyrightText: 2022 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.kirigami 2.20 as Kirigami
import QtQuick.Layouts 1.15
import org.kde.kirigamiaddons.dateandtime 1.0

/**
 * A large time picker
 * Represented as a clock provides a very visual way for a user
 * to set and visulise a time being chosen
 */
RowLayout {
    id: root

    /**
     * This property holds the current hours selected. This is a number between 0 and 23.
     */
    property int hours

    /**
     * This property holds the current minutes selected. This is a number between 0 and 59.
     */
    property int minutes

    property bool _pm: false

    property bool _init: false

    readonly property bool _isAmPm: Qt.locale().timeFormat().includes("AP")

    implicitHeight: Kirigami.Units.gridUnit * 5
    implicitWidth: Kirigami.Units.gridUnit * 10

    Component.onCompleted: {
        hoursTumbler.currentIndex = (_isAmPm && hours > 12 ? hours - 12 : hours);
        minutesTumbler.currentIndex = minutes;
        if (_isAmPm) {
            root._pm = hours > 12 ? 1 : 0;
            amPmTumbler.currentIndex = _pm;
        }

        // Avoid initialisation bug where thumbler are by default initialised
        // to currentIndex 0
        _init = true;
    }

    function formatText(count, modelData) {
        var data = count === 12 && modelData === 0 ? 12 : modelData;
        return data.toString().length < 2 ? "0" + data : data;
    }

    FontMetrics {
        id: fontMetrics
    }

    Component {
        id: delegateComponent
        Label {
            id: delegate

            text: formatText(Tumbler.tumbler.count, modelData)
            opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: fontMetrics.font.pixelSize * 1.25
            Accessible.ignored: true

            Rectangle {
                anchors.fill: parent
                color: 'transparent'
                radius: Kirigami.Units.mediumSpacing
                border {
                    width: delegate === Tumbler.tumbler.currentItem ? 1 : 0
                    color: Kirigami.Theme.highlightColor
                }
            }
        }
    }

    Item {
        Layout.fillWidth: true
    }

    Tumbler {
        id: hoursTumbler
        Layout.preferredHeight: Kirigami.Units.gridUnit * 10
        model: _isAmPm ? 12 : 24
        delegate: delegateComponent
        visibleItemCount: 5
        onCurrentIndexChanged: if (_init) {
            hours = currentIndex + (_isAmPm && _pm ? 12 : 0)
        }
        Accessible.name: i18nd("kirigami-addons6", "Hours")
        Accessible.role: Accessible.Dial
        Accessible.onDecreaseAction: hoursTumbler.currentIndex = (hoursTumbler.currentIndex + hoursTumbler.model - 1) % hoursTumbler.model
        Accessible.onIncreaseAction: hoursTumbler.currentIndex = (hoursTumbler.currentIndex + 1) % hoursTumbler.model
        // a11y value interface
        property int minimumValue: root._isAmPm ? 1 : 0
        property int maximumValue: root._isAmPm ? 12 : 23
        property int stepSize: 1
        property int value: root.hours
        onValueChanged: {
            if (root._isAmPm && value === 12)
                hoursTumbler.currentIndex = 0;
            else
                hoursTumbler.currentIndex = value;
            hoursTumbler.value = Qt.binding(function() { return root.hours; });
        }

        focus: true
    }

    Label {
        Layout.alignment: Qt.AlignCenter
        text: i18ndc("kirigami-addons6", "Time separator", ":")
        font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.3
        Accessible.ignored: true
    }

    Tumbler {
        id: minutesTumbler
        Layout.preferredHeight: Kirigami.Units.gridUnit * 10
        model: 60
        delegate: delegateComponent
        visibleItemCount: 5
        onCurrentIndexChanged: if (_init) {
            minutes = currentIndex;
        }

        Accessible.name: i18nd("kirigami-addons6", "Minutes")
        Accessible.role: Accessible.Dial
        Accessible.onDecreaseAction: minutesTumbler.currentIndex = (minutesTumbler.currentIndex + 59) % 60
        Accessible.onIncreaseAction: minutesTumbler.currentIndex = (minutesTumbler.currentIndex + 1) % 60
        // a11y value interface
        property int minimumValue: 0
        property int maximumValue: 59
        property int stepSize: 1
        property alias value: minutesTumbler.currentIndex
    }

    Tumbler {
        id: amPmTumbler
        visible: _isAmPm
        Layout.preferredHeight: Kirigami.Units.gridUnit * 10
        model: [Qt.locale().amText, Qt.locale().pmText]
        Accessible.name: currentItem.text
        Accessible.role: Accessible.CheckBox
        Accessible.ignored: !_isAmPm
        Accessible.onPressAction: amPmTumbler.currentIndex = (amPmTumbler.currentIndex + 1) % 2
        Accessible.onToggleAction: amPmTumbler.currentIndex = (amPmTumbler.currentIndex + 1) % 2
        delegate: delegateComponent
        visibleItemCount: 5
        onCurrentIndexChanged: if (_isAmPm && _init) {
            _pm = currentIndex;
            hours = (hours + 12) % 24;
        }
    }

    Item {
        Layout.fillWidth: true
    }
}
