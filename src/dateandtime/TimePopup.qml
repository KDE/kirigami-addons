// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as Components

/*!
   \qmltype TimePopup
   \inqmlmodule org.kde.kirigamiaddons.dateandtime
   \brief A dialog for selecting a time.

   Set \l value to the initial date and time. When the user clicks Select,
   the dialog updates \l value and emits \l accepted.
 */
QQC2.Dialog {
    id: root

    /*!
       The date and time selected by the user. The time is updated when the
       user clicks Select.
     */
    property date value: new Date()

    /*!
       Emitted when the user clicks Cancel.
     */
    signal cancelled()

    property date _value: new Date()

    modal: true

    contentItem: TimePicker {
        id: popupContent
        implicitWidth: applicationWindow().width
        minutes: root.value.getMinutes()
        hours: root.value.getHours()
        onMinutesChanged: {
            root._value.setHours(hours, minutes);
        }
        onHoursChanged: {
            root._value.setHours(hours, minutes);
        }
    }

    background: Components.DialogRoundedBackground {}

    footer: QQC2.DialogButtonBox {
        id: box

        QQC2.Button {
            text: i18ndc("kirigami-addons6", "@action:button", "Cancel")
            icon.name: "dialog-cancel-symbolic"
            onClicked: {
                root.cancelled()
                root.close()
            }

            QQC2.DialogButtonBox.buttonRole: QQC2.DialogButtonBox.RejectRole
        }

        QQC2.Button {
            text: i18ndc("kirigami-addons6", "@action:button", "Select")
            icon.name: "dialog-ok-apply-symbolic"
            onClicked: {
                root.value = root._value;
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
