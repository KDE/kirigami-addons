/*
 *   SPDX-FileCopyrightText: 2019 David Edmundson <davidedmundson@kde.org>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.3
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.3 as Controls

Controls.TextField { //inherited for style reasons to show we're interactive
    id: root
    property date selectedDate
    readOnly: true
    text: selectedDate.toLocaleDateString(Qt.locale(), Locale.ShortFormat)
    MouseArea {
        anchors.fill: parent
        onClicked: popup.open();

    }
    Controls.Popup {
        id: popup
        y: root.height
        DatePicker {
            selectedDate: root.selectedDate
            onSelectedDateChanged: root.selectedDate = selectedDate
        }
    }
}
