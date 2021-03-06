// SPDX-FileCopyrightText: 2019 David Edmundson <davidedmundson@kde.org>
// SPDX-FileCopyrightText: 2021 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.3
import QtQuick.Window 2.15
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.3 as Controls
import org.kde.kirigami 2.8 as Kirigami

Controls.TextField { //inherited for style reasons to show we're interactive
    id: root
    property date selectedDate
    readOnly: true
    text: selectedDate.toLocaleDateString(Qt.locale(), Locale.ShortFormat)
    MouseArea {
        anchors.fill: parent
        onClicked: {
            popupLoader.active = true
            popupLoader.item.year = root.selectedDate.getFullYear()
            popupLoader.item.month = root.selectedDate.getMonth() + 1
            popupLoader.item.selectedDate = root.selectedDate

            popupLoader.item.open();
        }

    }

    Loader {
        id: popupLoader
        active: false

        sourceComponent: Component {
            DatePopup {
                onAccepted: {
                    root.selectedDate = item.selectedDate
                    active = false
                }
                onCancelled: {
                    active = false
                }
            }
        }
    }
}
