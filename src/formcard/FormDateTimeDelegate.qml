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
       This property holds the minimum date (inclusive) that the user can select.

       By default, no limit is applied to the date selection.
     */
    property date minimumDate

    /*!
       This property holds the maximum date (inclusive) that the user can select.

       By default, no limit is applied to the date selection.
     */
    property date maximumDate

    /*!
       This property holds the the date to use as initial default when editing an
       an unset date.

       By default, this is the current date/time.
     */
    property date initialValue: new Date()

    /*!
       This property holds whether this delegate is readOnly or whether the user
       can select a new time and date.
       \default false
     */
    property bool readOnly: false

    /*!
       \brief The current date and time selected by the user.
     */
    property date value: new Date()

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
                    const today = new Date();
                    if (root.value.getFullYear() === today.getFullYear()
                        && root.value.getDate() === today.getDate()
                        && root.value.getMonth() == today.getMonth()) {
                        return i18ndc("kirigami-addons6", "Displayed in place of the date if the selected day is today", "Today");
                    }
                    const locale = Qt.locale();
                    const weekDay = root.value.toLocaleDateString(locale, "ddd, ");
                    if (root.value.getFullYear() == today.getFullYear()) {
                        return weekDay + root.value.toLocaleDateString(locale, Locale.ShortFormat);
                    }

                    const escapeRegExp = (strToEscape) => {
                        // Escape special characters for use in a regular expression
                        return strToEscape.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
                    };

                    const trimChar = (origString, charToTrim) => {
                        charToTrim = escapeRegExp(charToTrim);
                        const regEx = new RegExp("^[" + charToTrim + "]+|[" + charToTrim + "]+$", "g");
                        return origString.replace(regEx, "");
                    };

                    let dateFormat = locale.dateFormat(Locale.ShortFormat)
                        .replace(root.value.getFullYear(), '')
                        .replace('yyyy', ''); // I'll be long dead when this will break and this won't be my problem anymore

                    dateFormat = trimChar(trimChar(trimChar(dateFormat, '-'), '.'), '/')

                    return weekDay + root.value.toLocaleDateString(locale, dateFormat);
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

                    let value = root.value;

                    if (isNaN(value.valueOf())) {
                        value = root.initialValue;
                    }

                    if (root.minimumDate) {
                        root.minimumDate.setHours(0, 0, 0, 0);
                    }
                    if (root.maximumDate) {
                        root.maximumDate.setHours(0, 0, 0, 0);
                    }

                    if (Qt.platform.os === 'android') {
                        androidPickerActive = true;
                        DateTime.AndroidIntegration.showDatePicker(value.getTime());
                    } else {
                        const item = datePopup.createObject(root.popupParent, {
                            value: value,
                            minimumDate: root.minimumDate,
                            maximumDate: root.maximumDate,
                        });

                        item.accepted.connect(() => {
                            if (isNaN(root.value.valueOf())) {
                                root.value = root.initialValue;
                            }
                            root.value.setFullYear(item.value.getFullYear());
                            root.value.setMonth(item.value.getMonth());
                            root.value.setDate(item.value.getDate());
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
                            if (isNaN(root.value.valueOf())) {
                                root.value = root.initialValue;
                            }
                            root.value.setFullYear(newDate.getFullYear());
                            root.value.setMonth(newDate.getMonth());
                            root.value.setDate(newDate.getDate());
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

                    let value = root.value;
                    if (isNaN(value.valueOf())) {
                        value = root.initialValue;
                    }

                    if (Qt.platform.os === 'android') {
                        androidPickerActive = true;
                        DateTime.AndroidIntegration.showTimePicker(value.getTime());
                    } else {
                        const popup = timePopup.createObject(root.popupParent, {
                            value: value,
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
                            if (isNaN(root.value.valueOf())) {
                                root.value = root.initialValue;
                            }
                            root.value.setHours(popup.value.getHours(), popup.value.getMinutes());
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
                            if (isNaN(root.value.valueOf())) {
                                root.value = root.initialValue;
                            }
                            root.value.setHours(newDate.getHours(), newDate.getMinutes());
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
    }
}
