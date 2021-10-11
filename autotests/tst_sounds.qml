/*
 * SPDX-FileCopyrightText: 2021 Han Young <hanyoung@protonmail.com>
 * SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
 *
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.0
import QtTest 1.2
import org.kde.kirigamiaddons.sounds 0.1
import QtMultimedia 5.15

SoundsPicker {
    id: soundsPicker
    theme: 'freedesktop'
    width: 50
    height: 50

    TestCase {
        name: "SoundsTest"
        when: windowShown

        function test_hasSounds() {
            compare(soundsPicker.model.rowCount() > 0, true);
        }

        function test_click() {
            mouseClick(soundsPicker, 5, 5);
            compare(soundsPicker.audioPlayer.playbackState, MediaPlayer.PlayingState)
            mouseClick(soundsPicker, 5, 5);
            compare(soundsPicker.audioPlayer.playbackState, MediaPlayer.PausedState)
        }
    }
}
