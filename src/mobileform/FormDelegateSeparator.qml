/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.4 as Kirigami

Kirigami.Separator {
    property var above
    property var below
    
    Layout.leftMargin: Kirigami.Units.largeSpacing
    Layout.rightMargin: Kirigami.Units.largeSpacing
    Layout.fillWidth: true
    
    opacity: (!above || !(above.enabled && ((above.hovered && !Kirigami.Settings.tabletMode) || above.pressed))) && 
             (!below || !(below.enabled && ((below.hovered && !Kirigami.Settings.tabletMode) || below.pressed))) ? 0.5 : 0
}
