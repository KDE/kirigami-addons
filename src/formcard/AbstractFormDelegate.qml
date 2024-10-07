/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Templates as T
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

/**
 * @brief A base item for delegates to be used in a FormCard.
 *
 * This component can be used to create your own custom FormCard delegates.
 *
 * By default, it includes a background with hover and click feedback.
 * Set the `background` property to Item {} to remove it.
 *
 * @since KirigamiAddons 0.11.0
 *
 * @see FormDelegateBackground
 *
 * @inherit QtQuick.Controls.ItemDelegate
 */
T.ItemDelegate {
    id: root

    horizontalPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    verticalPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    focusPolicy: Qt.StrongFocus
    hoverEnabled: true
    background: FormDelegateBackground { control: root }

    icon {
        width: Kirigami.Units.iconSizes.smallMedium
        height: Kirigami.Units.iconSizes.smallMedium
    }

    Layout.fillWidth: true
}

