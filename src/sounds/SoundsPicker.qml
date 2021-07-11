/*
 *   SPDX-FileCopyrightText: 2021 Han Young <hanyoung@protonmail.com>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.12
import QtQuick.Controls 2.5 as Controls2
import org.kde.kirigami 2.0 as Kirigami
import QtQuick.Layouts 1.11
import org.kde.kirigamiaddons.sounds 0.1
/**
 * A SoundPicker for picking ringtone and notification
 */
Item {
    id: root
    /**
     * This property holds the selected audio url.
    */
    property string selectedUrl: soundsModel.initialSourceUrl(listView.currentIndex)
    SoundsModel {
        id: soundsModel
    }
    ListView {
        id: listView
        anchors.fill: parent
        model: soundsModel
        delegate: Kirigami.BasicListItem {
            text: ringtoneName
            bold: true
            icon: ListView.isCurrentItem ? "object-select-symbolic" : ""
            onClicked: selectedUrl = sourceUrl
        }
    }
}
