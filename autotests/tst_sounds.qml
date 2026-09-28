/*
 * SPDX-FileCopyrightText: 2021 Han Young <hanyoung@protonmail.com>
 * SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
 *
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtTest
import org.kde.kirigamiaddons.sounds
import QtMultimedia

SoundsPicker {
    id: soundsPicker
    theme: 'freedesktop'
    width: 50
    height: 50

    MediaDevices {
        id: mediaDevices
    }

    TestCase {
        name: "SoundsTest"
        when: windowShown

        function test_hasSounds(): void {
            if (soundsPicker.model.rowCount() === 0) {
                skip("The freedesktop sound theme is not installed");
            }
            compare(soundsPicker.model.rowCount() > 0, true);
        }

        function test_click(): void {
            if (soundsPicker.model.rowCount() === 0) {
                skip("The freedesktop sound theme is not installed");
            }
            if (mediaDevices.audioOutputs.length === 0) {
                skip("No audio output device is available");
            }

            mouseClick(soundsPicker, 5, 5);
            tryCompare(soundsPicker.audioPlayer, "playbackState", MediaPlayer.PlayingState);
            mouseClick(soundsPicker, 5, 5);
            tryCompare(soundsPicker.audioPlayer, "playbackState", MediaPlayer.PausedState);
        }
    }
}
