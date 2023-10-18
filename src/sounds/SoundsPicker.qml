/*
 * SPDX-FileCopyrightText: 2021 Han Young <hanyoung@protonmail.com>
 * SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
 *
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as Controls2
import org.kde.kirigami as Kirigami
import QtQuick.Layouts
import QtMultimedia
import org.kde.kirigamiaddons.sounds
import org.kde.kirigamiaddons.delegates as Delegates

/**
 * A sound picker component for picking ringtones and notifications.
 * \inherits QtQuick.ListView
 */
ListView {
    id: listView

    /**
     * This property holds the selected audio url.
     */
    property string selectedUrl: soundsModel.initialSourceUrl(listView.currentIndex)

    /**
     * This property controls the sound type (ringtone or notification).
     * \property bool notification
     */
    property bool notification: true

    /**
     * This property lets you choose sound theme, default to "plasma-mobile"
     * \property string theme
     */
    property alias theme: soundsModel.theme

    /**
     * This property is the internal Audio qml type used for play sound
     * \property QtMultimedia.Audio playMusic
     */
    property alias audioPlayer: playMusic

    model: SoundsModel {
        id: soundsModel
        notification: listView.notification
        theme: 'freedesktop'
    }

    delegate: Delegates.RoundedItemDelegate {
        required property string ringtoneName
        required property url sourceUrl
        required property int index

        text: ringtoneName

        icon.name: ListView.isCurrentItem ? "object-select-symbolic" : ""
        onClicked: {
            selectedUrl = sourceUrl;
            if (playMusic.playbackState === MediaPlayer.PlayingState) {
                playMusic.pause();
            } else {
                playMusic.play();
            }
        }
    }

    MediaPlayer {
        id: playMusic
        source: selectedUrl
        audioOutput: AudioOutput {}
    }
}
