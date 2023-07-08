// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2

import org.kde.kirigami 2.15 as Kirigami

/**
 * @brief An action for with bindings for managing the download of a piece of media.
 *
 * The action provides properties to help track progress but is up to the action
 * representation to respond to them. The onTriggered() signal should be used to
 * perform the download action itself.
 *
 * The most common use case for this is where a custom URI scheme is used that a
 * QML media component can't handle on it's own.
 */
Kirigami.Action {
    id: root

    /**
     * @brief The download progress between 0% and 100%.
     */
    property real progress: -1

    /**
     * @brief Whether the download has started.
     */
    readonly property bool started: progress > 0.0

    /**
     * @brief Whether the download has completed.
     */
    readonly property bool completed: progress >= 100.0

    text: i18n("Download")
    icon.name: "download"
}
