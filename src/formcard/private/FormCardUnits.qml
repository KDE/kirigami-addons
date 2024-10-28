// Copyright 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma Singleton

import QtQml
import org.kde.kirigami as Kirigami

QtObject {
    readonly property int horizontalPadding: Kirigami.Units.largeSpacing + (Kirigami.Settings.isMobile ? Kirigami.Units.smallSpacing : 0)
    readonly property int verticalPadding: Kirigami.Units.largeSpacing + (Kirigami.Settings.isMobile ? Kirigami.Units.smallSpacing : 0)

    readonly property int verticalSpacing: Kirigami.Settings.isMobile ? Kirigami.Units.smallSpacing : 0
    readonly property int horizontalSpacing: Kirigami.Settings.isMobile ? Kirigami.Units.largeSpacing : Kirigami.Units.smallSpacing
}
