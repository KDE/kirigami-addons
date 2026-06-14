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
    \brief Persistent tooltip styled for onboarding walkthroughs.

    OnboardToolTip is the tooltip used by the default \l Onboarding overlay. It
    applies the platform tooltip color set, stays open until its owner hides
    it, sizes itself to its content, and uses Kirigami spacing and corner
    radius metrics.

    The type inherits the standard ToolTip API and can be used when custom
    onboarding visuals need the same appearance and persistent popup behavior
    as the built-in overlay.
*/
QQC2.ToolTip {
    id: root

    Platform.Theme.colorSet: Platform.Theme.Tooltip
    Platform.Theme.inherit: false

    closePolicy: QQC2.Popup.NoAutoClose
    contentHeight: contentItem?.implicitHeight ?? 0
    contentWidth: contentItem?.implicitWidth ?? 0
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
