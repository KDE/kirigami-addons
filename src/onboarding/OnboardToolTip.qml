// SPDX-FileCopyrightText: 2026 Sandro Andrade <sandroandrade@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

/*!
    \qmltype OnboardToolTip
    \inqmlmodule org.kde.kirigamiaddons.onboarding
    \since 1.13
    \brief Tooltip style used by \l Onboarding walkthroughs.

    OnboardToolTip customizes visuals and geometry behavior for onboarding
    overlays.
*/
QQC2.ToolTip {
    id: root

    closePolicy: QQC2.Popup.NoAutoClose
    delay: 0
    horizontalPadding: Kirigami.Units.largeSpacing
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, contentHeight + topPadding + bottomPadding)
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, contentWidth + leftPadding + rightPadding)
    margins: Kirigami.Units.largeSpacing
    padding: Kirigami.Units.smallSpacing
    verticalPadding: Kirigami.Units.smallSpacing
    timeout: -1
    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: -implicitHeight - Kirigami.Units.largeSpacing

    background: Rectangle {
        Kirigami.Theme.colorSet: Kirigami.Theme.Selection
        Kirigami.Theme.inherit: false

        color: Kirigami.Theme.backgroundColor
        implicitHeight: Kirigami.Units.gridUnit * 2
        radius: Kirigami.Units.cornerRadius

        border {
            color: Kirigami.Theme.highlightedTextColor
            width: 1
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: Kirigami.Units.longDuration
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on width {
        NumberAnimation {
            duration: Kirigami.Units.longDuration
            easing.type: Easing.InOutQuad
        }
    }
}
