// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.dateandtime as DateTime
import org.kde.kirigamiaddons.components as Components

import "private" as Private

/*!
   \qmltype FormDateTimeDelegate
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief FormDateTimeDelegate is a delegate for FormCard that lets the user enter either
   a date, a time or both.

   This component allows to define a minimumDate and maximumDate to restrict
   the date that the user is allowed to enter.

   You should not add a label but instead use the above FormHeader
   to specify what the form delegate refers to.

   \qml
   import org.kde.kirigamiaddons.formcard as FormCard

   FormCard.FormCardPage {
       FormCard.FormHeader {
           title: "Departure"
       }

       FormCard.FormCard {
           FormCard.FormDateTimeDelegate {}

           FormCard.FormDelegateSeparator {}

           FormCard.FormTextFieldDelegate {
               label: "Location"
           }
       }
   }
   \endqml

   \image formdatetimedelegate.png The form card delegate

   \image formdatetimedelegatedatepicker.png The date picker

   \image formdatetimedelegatetimepicker.png The time picker

   \note This component can also be used in a read only mode to display a date.

   \warning This will use the native date and time picker from the platform if
   available. For example this happens on Android.

   \since 0.12.0
 */
AbstractFormDelegate {
    id: root

    enum DateTimeDisplay {
        DateTime,
        Date,
        Time
    }

    /*!
       This property holds which part of the date and time selector are show to the
       user.

       By default both the time and the date are shown.

       Accepted values:
       \value FormDateTimeDelegate.DateTimeDisplay.DateTime Show the date and time.
       \value FormDateTimeDelegate.DateTimeDisplay.Date Show only the date.
       \value FormDateTimeDelegate.DateTimeDisplay.Time Show only the time.
       */
    property int dateTimeDisplay: FormDateTimeDelegate.DateTimeDisplay.DateTime

    /*!
       \deprecated[1.15.0]
       Use \l minimumDateTime instead, which keeps the timezone of the date it was
       given intact.
     */
    property date minimumDate

    /*!
       \since 1.15.0
       This property holds the minimum date and time (inclusive) that the user can
       select.

       By default, no limit is applied to the date selection.
     */
    property DateTime.DateTime minimumDateTime

    /*!
       \deprecated[1.15.0]
       Use \l maximumDateTime instead, which keeps the timezone of the date it was
       given intact.
     */
    property date maximumDate

    /*!
       \since 1.15.0
       This property holds the maximum date and time (inclusive) that the user can
       select.

       By default, no limit is applied to the date selection.
     */
    property DateTime.DateTime maximumDateTime

    /*!
       \deprecated[1.15.0]
       Use \l initialDateTime instead, which keeps the timezone of the date it was
       given intact.
     */
    property date initialValue: new Date()

    /*!
       \since 1.15.0
       This property holds the date and time to use as initial default when
       editing an unset date.

       By default, this is the current date/time.
     */
    property DateTime.DateTime initialDateTime: DateTime.DateTimeFactory.now()

    /*!
       This property holds whether this delegate is readOnly or whether the user
       can select a new time and date.
       \default false
     */
    property bool readOnly: false

    /*!
       \deprecated[1.15.0]
       Use \l dateTime instead. Reading this property, or writing one of its
       components (for example \c{value.setFullYear(...)}), always uses the
       local timezone; \l dateTime keeps the timezone of the date it was given
       intact and can be edited component by component (for example
       \c{dateTime.year = 2024}) without that limitation.
     */
    property date value: new Date()

    /*!
       \since 1.15.0
       \brief The current date and time selected by the user.
     */
    property DateTime.DateTime dateTime

    property bool _syncingValue: false
    property bool _syncingMinimum: false
    property bool _syncingMaximum: false
    property bool _syncingInitial: false

    onValueChanged: {
        if (root._syncingValue) {
            return;
        }
        root._syncingValue = true;
        root.dateTime.dateTime = root.value;
        root._syncingValue = false;
    }
    onDateTimeChanged: {
        if (root._syncingValue) {
            return;
        }
        root._syncingValue = true;
        root.value = root.dateTime.dateTime;
        root._syncingValue = false;
    }

    onMinimumDateChanged: {
        if (root._syncingMinimum) {
            return;
        }
        root._syncingMinimum = true;
        root.minimumDateTime.dateTime = root.minimumDate;
        root._syncingMinimum = false;
    }
    onMinimumDateTimeChanged: {
        if (root._syncingMinimum) {
            return;
        }
        root._syncingMinimum = true;
        root.minimumDate = root.minimumDateTime.dateTime;
        root._syncingMinimum = false;
    }

    onMaximumDateChanged: {
        if (root._syncingMaximum) {
            return;
        }
        root._syncingMaximum = true;
        root.maximumDateTime.dateTime = root.maximumDate;
        root._syncingMaximum = false;
    }
    onMaximumDateTimeChanged: {
        if (root._syncingMaximum) {
            return;
        }
        root._syncingMaximum = true;
        root.maximumDate = root.maximumDateTime.dateTime;
        root._syncingMaximum = false;
    }

    onInitialValueChanged: {
        if (root._syncingInitial) {
            return;
        }
        root._syncingInitial = true;
        root.initialDateTime.dateTime = root.initialValue;
        root._syncingInitial = false;
    }
    onInitialDateTimeChanged: {
        if (root._syncingInitial) {
            return;
        }
        root._syncingInitial = true;
        root.initialValue = root.initialDateTime.dateTime;
        root._syncingInitial = false;
    }

    /*!
       \qmlproperty var status
       \brief This property holds the current status message type of
       the text field.

       This consists of an inline message with a colorful background
       and an appropriate icon.

       The status property will affect the color of statusMessage used.

       Accepted values:
       \value Kirigami.MessageType.Information (blue color)
       \value Kirigami.MessageType.Positive (green color)
       \value Kirigami.MessageType.Warning (orange color)
       \value Kirigami.MessageType.Error (red color)

       Default: Kirigami.MessageType.Information if statusMessage is set,
       nothing otherwise.

       \sa Kirigami.MessageType
     */
    property var status: Kirigami.MessageType.Information

    /*!
       \brief This property holds the current status message of
       the text field.

       If this property is not set, no \l status will be shown.
     */
    property string statusMessage: ""

    /*!
       \brief A label containing secondary text that appears under the
       inherited text property.

       This provides additional information shown in a faint gray color.

       \default ""
       \since 1.12.0
     */
    property string description: ""

    /*!
       \brief This property holds the parent used for the popups
       of this control.
       \default ApplicationWindow.window
     */
    property var popupParent: QQC2.ApplicationWindow.window

    background: null

    focusPolicy: text.length > 0 ? Qt.TabFocus : Qt.NoFocus

    padding: 0
    topPadding: undefined
    leftPadding: undefined
    rightPadding: undefined
    bottomPadding: undefined
    verticalPadding: undefined
    horizontalPadding: undefined

    contentItem: ColumnLayout {
        id: contentColumn
        spacing: 0

        QQC2.Label {
            text: root.text
            Layout.fillWidth: true
            padding: Kirigami.Units.gridUnit
            bottomPadding: Kirigami.Units.largeSpacing
            topPadding: Kirigami.Units.largeSpacing
            visible: root.text.length > 0 && root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.DateTime
            Accessible.ignored: true
        }

        RowLayout {
            spacing: 0

            Layout.fillWidth: true
            Layout.minimumWidth: parent.width

            QQC2.AbstractButton {
                id: dateButton

                property bool androidPickerActive: false

                horizontalPadding: Private.FormCardUnits.horizontalPadding
                verticalPadding: Private.FormCardUnits.verticalPadding

                Layout.fillWidth: true
                Layout.maximumWidth: root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.DateTime ? contentColumn.width / 2 : contentColumn.width

                visible: root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.DateTime || root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.Date

                text: if (!isNaN(root.value.valueOf())) {
                    if (root.dateTime.isToday) {
                        return i18ndc("kirigami-addons6", "Displayed in place of the date if the selected day is today", "Today");
                    }
                    const locale = Qt.locale();
                    const weekDay = root.value.toLocaleDateString(locale, "ddd, ");
                    if (root.dateTime.isCurrentYear) {
                        return weekDay + root.value.toLocaleDateString(locale, Locale.ShortFormat);
                    }

                    return weekDay + root.dateTime.shortDate;
                } else {
                    i18ndc("kirigami-addons6", "Date is not set", "Not set")
                }

                contentItem: RowLayout {
                    spacing: 0

                    Kirigami.Icon {
                        source: "view-calendar-symbolic"
                        Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                        Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
                        Layout.rightMargin: Private.FormCardUnits.horizontalSpacing
                    }

                    QQC2.Label {
                        id: dateLabel

                        text: root.text
                        visible: root.text.length > 0 && root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.Date

                        Layout.fillWidth: true
                        Accessible.ignored: true
                    }

                    QQC2.Label {
                        text: dateButton.text

                        Layout.fillWidth: !dateLabel.visible
                        Accessible.ignored: true
                    }
                }
                onClicked: {
                    if (root.readOnly) {
                        return;
                    }

                    if (!root.dateTime.isValid) {
                        root.dateTime = root.initialDateTime;
                    }

                    if (Qt.platform.os === 'android') {
                        androidPickerActive = true;
                        DateTime.AndroidIntegration.showDatePicker(root.dateTime.dateTime.getTime());
                    } else {
                        const item = datePopup.createObject(root.popupParent, {
                            dateTime: root.dateTime,
                            minimumDateTime: root.minimumDateTime,
                            maximumDateTime: root.maximumDateTime,
                        });

                        item.accepted.connect(() => {
                            if (!root.dateTime.isValid) {
                                root.dateTime = root.initialDateTime;
                            }
                            // Set the components individually to preserve the time and timezone.
                            root.dateTime.year = item.dateTime.year;
                            root.dateTime.month = item.dateTime.month;
                            root.dateTime.day = item.dateTime.day;
                        });

                        item.open();
                    }
                }

                background: FormDelegateBackground {
                    visible: !root.readOnly
                    control: dateButton
                }

                Component {
                    id: datePopup
                    DateTime.DatePopup {
                        x: parent ? Math.round((parent.width - width) / 2) : 0
                        y: parent ? Math.round((parent.height - height) / 2) : 0

                        width: Math.min(Kirigami.Units.gridUnit * 20, root.popupParent.width - 2 * Kirigami.Units.gridUnit)

                        height: Kirigami.Units.gridUnit * 20

                        modal: true

                        onClosed: destroy();
                    }
                }

                Connections {
                    enabled: Qt.platform.os === 'android' && dateButton.androidPickerActive
                    ignoreUnknownSignals: !enabled
                    target: enabled ? DateTime.AndroidIntegration : null
                    function onDatePickerFinished(accepted, newDate) {
                        dateButton.androidPickerActive = false;
                        if (accepted) {
                            if (!root.dateTime.isValid) {
                                root.dateTime.dateTime = root.initialDateTime.dateTime;
                            }
                            root.dateTime.year = newDate.year;
                            root.dateTime.month = newDate.month;
                            root.dateTime.day = newDate.day;
                        }
                    }
                }
            }

            Kirigami.Separator {
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                Layout.topMargin: Kirigami.Units.smallSpacing
                Layout.bottomMargin: Kirigami.Units.smallSpacing
                opacity: dateButton.hovered || timeButton.hovered || !timeButton.visible || !dateButton.visible ? 0 : 0.5
            }

            QQC2.AbstractButton {
                id: timeButton

                property bool androidPickerActive: false

                visible: root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.DateTime || root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.Time

                horizontalPadding: Private.FormCardUnits.horizontalPadding
                verticalPadding: Private.FormCardUnits.verticalPadding

                Layout.fillWidth: true
                Layout.maximumWidth: root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.DateTime ? contentColumn.width / 2 : contentColumn.width

                text: if (!isNaN(root.value.valueOf())) {
                    const locale = Qt.locale();
                    const timeFormat = locale.timeFormat(Locale.ShortFormat)
                        .replace(':ss', '');
                    return root.value.toLocaleTimeString(locale, timeFormat);
                } else {
                    return i18ndc("kirigami-addons6", "Date is not set", "Not set");
                }

                onClicked: {
                    if (root.readOnly) {
                        return;
                    }

                    if (!root.dateTime.isValid) {
                        root.dateTime = root.initialDateTime;
                    }

                    if (Qt.platform.os === 'android') {
                        androidPickerActive = true;
                        DateTime.AndroidIntegration.showTimePicker(root.dateTime.dateTime.getTime());
                    } else {
                        const popup = timePopup.createObject(root.popupParent, {
                            dateTime: root.dateTime,
                        })
                        popup.open();
                    }
                }

                Component {
                    id: timePopup
                    DateTime.TimePopup {
                        id: popup

                        x: parent ? Math.round((parent.width - width) / 2) : 0
                        y: parent ? Math.round((parent.height - height) / 2) : 0

                        onClosed: popup.destroy();

                        parent: root.popupParent.overlay
                        modal: true

                        onAccepted: {
                            if (!root.dateTime.isValid) {
                                root.dateTime = root.initialDateTime;
                            }
                            root.dateTime.hour = popup.dateTime.hour;
                            root.dateTime.minute = popup.dateTime.minute;
                        }
                    }
                }

                Connections {
                    enabled: Qt.platform.os === 'android' && timeButton.androidPickerActive
                    ignoreUnknownSignals: !enabled
                    target: enabled ? DateTime.AndroidIntegration : null
                    function onTimePickerFinished(accepted, newDate) {
                        timeButton.androidPickerActive = false;
                        if (accepted) {
                            if (!root.dateTime.isValid) {
                                root.dateTime.dateTime = root.initialDateTime.dateTime;
                            }
                            root.dateTime.hour = newDate.hour;
                            root.dateTime.minute = newDate.minute;
                        }
                    }
                }

                contentItem: RowLayout {
                    spacing: 0

                    Kirigami.Icon {
                        source: "clock-symbolic"

                        Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                        Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
                        Layout.rightMargin: Private.FormCardUnits.horizontalSpacing
                    }

                    QQC2.Label {
                        id: timeLabel
                        text: root.text
                        visible: root.text.length > 0 && root.dateTimeDisplay === FormDateTimeDelegate.DateTimeDisplay.Time

                        Layout.fillWidth: true
                        Accessible.ignored: true
                    }

                    QQC2.Label {
                        text: timeButton.text
                        Layout.fillWidth: !timeLabel.visible
                        Accessible.ignored: true
                    }
                }

                background: FormDelegateBackground {
                    control: timeButton
                    visible: !root.readOnly
                }
            }
        }

        Kirigami.InlineMessage {
            id: formErrorHandler
            visible: root.statusMessage.length > 0
            Layout.topMargin: visible ? Kirigami.Units.smallSpacing : 0
            Layout.bottomMargin: visible ? Kirigami.Units.smallSpacing : 0
            Layout.leftMargin: Kirigami.Units.gridUnit
            Layout.rightMargin: Kirigami.Units.gridUnit
            Layout.fillWidth: true
            text: root.statusMessage
            type: root.status
        }

        QQC2.Label {
            id: internalDescriptionItem

            Layout.fillWidth: true
            Layout.topMargin: visible ? Kirigami.Units.smallSpacing : 0
            Layout.bottomMargin: visible ? Kirigami.Units.smallSpacing : 0
            Layout.leftMargin: Kirigami.Units.gridUnit
            Layout.rightMargin: Kirigami.Units.gridUnit
            text: root.description
            color: Kirigami.Theme.disabledTextColor
            visible: root.description !== ""
            wrapMode: Text.Wrap
        }
    }
}
