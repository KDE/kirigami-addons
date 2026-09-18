// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.dateandtime
import org.kde.kirigamiaddons.components as Components
import org.kde.kirigamiaddons.delegates as Delegates

QQC2.Control {
    id: root

    signal datePicked(DateTime pickedDate)

    property DateTime selectedDate: DateTimeFactory.now() // Decides calendar span
    readonly property int year: selectedDate.year
    readonly property int month: selectedDate.month - 1 // 0-indexed, to match the JS Date arithmetic below
    readonly property int day: selectedDate.day
    property bool showDays: true
    property bool showControlHeader: true

    /**
     * This property holds the minimum date (inclusive) that the user can select.
     *
     * By default, no limit is applied to the date selection.
     */
    property DateTime minimumDate

    /**
     * This property holds the maximum date (inclusive) that the user can select.
     *
     * By default, no limit is applied to the date selection.
     */
    property DateTime maximumDate

    topPadding: Kirigami.Units.largeSpacing
    rightPadding: Kirigami.Units.largeSpacing
    bottomPadding: Kirigami.Units.largeSpacing
    leftPadding: Kirigami.Units.largeSpacing

    onActiveFocusChanged: if (activeFocus) {
        dateSegmentedButton.forceActiveFocus();
    }

    property bool _completed: false
    property bool _runSetDate: false

    onSelectedDateChanged: if (_completed) {
        setToDate(selectedDate)
    }

    Component.onCompleted: {
        _completed = true;
        setToDate(selectedDate);
    }
    onShowDaysChanged: if (!showDays) pickerView.currentIndex = 1;

    function setToDate(date: DateTime): void {
        if (_runSetDate) {
            return;
        }
        _runSetDate = true;

        if (root.minimumDate.isValid && date < minimumDate) {
            date = minimumDate;
        }

        if (root.maximumDate.isValid && date > maximumDate) {
            date = maximumDate;
        }

        if (yearPathView.currentItem !== null) {
            const yearDiff = date.year - yearPathView.currentItem.startDate.year;
            let newYearIndex = yearPathView.currentIndex + yearDiff;
            let firstYearItemDate = yearPathView.model.data(yearPathView.model.index(1,0), InfiniteCalendarViewModel.StartDateRole);
            let lastYearItemDate = yearPathView.model.data(yearPathView.model.index(yearPathView.model.rowCount() - 2,0), InfiniteCalendarViewModel.StartDateRole);

            // Set to index and create dates if needed for year view
            while (firstYearItemDate >= date) {
                yearPathView.model.addDates(false)
                firstYearItemDate = yearPathView.model.data(yearPathView.model.index(1,0), InfiniteCalendarViewModel.StartDateRole);
                newYearIndex = 0;
            }
            if (firstYearItemDate < date && newYearIndex === 0) {
                newYearIndex = date.year - firstYearItemDate.year + 1;
            }

            while (lastYearItemDate <= date) {
                yearPathView.model.addDates(true)
                lastYearItemDate = yearPathView.model.data(yearPathView.model.index(yearPathView.model.rowCount() - 1,0), InfiniteCalendarViewModel.StartDateRole);
            }

            yearPathView.currentIndex = newYearIndex;
        }

        if (decadePathView.currentItem !== null) {
            // For the decadeDiff we add one to the input date year so that we use e.g. 2021, making the pathview move to the grid that contains the 2020 decade
            // instead of staying within the 2010 decade, which contains a 2020 cell at the very end
            const decadeDiff = Math.floor((date.year + 1 - decadePathView.currentItem.startDate.year) / 12); // 12 years in one decade grid
            let newDecadeIndex = decadePathView.currentIndex + decadeDiff;
            let firstDecadeItemDate = decadePathView.model.data(decadePathView.model.index(1,0), InfiniteCalendarViewModel.StartDateRole);
            let lastDecadeItemDate = decadePathView.model.data(decadePathView.model.index(decadePathView.model.rowCount() - 1,0), InfiniteCalendarViewModel.StartDateRole);

            // Set to index and create dates if needed for decade view
            while (firstDecadeItemDate >= date) {
                decadePathView.model.addDates(false)
                firstDecadeItemDate = decadePathView.model.data(decadePathView.model.index(1,0), InfiniteCalendarViewModel.StartDateRole);
                newDecadeIndex = 0;
            }
            if (firstDecadeItemDate < date && newDecadeIndex === 0) {
                newDecadeIndex = date.year - firstDecadeItemDate.year + 1;
            }

            while (lastDecadeItemDate.year <= date.year) {
                decadePathView.model.addDates(true)
                lastDecadeItemDate = decadePathView.model.data(decadePathView.model.index(decadePathView.model.rowCount() - 1,0), InfiniteCalendarViewModel.StartDateRole);
            }

            decadePathView.currentIndex = newDecadeIndex;
        }

        if (showDays && monthPathView.currentItem !== null) { // Set to correct index, including creating new dates in model if needed, for the month view
            const monthDiff = date.month - monthPathView.currentItem.firstDayOfMonth.month + (12 * (date.year - monthPathView.currentItem.firstDayOfMonth.year));
            let newMonthIndex = monthPathView.currentIndex + monthDiff;
            let firstMonthItemDate = monthPathView.model.data(monthPathView.model.index(1,0), InfiniteCalendarViewModel.FirstDayOfMonthRole);
            let lastMonthItemDate = monthPathView.model.data(monthPathView.model.index(monthPathView.model.rowCount() - 1,0), InfiniteCalendarViewModel.FirstDayOfMonthRole);

            while(firstMonthItemDate >= date) {
                monthPathView.model.addDates(false)
                firstMonthItemDate = monthPathView.model.data(monthPathView.model.index(1,0), InfiniteCalendarViewModel.FirstDayOfMonthRole);
                newMonthIndex = 0;
            }
            if(firstMonthItemDate < date && newMonthIndex === 0) {
                newMonthIndex = date.month - firstMonthItemDate.month + (12 * (date.year - firstMonthItemDate.year)) + 1;
            }

            while(lastMonthItemDate <= date) {
                monthPathView.model.addDates(true)
                lastMonthItemDate = monthPathView.model.data(monthPathView.model.index(monthPathView.model.rowCount() - 1,0), InfiniteCalendarViewModel.FirstDayOfMonthRole);
            }

            monthPathView.currentIndex = newMonthIndex;
        }

        _runSetDate = false;
    }

    function goToday(): void {
        selectedDate = DateTimeFactory.now();
    }

    function prevMonth(): void {
        const newDate = selectedDate.addMonths(-1);
        if (root.minimumDate.isValid && newDate < minimumDate) {
            if (selectedDate === minimumDate) {
                return;
            }
            selectedDate = minimumDate;
        } else {
            selectedDate = newDate;
        }
    }

    function nextMonth(): void {
        const newDate = selectedDate.addMonths(1);
        if (root.maximumDate.isValid && newDate > maximumDate) {
            if (selectedDate === maximumDate) {
                return;
            }
            selectedDate = maximumDate;
            return;
        } else {
            selectedDate = newDate;
        }
    }

    function prevYear(): void {
        const newDate = selectedDate.addYears(-1);
        if (root.minimumDate.isValid && newDate < minimumDate) {
            if (selectedDate === minimumDate) {
                return;
            }
            selectedDate = minimumDate;
        } else {
            selectedDate = newDate;
        }
    }

    function nextYear(): void {
        const newDate = selectedDate.addYears(1);
        if (root.maximumDate.isValid && newDate > maximumDate) {
            if (selectedDate === maximumDate) {
                return;
            }
            selectedDate = maximumDate;
        } else {
            selectedDate = newDate;
        }
    }

    function prevDecade(): void {
        const newDate = selectedDate.addYears(-10);
        if (root.minimumDate.isValid && newDate < minimumDate) {
            if (selectedDate === minimumDate) {
                return;
            }
            selectedDate = minimumDate;
        } else {
            selectedDate = newDate;
        }
    }

    function nextDecade(): void {
        const newDate = selectedDate.addYears(10);
        if (root.maximumDate.isValid && newDate > maximumDate) {
            if (selectedDate === maximumDate) {
                return;
            }
            selectedDate = maximumDate;
        } else {
            selectedDate = newDate;
        }
    }

    contentItem: ColumnLayout {
        id: pickerLayout

        RowLayout {
            id: headingRow
            Layout.fillWidth: true
            Layout.bottomMargin: Kirigami.Units.smallSpacing

            Components.SegmentedButton {
                id: dateSegmentedButton

                actions: [
                    Kirigami.Action {
                        id: dayAction
                        text: root.selectedDate.toLocaleDateString("d")
                        onTriggered: pickerView.currentIndex = 0 // dayGrid is first item in pickerView
                        checked: pickerView.currentIndex === 0
                    },
                    Kirigami.Action {
                        id: monthAction
                        text: root.selectedDate.toLocaleDateString("MMMM")
                        onTriggered: pickerView.currentIndex = 1
                        checked: pickerView.currentIndex === 1
                    },
                    Kirigami.Action {
                        id: yearsViewCheck
                        text: root.selectedDate.toLocaleDateString("yyyy")
                        onTriggered: pickerView.currentIndex = 2
                        checked: pickerView.currentIndex === 2
                    }
                ]
            }

            Instantiator {
                model:dateSegmentedButton.children
                Item {
                    required property Item modelData
                    parent: modelData
                    anchors.fill: parent
                    Accessible.ignored: !modelData.action
                    Accessible.role: Accessible.Dial
                    Accessible.focusable: true
                    Accessible.focused: parent.activeFocus
                    Accessible.name: {
                        if (modelData.action === dayAction) {
                            return i18nd("kirigami-addons6", "Day")
                        }
                        if (modelData.action === monthAction) {
                            return i18nd("kirigami-addons6", "Month")
                        }
                        if (modelData.action === yearsViewCheck) {
                            return i18nd("kirigami-addons6", "Year")
                        }
                        return ""
                    }
                    property int maximumValue: {
                        if (modelData.action === dayAction) {
                            if (maximumDate.isValid && root.year === maximumDate.year && root.month === maximumDate.month - 1) {
                                return maximumDate.day
                            }
                            return 31
                        }
                        if (modelData.action === monthAction) {
                             if (maximumDate.isValid && root.year === maximumDate.year) {
                                return maximumDate.month
                            }
                            return 12
                        }
                        if (modelData.action === yearsViewCheck) {
                            if (maximumDate.isValid) {
                                return maximumDate.year
                            }
                            return 9999
                        }
                        return 0
                    }
                    property int minimumValue: {
                        if (modelData.action === dayAction) {
                            if (minimumDate.isValid && root.year === minimumDate.year && root.month === minimumDate.month - 1) {
                                return minimumDate.day
                            }
                            return 1
                        }
                        if (modelData.action === monthAction) {
                             if (minimumDate.isValid && root.year === minimumDate.year) {
                                return minimumDate.month
                            }
                            return 1
                        }
                        if (modelData.action === yearsViewCheck) {
                            if (minimumDate.isValid) {
                                return minimumDate.year
                            }
                            return -9999
                        }
                        return 0
                    }
                    property int stepSize: 1
                    property int value: {
                        if (modelData.action === dayAction) {
                            return root.day
                        }
                        if (modelData.action === monthAction) {
                            return root.month + 1
                        }
                        if (modelData.action === yearsViewCheck) {
                            return root.year
                        }
                        return 0
                    }
                    onValueChanged: {
                        if (modelData.action === dayAction) {
                            selectedDate.day = value;
                        }
                        if (modelData.action === monthAction) {
                            selectedDate.month = value;
                        }
                        if (modelData.action === yearsViewCheck) {
                            selectedDate.year = value;
                        }
                    }
                }
                onObjectAdded: (index, object) => {
                    object.modelData.Accessible.ignored = true
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Components.SegmentedButton {
                actions: [
                    Kirigami.Action {
                        id: goPreviousAction
                        icon.name: Application.layoutDirection === Qt.RightToLeft ? 'go-previous-rtl-symbolic' : 'go-previous-view-symbolic'
                        text: i18ndc("kirigami-addons6", "@action:button", "Go Previous")
                        displayHint: Kirigami.DisplayHint.IconOnly
                        onTriggered: {
                            if (pickerView.currentIndex === 1) { // monthGrid index
                                prevYear();
                            } else if (pickerView.currentIndex === 2) { // yearGrid index
                                prevDecade();
                            } else { // dayGrid index
                                prevMonth();
                            }
                        }
                    },
                    Kirigami.Action {
                        text: i18ndc("kirigami-addons6", "@action:button", "Jump to today")
                        displayHint: Kirigami.DisplayHint.IconOnly
                        icon.name: 'go-jump-today-symbolic'
                        onTriggered: goToday()
                    },
                    Kirigami.Action {
                        id: goNextAction
                        text: i18ndc("kirigami-addons6", "@action:button", "Go Next")
                        icon.name: Application.layoutDirection === Qt.RightToLeft ? 'go-next-rtl-symbolic' : 'go-next-view-symbolic'
                        displayHint: Kirigami.DisplayHint.IconOnly
                        onTriggered: {
                            if (pickerView.currentIndex === 1) { // monthGrid index
                                nextYear();
                            } else if (pickerView.currentIndex === 2) { // yearGrid index
                                nextDecade();
                            } else { // dayGrid index
                                nextMonth();
                            }
                        }
                    }
                ]
            }
        }

        QQC2.SwipeView {
            id: pickerView
            objectName: "pickerView"

            clip: true
            interactive: false
            padding: 0

            Layout.fillWidth: true
            Layout.fillHeight: true

            DatePathView {
                id: monthPathView
                objectName: "monthPathView"

                mainView: pickerView
                enabled: QQC2.SwipeView.isCurrentItem

                model: InfiniteCalendarViewModel {
                    scale: InfiniteCalendarViewModel.MonthScale
                    currentDate: root.selectedDate
                    minimumDate: root.minimumDate
                    maximumDate: root.maximumDate
                    datesToAdd: 10
                }


                delegate: Loader {
                    id: monthViewLoader
                    property DateTime firstDayOfMonth: model.firstDay
                    property bool isNextOrCurrentItem: index >= monthPathView.currentIndex -1 && index <= monthPathView.currentIndex + 1

                    active: isNextOrCurrentItem && root.showDays

                    sourceComponent: GridLayout {
                        id: dayGrid
                        columns: 7
                        rows: 7
                        width: monthPathView.width
                        height: monthPathView.height
                        Layout.topMargin: Kirigami.Units.smallSpacing

                        property var modelLoader: Loader {
                            asynchronous: true
                            sourceComponent: MonthModel {
                                year: monthViewLoader.firstDayOfMonth.year
                                month: monthViewLoader.firstDayOfMonth.month // From pathview model
                            }
                        }

                        QQC2.ButtonGroup {
                            id: monthGroup
                        }

                        Repeater {
                            model: dayGrid.modelLoader.item?.weekDays
                            delegate: QQC2.Label {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                horizontalAlignment: Text.AlignHCenter
                                rightPadding: Kirigami.Units.mediumSpacing
                                leftPadding: Kirigami.Units.mediumSpacing
                                opacity: 0.7
                                text: modelData
                                Accessible.ignored: true
                            }
                        }

                        Repeater {
                            id: dayRepeater
                            objectName: "dayRepeater"

                            model: dayGrid.modelLoader.item

                            delegate: DatePickerDelegate {
                                id: dayDelegate

                                required property bool isToday
                                required property bool sameMonth
                                required property int dayNumber

                                objectName: "day-" + date.year + "-" + date.month + "-" + date.day
                                repeater: dayRepeater
                                minimumDate: root.minimumDate
                                maximumDate: root.maximumDate
                                previousAction: goPreviousAction
                                nextAction: goNextAction

                                horizontalPadding: 0

                                Accessible.name: date.toLocaleDateString()
                                Accessible.ignored: !monthPathView.QQC2.SwipeView.isCurrentItem || !monthViewLoader.PathView.isCurrentItem

                                QQC2.ButtonGroup.group: monthGroup

                                background {
                                    visible: sameMonth
                                }

                                highlighted: isToday
                                checkable: true
                                checked: date.day === selectedDate.day &&
                                    date.month === selectedDate.month &&
                                    date.year === selectedDate.year
                                opacity: sameMonth && inScope ? 1 : 0.6
                                text: date.toLocaleDateString("d")
                                onClicked: {
                                    selectedDate = date;
                                    datePicked(date);
                                }
                            }
                        }
                    }
                }

                onCurrentIndexChanged: {
                    if (pickerView.currentIndex === 0) {
                        // Built via JS Date rather than DateTime.month/year setters: if the
                        // current day doesn't exist in the target month (e.g. day 31 in
                        // February), those setters would produce an invalid date, while
                        // new Date() rolls the day over into the following month instead.
                        root.selectedDate.dateTime = new Date(currentItem.firstDayOfMonth.year, currentItem.firstDayOfMonth.month - 1, root.selectedDate.day);
                    }

                    if (currentIndex >= count - 2) {
                        model.addDates(true);
                    } else if (currentIndex <= 1) {
                        model.addDates(false);
                        startIndex += model.datesToAdd;
                    }
                }
            }

            DatePathView {
                id: yearPathView

                mainView: pickerView

                model: InfiniteCalendarViewModel {
                    scale: InfiniteCalendarViewModel.YearScale
                    currentDate: root.selectedDate
                }

                delegate: Loader {
                    id: yearViewLoader

                    required property int index
                    required property DateTime startDate

                    property bool isNextOrCurrentItem: index >= yearPathView.currentIndex -1 && index <= yearPathView.currentIndex + 1

                    width: parent.width
                    height: parent.height

                    active: isNextOrCurrentItem

                    sourceComponent: GridLayout {
                        id: yearGrid
                        columns: 3
                        rows: 4

                        QQC2.ButtonGroup {
                            id: yearGroup
                        }

                        Repeater {
                            id: monthRepeater

                            model: yearGrid.columns * yearGrid.rows

                            delegate: DatePickerDelegate {
                                id: monthDelegate

                                date: DateTimeFactory.fromDateTime(new Date(yearViewLoader.startDate.year, index))
                                objectName: "month-" + date.year + "-" + date.month

                                minimumDate: root.minimumDate.isValid ? root.minimumDate.startOfMonth().addDays(-1) : DateTimeFactory.invalid()
                                maximumDate: root.maximumDate.isValid ? root.maximumDate.endOfMonth() : DateTimeFactory.invalid()
                                repeater: monthRepeater
                                previousAction: goPreviousAction
                                nextAction: goNextAction

                                Accessible.ignored: !yearPathView.QQC2.SwipeView.isCurrentItem || !yearViewLoader.PathView.isCurrentItem
                                Accessible.name: date.toLocaleDateString("MMMM yyyy")

                                QQC2.ButtonGroup.group: yearGroup

                                horizontalPadding: padding * 2
                                rightPadding: undefined
                                leftPadding: undefined
                                highlighted: date.month === DateTimeFactory.now().month &&
                                    date.year === DateTimeFactory.now().year
                                checkable: true
                                checked: date.month === selectedDate.month &&
                                    date.year === selectedDate.year
                                text: Qt.locale().standaloneMonthName(date.month - 1)
                                onClicked: {
                                    selectedDate = date;
                                    root.datePicked(date);
                                    if(root.showDays) pickerView.currentIndex = 0;
                                }
                            }
                        }
                    }
                }

                onCurrentIndexChanged: {
                    if (pickerView.currentIndex === 1) {
                        // See the month view's onCurrentIndexChanged for why this goes
                        // through JS Date instead of DateTime.year's setter.
                        root.selectedDate.dateTime = new Date(currentItem.startDate.year, root.selectedDate.month - 1, root.selectedDate.day);
                    }

                    if (currentIndex >= count - 2) {
                        model.addDates(true);
                    } else if (currentIndex <= 1) {
                        model.addDates(false);
                        startIndex += model.datesToAdd;
                    }
                }

            }

            DatePathView {
                id: decadePathView

                mainView: pickerView

                model: InfiniteCalendarViewModel {
                    scale: InfiniteCalendarViewModel.DecadeScale
                    currentDate: root.selectedDate
                }

                delegate: Loader {
                    id: decadeViewLoader

                    required property int index
                    required property DateTime startDate

                    property bool isNextOrCurrentItem: index >= decadePathView.currentIndex -1 && index <= decadePathView.currentIndex + 1

                    width: parent.width
                    height: parent.height

                    active: isNextOrCurrentItem

                    sourceComponent: GridLayout {
                        id: decadeGrid

                        columns: 3
                        rows: 4

                        QQC2.ButtonGroup {
                            id: decadeGroup
                        }

                        Repeater {
                            id: decadeRepeater

                            model: decadeGrid.columns * decadeGrid.rows

                            delegate: DatePickerDelegate {
                                id: yearDelegate

                                readonly property bool sameDecade: Math.floor(date.year / 10) == Math.floor(year / 10)

                                Accessible.ignored: !decadePathView.QQC2.SwipeView.isCurrentItem || !decadeViewLoader.PathView.isCurrentItem
                                QQC2.ButtonGroup.group: decadeGroup

                                date: DateTimeFactory.fromDateTime(new Date(startDate.year + index, 0))
                                objectName: "year-" + date.year
                                minimumDate: root.minimumDate.isValid ? root.minimumDate.startOfMonth().addDays(-1) : DateTimeFactory.invalid()
                                maximumDate: root.maximumDate.isValid ? root.maximumDate.endOfYear() : DateTimeFactory.invalid()
                                repeater: decadeRepeater
                                previousAction: goPreviousAction
                                nextAction: goNextAction

                                highlighted: date.year === DateTimeFactory.now().year

                                horizontalPadding: padding * 2
                                rightPadding: undefined
                                leftPadding: undefined
                                checkable: true
                                checked: date.year === selectedDate.year
                                opacity: sameDecade ? 1 : 0.7
                                text: date.toLocaleDateString("yyyy")
                                onClicked: {
                                    selectedDate = date;
                                    root.datePicked(date);
                                    pickerView.currentIndex = 1;
                                }
                            }
                        }
                    }
                }

                onCurrentIndexChanged: {
                    if (pickerView.currentIndex === 2) {
                        // +1 because startDate is e.g. 2019 but we want the 2020 decade
                        // selected. See the month view's onCurrentIndexChanged for why
                        // this goes through JS Date instead of DateTime's setters.
                        root.selectedDate.dateTime = new Date(currentItem.startDate.year + 1, root.selectedDate.month - 1, root.selectedDate.day);
                    }

                    if (currentIndex >= count - 2) {
                        model.addDates(true);
                    } else if (currentIndex <= 1) {
                        model.addDates(false);
                        startIndex += model.datesToAdd;
                    }
                }

            }
        }
    }
}