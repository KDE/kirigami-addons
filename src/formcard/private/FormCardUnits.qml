// Copyright 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma Singleton

import QtQml
import org.kde.kirigami as Kirigami

QtObject {
    readonly property int horizontalPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    readonly property int verticalPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing

    readonly property int verticalSpacing: Kirigami.Units.smallSpacing
    readonly property int horizontalSpacing: Kirigami.Units.largeSpacing
}
