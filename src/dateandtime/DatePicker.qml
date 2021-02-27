// SPDX-FileCopyrightText: 2019 David Edmundson <davidedmundson@kde.org>
// SPDX-FileCopyrightText: 2021 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import org.kde.kirigami 2.14 as Kirigami
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigamiaddons.dateandtime 0.1
import QtQml.Models 2.15

/**
 * A large date picker
 *
 * Use case is for picking a date and visualising that in
 * context of a calendar view
 */
Controls.Control {
    id: monthView

    /**
     * @brief The selected date.
     */
    property alias selectedDate: monthModel.selected;

    /**
     * @property int DatePicker::year
     * @brief The year displayed by the month view.
     */
    property alias year: monthModel.year

    /**
     * @property int DatePicker::month
     * @brief The month displayed by the month view.
     */
    property alias month: monthModel.month

    /**
     * Go to the next month.
     */
    function nextMonth() {
        monthModel.next();
    }

    /**
     * Move calendar view to today
     */
    function goToday() {
        monthModel.goToday();
        selectedDate = new Date(Date.now());
    }

    /**
     * Go to the previous month.
     */
    function previousMonth() {
        monthModel.previous();
    }

    /**
     * Model powering the month view, by default it is using a model
     * without KCoreCalendar::Calendar loaded and just display an
     * empty calendar.
     */
    property var model: MonthModel {
        id: monthModel
        onYearChanged: yearList.currentIndex = year;
    }

    /**
     * \internal
     */
    readonly property bool isLarge: width > Kirigami.Units.gridUnit * 40

    background: Rectangle {
        Kirigami.Theme.colorSet: monthView.isLarge ? Kirigami.Theme.Header : Kirigami.Theme.View
        color: monthView.isLarge ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.backgroundColor
    }

    Component {
        id: mobileMonthDelegate
        Controls.AbstractButton {
            id: button
            implicitWidth: monthGrid.width / 7
            implicitHeight: (monthGrid.height - Kirigami.Units.gridUnit * 2) / 6
            Layout.fillWidth: true
            Layout.fillHeight: true
            padding: 0
            onClicked: monthView.selectedDate = model.date
            contentItem: Kirigami.Heading {
                id: number
                topPadding: Kirigami.Units.largeSpacing * 2
                width: parent.width
                level: 3
                text: model.dayNumber
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignTop
                padding: Kirigami.Units.smallSpacing
                opacity: model.sameMonth ? 1 : 0.7
            }

            background: Item {
                visible: model.isSelected || isToday
                Rectangle {
                    anchors.centerIn: parent
                    height: parent.height - Kirigami.Units.smallSpacing
                    color: model.isSelected ? Kirigami.Theme.highlightColor : Kirigami.Theme.positiveBackgroundColor
                    radius: height / 2
                    width: height
                }
            }
        }
    }

    Component {
        id: desktopMonthDelegate
        Controls.AbstractButton {
            id: button
            implicitWidth: monthGrid.width / 7
            implicitHeight: (monthGrid.height - Kirigami.Units.gridUnit * 2) / 6
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: monthView.selectedDate = model.date
            background: Rectangle {
                Kirigami.Theme.colorSet: Kirigami.Theme.View
                color: model.sameMonth ? Kirigami.Theme.backgroundColor : Kirigami.Theme.alternateBackgroundColor
            }
            padding: 0
            Kirigami.Heading {
                id: dayNumber
                level: 3
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: model.dayNumber < 10 ? Kirigami.Units.largeSpacing : 0
                text: model.dayNumber
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignTop
                padding: Kirigami.Units.smallSpacing
                background: Rectangle {
                    visible: model.isSelected || isToday
                    anchors.centerIn: parent
                    height: parent.height - Kirigami.Units.smallSpacing
                    color: model.isSelected ? Kirigami.Theme.highlightColor : Kirigami.Theme.positiveBackgroundColor
                    radius: height / 2
                    width: height
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Controls.ScrollView {
            Layout.fillWidth: true
            Layout.minimumHeight: Kirigami.Units.gridUnit * 2.5
            Controls.ScrollBar.horizontal.policy: Controls.ScrollBar.AlwaysOff
            ListView {
                id: yearList
                property int year: (new Date()).getFullYear();
                Controls.RoundButton {
                    icon.name: "go-previous"
                    onClicked: yearList.currentIndex -= 10;
                    anchors.left: parent.left
                    anchors.leftMargin: Kirigami.Units.smallSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    icon.width: Kirigami.Units.fontMetrics.roundedIconSize(Kirigami.Units.fontMetrics.height)
                    icon.height: Kirigami.Units.fontMetrics.roundedIconSize(Kirigami.Units.fontMetrics.height)
                    implicitWidth: icon.width * 2
                    implicitHeight: icon.height * 2
                    padding: 0
                }
                Controls.RoundButton {
                    icon.name: "go-next"
                    onClicked: yearList.currentIndex += 10;
                    anchors.right: parent.right
                    anchors.rightMargin: Kirigami.Units.smallSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    icon.width: Kirigami.Units.fontMetrics.roundedIconSize(Kirigami.Units.fontMetrics.height)
                    icon.height: Kirigami.Units.fontMetrics.roundedIconSize(Kirigami.Units.fontMetrics.height)
                    implicitWidth: icon.width * 2
                    implicitHeight: icon.height * 2
                    padding: 0
                }
                orientation: Qt.Horizontal
                model: year + 100
                highlightFollowsCurrentItem: true

                // HACK: position the listview to the correct year and don't put the
                // current year to far to the left.
                Component.onCompleted: {
                    currentIndex = -1;
                    currentIndex = monthModel.year - 2;
                    currentIndex = monthModel.year;
                }

                delegate: Controls.ItemDelegate {
                    implicitHeight: Kirigami.Units.gridUnit * 2.5
                    highlighted: yearList.currentIndex == index
                    contentItem: Kirigami.Heading {
                        font.bold: yearList.currentIndex === index
                        text: index
                    }
                    onClicked: {
                        yearList.currentIndex = index;
                        monthModel.year = index;
                    }
                }
            }
        }

        GridLayout {
            id: monthGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 7
            columnSpacing: monthView.isLarge ? 1 : 0
            rowSpacing: monthView.isLarge ? 1 : 0
            Kirigami.Theme.inherit: false

            Repeater {
                model: monthModel.weekDays
                Controls.Control {
                    implicitWidth: monthGrid.width / 7
                    Layout.maximumHeight: Kirigami.Units.gridUnit * 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    padding: Kirigami.Units.smallSpacing
                    contentItem: Kirigami.Heading {
                        text: modelData
                        level: 2
                        horizontalAlignment: monthView.isLarge ? Text.AlignRight : Text.AlignHCenter
                    }
                    background: Rectangle {
                        Kirigami.Theme.colorSet: Kirigami.Theme.View
                        color: !monthView.isLarge ? Kirigami.Theme.backgroundColor : Kirigami.Theme.alternateBackgroundColor
                    }
                }
            }

            Repeater {
                model: monthModel
                delegate: monthView.isLarge ? desktopMonthDelegate : mobileMonthDelegate
            }
        }
    }
}

