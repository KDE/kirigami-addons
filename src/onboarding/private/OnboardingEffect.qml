// SPDX-FileCopyrightText: 2026 Sandro Andrade <sandroandrade@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Effects
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.onboarding

Item {
    id: root

    required property Item sourceItem

    Kirigami.Theme.colorSet: Kirigami.Theme.Window
    Kirigami.Theme.inherit: false

    height: sourceItem.height
    visible: Onboarding.active && Onboarding.source === sourceItem
    width: sourceItem.width
    x: parent === sourceItem ? 0 : sourceItem.x
    y: parent === sourceItem ? 0 : sourceItem.y
    z: parent === sourceItem ? 0 : sourceItem.z + 0.5

    Rectangle {
        id: mask

        anchors.fill: parent
        color: "transparent"
        layer.enabled: true

        Rectangle {
            color: Kirigami.Theme.backgroundColor
            height: Onboarding.y
            width: parent.width
        }

        Rectangle {
            color: Kirigami.Theme.backgroundColor
            height: parent.height - y
            width: parent.width
            y: Onboarding.y + Onboarding.height
        }

        Rectangle {
            color: Kirigami.Theme.backgroundColor
            height: parent.height
            width: Onboarding.x
        }

        Rectangle {
            color: Kirigami.Theme.backgroundColor
            height: parent.height
            width: parent.width - x
            x: Onboarding.x + Onboarding.width
        }
    }

    MultiEffect {
        id: blurEffect

        anchors.fill: parent
        autoPaddingEnabled: false
        blur: 0.55
        blurEnabled: true
        blurMax: 64
        maskEnabled: true
        maskSource: mask
        source: sourceItem
    }
}
