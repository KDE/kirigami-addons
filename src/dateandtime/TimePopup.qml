// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.dateandtime
import org.kde.kirigamiaddons.components as Components

/*!
   \qmltype TimePopup
   \inqmlmodule org.kde.kirigamiaddons.dateandtime
   \brief A popup that prompts the user to select a time.
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
       \brief The current time selected by the user.

       Only the hour and minute components are meaningful; the date is not used.
     */
    property DateTime dateTime: DateTimeFactory.now()

    /*!
       \brief Emitted when the user cancels the popup.
     */
    signal cancelled()

    property bool _syncingValue: false

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

    // Holds the time as the user scrubs the tumblers, committed to dateTime
    // only when "Select" is clicked so that "Cancel" leaves dateTime untouched.
    property DateTime _pendingDateTime: DateTimeFactory.now()

    modal: true

    contentItem: TimePicker {
        id: popupContent
        implicitWidth: applicationWindow().width
        minutes: root.dateTime.minute
        hours: root.dateTime.hour
        onMinutesChanged: {
            root._pendingDateTime.hour = hours;
            root._pendingDateTime.minute = minutes;
        }
        onHoursChanged: {
            root._pendingDateTime.hour = hours;
            root._pendingDateTime.minute = minutes;
        }
    }

    background: Components.DialogRoundedBackground {}

    footer: QQC2.DialogButtonBox {
        id: box

        QQC2.Button {
            objectName: "cancelButton"
            text: i18ndc("kirigami-addons6", "@action:button", "Cancel")
            icon.name: "dialog-cancel-symbolic"
            onClicked: {
                root.cancelled()
                root.close()
            }

            QQC2.DialogButtonBox.buttonRole: QQC2.DialogButtonBox.RejectRole
        }

        QQC2.Button {
            objectName: "selectButton"
            text: i18ndc("kirigami-addons6", "@action:button", "Select")
            icon.name: "dialog-ok-apply-symbolic"
            onClicked: {
                root.dateTime.hour = root._pendingDateTime.hour;
                root.dateTime.minute = root._pendingDateTime.minute;
                root.accepted()
                root.close()
            }

            QQC2.DialogButtonBox.buttonRole: QQC2.DialogButtonBox.AcceptRole
        }
    }

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
