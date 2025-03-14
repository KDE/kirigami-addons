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

/*!
   \qmltype SoundsPicker
   \inqmlmodule org.kde.kirigamiaddons.sounds
   \brief A sound picker component for picking ringtones and notifications.
 */
ListView {
    id: listView

    /*!
       This property holds the selected audio url.
     */
    property string selectedUrl: soundsModel.initialSourceUrl(listView.currentIndex)

    /*!
       This property controls the sound type (ringtone or notification).
       \default true
     */
    property bool notification: true

    /*!
       \qmlproperty string theme
       This property lets you choose the sound theme.
       \default "plasma-mobile"
     */
    property alias theme: soundsModel.theme

    /*!
       \qmlproperty MediaPlayer audioPlayer
       This property is the internal Audio qml type used for play sound.
       \sa {QtMultimedia::MediaPlayer} {QtMultimedia.MediaPlayer}
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
