// SPDX-FileCopyrightText: 2021 Han Young <hanyoung@protonmail.com>
// SPDX-FileCopyrightText: 2022 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import QtQuick.Layouts
import org.kde.kirigamiaddons.dateandtime

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

    readonly property var _locale: Qt.locale()
    readonly property color _highlightColor: Kirigami.Theme.highlightColor
    readonly property real _delegateFontSize: fontMetrics.font.pixelSize * 1.25
    readonly property real _delegateRadius: Kirigami.Units.mediumSpacing
    readonly property bool _isAmPm: _locale.timeFormat().toLowerCase().includes("ap")
    readonly property var _hoursModel: {
        const model = [];
        for (let i = 0; i < 24; ++i) {
            model.push(formatNumber(i));
        }
        return model;
    }
    readonly property var _hoursAmPmModel: {
        const model = [];
        for (let i = 0; i < 12; ++i) {
            model.push(formatNumber(i === 0 ? 12 : i));
        }
        return model;
    }
    readonly property var _minutesModel: {
        const model = [];
        for (let i = 0; i < 60; ++i) {
            model.push(formatNumber(i));
        }
        return model;
    }

    implicitHeight: Kirigami.Units.gridUnit * 5
    implicitWidth: Kirigami.Units.gridUnit * 10

    Component.onCompleted: initializeTime()

    function initializeTime(): void {
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

    function formatNumber(value): string {
        const s = _locale.toString(value);
        if (s.length < 2 && _locale.zeroDigit === "0")
            return "0" + s;
        return s;
    }

    FontMetrics {
        id: fontMetrics
    }

    Component {
        id: delegateComponent
        Label {
            id: delegate

            readonly property real opacityScale: 2 / Tumbler.tumbler.visibleItemCount

            text: modelData
            opacity: 1.0 - Math.abs(Tumbler.displacement) * opacityScale
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: root._delegateFontSize
            Accessible.ignored: true

            Rectangle {
                anchors.fill: parent
                color: 'transparent'
                radius: root._delegateRadius
                border {
                    width: {
                        return delegate === Tumbler.tumbler.currentItem
                            ? Tumbler.tumbler.visualFocus ? 2 : 1
                            : 0;
                    }
                    color: root._highlightColor
                }
            }

            TapHandler {
                onTapped: {
                    const tumbler = delegate.Tumbler.tumbler;
                    tumbler.currentIndex = index;
                }
            }
        }
    }

    Item {
        Layout.fillWidth: true
    }

    Button {
        objectName: "resetToNowButton"
        implicitHeight: hoursTumbler.currentItem.height + 2
        text: i18nc("@action:button", "Reset to current time")
        icon.name: "accept_time_event-symbolic"
        display: Button.IconOnly

        ToolTip.visible: hovered
        ToolTip.text: text
        ToolTip.delay: Kirigami.Units.toolTipDelay

        onPressed: {
            const now = DateTimeFactory.now();
            root.minutes = now.minute;
            root.hours = now.hour;
            root.initializeTime();
        }
    }

    Tumbler {
        id: hoursTumbler
        Layout.preferredHeight: Kirigami.Units.gridUnit * 10
        model: _isAmPm ? root._hoursAmPmModel : root._hoursModel
        delegate: delegateComponent
        visibleItemCount: 5
        onCurrentIndexChanged: if (_init) {
            hours = currentIndex + (_isAmPm && _pm ? 12 : 0)
        }
        Accessible.name: i18nd("kirigami-addons6", "Hours")
        Accessible.role: Accessible.Dial
        Accessible.onDecreaseAction: hoursTumbler.currentIndex = (hoursTumbler.currentIndex + hoursTumbler.count - 1) % hoursTumbler.count
        Accessible.onIncreaseAction: hoursTumbler.currentIndex = (hoursTumbler.currentIndex + 1) % hoursTumbler.count
        KeyNavigation.right: minutesTumbler
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
        model: root._minutesModel
        delegate: delegateComponent
        visibleItemCount: 5
        onCurrentIndexChanged: if (_init) {
            minutes = currentIndex;
        }

        Accessible.name: i18nd("kirigami-addons6", "Minutes")
        Accessible.role: Accessible.Dial
        Accessible.onDecreaseAction: minutesTumbler.currentIndex = (minutesTumbler.currentIndex + 59) % 60
        Accessible.onIncreaseAction: minutesTumbler.currentIndex = (minutesTumbler.currentIndex + 1) % 60
        KeyNavigation.right: amPmTumbler
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
        model: [root._locale.amText, root._locale.pmText]
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
