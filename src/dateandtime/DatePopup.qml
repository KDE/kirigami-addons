// SPDX-FileCopyrightText: 2019 David Edmundson <davidedmundson@kde.org>
// SPDX-FileCopyrightText: 2021 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.dateandtime
import org.kde.kirigamiaddons.components as Components
import './private/' as P

/*!
   \qmltype DatePopup
   \inqmlmodule org.kde.kirigamiaddons.dateandtime
   \brief A popup that prompts the user to select a date.
 */
QQC2.Dialog {
    id: root

    /*!
       \deprecated[1.15.0]
       Use \l dateTime instead.
     */
    property date value: new Date()

    /*!
       \since 1.15.0
       \brief The current date and time selected by the user.
     */
    property DateTime dateTime: DateTimeFactory.now()

    /*!
       \brief Emitted when the user cancels the popup.
       \deprecated Use rejected instead.
     */
    signal cancelled()

    /*!
       \deprecated[1.15.0]
       Use \l minimumDateTime instead.
     */
    property date minimumDate

    /*!
       \since 1.15.0
       This property holds the minimum date and time (inclusive) that the user
       can select.

       By default, no limit is applied to the date selection.
     */
    property DateTime minimumDateTime

    /*!
       \deprecated[1.15.0]
       Use \l maximumDateTime instead.
     */
    property date maximumDate

    /*!
       \since 1.15.0
       This property holds the maximum date and time (inclusive) that the user
       can select.

       By default, no limit is applied to the date selection.
     */
    property DateTime maximumDateTime

    /*!
       This property holds whether the date popup will automatically select a date
       on selection or has a "Select" button.

       By default, this is false.
     */
    property bool autoAccept: false

    property bool _syncingValue: false
    property bool _syncingMinimum: false
    property bool _syncingMaximum: false

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

    padding: 0
    topPadding: undefined
    leftPadding: undefined
    rightPadding: undefined
    bottomPadding: undefined
    verticalPadding: undefined
    horizontalPadding: undefined

    header: null

    contentItem: P.DatePicker {
        id: datePicker
        selectedDate: root.dateTime
        minimumDate: root.minimumDateTime
        maximumDate: root.maximumDateTime
        focus: true

        onDatePicked: (pickedDate) => {
            if (autoAccept) {
                root.dateTime = pickedDate;
                root.accepted();
            }
        }
    }

    footer: QQC2.DialogButtonBox {
        id: box

        visible: !autoAccept

        leftPadding: Kirigami.Units.mediumSpacing
        rightPadding: Kirigami.Units.mediumSpacing
        bottomPadding: Kirigami.Units.mediumSpacing

        QQC2.Button {
            objectName: "cancelButton"
            text: i18ndc("kirigami-addons6", "@action:button", "Cancel")
            icon.name: "dialog-cancel-symbolic"
            onClicked: {
                root.cancelled()
                root.rejected()
                root.close()
            }

            QQC2.DialogButtonBox.buttonRole: QQC2.DialogButtonBox.RejectRole
        }

        QQC2.Button {
            objectName: "selectButton"
            text: i18ndc("kirigami-addons6", "@action:button", "Select")
            icon.name: "dialog-ok-apply-symbolic"

            onClicked: {
                root.dateTime = datePicker.selectedDate;
                root.accepted()
                root.close()
            }

            QQC2.DialogButtonBox.buttonRole: QQC2.DialogButtonBox.AcceptRole
        }
    }

    background: Components.DialogRoundedBackground {}

    // black background, fades in and out
    QQC2.Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.3)

        // the opacity of the item is changed internally by QQuickPopup on open/close
        Behavior on opacity {
            OpacityAnimator {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
    }
}
