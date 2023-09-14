// SPDX-FileCopyrightText: 2021 Han Young <hanyoung@protonmail.com>
// SPDX-FileCopyrightText: 2022 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.kirigami 2.20 as Kirigami
import QtQuick.Layouts 1.15
import org.kde.kirigamiaddons.dateandtime 0.1

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
            amPmTumbler.currentIndex = hours > 12 ? 1 : 0;
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
        Accessible.name: if (!_isAmPm) {
            i18ndc("kirigami-addons", "time in hour in 24h format", "%1 hours", root.hours)
        } else if (_isAmPm && _pm) {
            i18ndc("kirigami-addons", "time in hour (PM)", "%1 PM", currentIndex + 12)
        } else {
            i18ndc("kirigami-addons", "time in hour (AM)", "%1 AM", currentIndex)
        }
        focus: true
    }

    Label {
        Layout.alignment: Qt.AlignCenter
        text: i18ndc("kirigami-addons", "Time separator", ":")
        font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.3
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

        Accessible.name: i18ndc("kirigami-addons", "number of minutes", "%1 minutes", root.hours)
    }

    Tumbler {
        id: amPmTumbler
        visible: _isAmPm
        Layout.preferredHeight: Kirigami.Units.gridUnit * 10
        model: [Qt.locale().amText, Qt.locale().pmText]
        Accessible.name: currentItem.text
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
