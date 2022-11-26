/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.12 as Kirigami

/**
 * Base item for delegates in a form card.
 * 
 * By default, it includes a background with hover and click feedback.
 * Set the `background` property to Item {} to remove it.
 */
T.ItemDelegate {
    id: root

    leftPadding: Kirigami.Units.gridUnit
    topPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    bottomPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    rightPadding: Kirigami.Units.gridUnit

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    hoverEnabled: true
    background: FormDelegateBackground { control: root }
    
    Layout.fillWidth: true
}

