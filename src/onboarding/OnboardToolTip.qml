// SPDX-FileCopyrightText: 2026 Sandro Andrade <sandroandrade@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kirigami.platform as Platform

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

    Platform.Theme.colorSet: Platform.Theme.Tooltip
    Platform.Theme.inherit: false

    closePolicy: QQC2.Popup.NoAutoClose
    delay: 0
    horizontalPadding: Kirigami.Units.largeSpacing
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding)
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    margins: Kirigami.Units.largeSpacing
    padding: Kirigami.Units.smallSpacing
    verticalPadding: Kirigami.Units.smallSpacing
    timeout: -1
    x: parent ? (parent.width - width) / 2 : 0
    y: -height - Kirigami.Units.largeSpacing

    background: Rectangle {
        objectName: "onboardingToolTipBackground"

        color: root.Platform.Theme.backgroundColor
        implicitHeight: Kirigami.Units.gridUnit * 2
        radius: Kirigami.Units.cornerRadius

        border {
            color: Platform.ColorUtils.linearInterpolation(root.Platform.Theme.backgroundColor, root.Platform.Theme.textColor, root.Platform.Theme.frameContrast)
            width: 1
        }
    }
}
