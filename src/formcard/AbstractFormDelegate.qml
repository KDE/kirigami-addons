/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.12 as Kirigami

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

    horizontalPadding: Kirigami.Units.gridUnit
    verticalPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    focusPolicy: Qt.StrongFocus
    hoverEnabled: true
    background: FormDelegateBackground { control: root }

    Layout.fillWidth: true
}

