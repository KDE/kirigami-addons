// SPDX-FileCopyrightText: 2026 Sandro Andrade <sandroandrade@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigami.platform as Platform
import org.kde.kirigamiaddons.onboarding

Item {
    id: root

    required property Item sourceItem

    objectName: "onboardingOverlay"

    height: sourceItem.height
    visible: Onboarding.active
    width: sourceItem.width
    x: parent === sourceItem ? 0 : sourceItem.x
    y: parent === sourceItem ? 0 : sourceItem.y
    z: parent === sourceItem ? 1 : sourceItem.z + 1

    focus: visible

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Left) {
            if (Onboarding.hasPreviousItem) {
                Onboarding.previous();
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_Right) {
            if (Onboarding.hasNextItem) {
                Onboarding.next();
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_Escape) {
            Onboarding.stop();
            event.accepted = true;
        }
    }

    onVisibleChanged: {
        if (visible) {
            forceActiveFocus();
        }
    }

    Rectangle {
        id: highlight

        border.color: Kirigami.Theme.highlightColor
        border.width: 2
        color: "transparent"
        height: Onboarding.height
        visible: Onboarding.currentItem !== null
        width: Onboarding.width
        x: Onboarding.x
        y: Onboarding.y

        Behavior on height {
            enabled: Onboarding.active

            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }

        Behavior on width {
            enabled: Onboarding.active

            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }

        Behavior on x {
            enabled: Onboarding.active

            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }

        Behavior on y {
            enabled: Onboarding.active

            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }

        OnboardToolTip {
            id: toolTip

            readonly property real availableLeft: -highlight.x + margins
            readonly property real availableTop: -highlight.y + margins
            readonly property real availableRight: root.width - highlight.x - margins
            readonly property real availableBottom: root.height - highlight.y - margins
            readonly property real preferredX: (highlight.width - width) / 2
            readonly property real preferredYAbove: -height - Kirigami.Units.largeSpacing
            readonly property real preferredYBelow: highlight.height + Kirigami.Units.largeSpacing
            readonly property bool fitsAbove: preferredYAbove >= availableTop
            readonly property bool fitsBelow: preferredYBelow + height <= availableBottom

            objectName: "onboardingToolTip"
            contentItem: Item {
                implicitWidth: contentLayout.implicitWidth
                implicitHeight: contentLayout.implicitHeight
                focus: true

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Left) {
                        if (Onboarding.hasPreviousItem) {
                            Onboarding.previous();
                        }
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Right) {
                        if (Onboarding.hasNextItem) {
                            Onboarding.next();
                        }
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Escape) {
                        Onboarding.stop();
                        event.accepted = true;
                    }
                }

                onVisibleChanged: {
                    if (visible) {
                        forceActiveFocus();
                    }
                }

                ColumnLayout {
                    id: contentLayout

                    anchors.fill: parent
                    spacing: Kirigami.Units.smallSpacing
                    readonly property bool hasVisibleAdditionalData: additionalDataLoader.status === Loader.Ready && additionalDataLoader.item && additionalDataLoader.item.visible

                    QQC2.Label {
                        objectName: "onboardingToolTipLabel"

                        Layout.fillWidth: true
                        Layout.maximumWidth: Kirigami.Units.gridUnit * 14
                        color: toolTip.Platform.Theme.textColor
                        text: Onboarding.currentText
                        wrapMode: Text.WordWrap
                    }

                    Rectangle {
                        objectName: "onboardingAdditionalDataSeparator"

                        Layout.bottomMargin: -parent.spacing / 2
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.topMargin: -parent.spacing / 2
                        color: Platform.ColorUtils.linearInterpolation(toolTip.Platform.Theme.backgroundColor, toolTip.Platform.Theme.textColor, toolTip.Platform.Theme.frameContrast)
                        visible: parent.hasVisibleAdditionalData
                    }

                    Loader {
                        id: additionalDataLoader

                        Layout.fillWidth: true
                        Layout.maximumWidth: Kirigami.Units.gridUnit * 14
                        Layout.preferredHeight: parent.hasVisibleAdditionalData && item ? Math.min(item.implicitHeight, Kirigami.Units.gridUnit * 10) : 0
                        Layout.alignment: Qt.AlignHCenter
                        active: Onboarding.additionalDataComponent !== null
                        sourceComponent: Onboarding.additionalDataComponent
                        visible: active
                    }

                    Rectangle {
                        objectName: "onboardingNavigationSeparator"

                        Layout.bottomMargin: -parent.spacing / 2
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.topMargin: -parent.spacing / 2
                        color: Platform.ColorUtils.linearInterpolation(toolTip.Platform.Theme.backgroundColor, toolTip.Platform.Theme.textColor, toolTip.Platform.Theme.frameContrast)
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Kirigami.Units.smallSpacing

                        QQC2.ToolButton {
                            objectName: "onboardingPreviousButton"

                            Layout.preferredHeight: implicitHeight
                            Layout.preferredWidth: implicitWidth
                            visible: Onboarding.hasPreviousItem

                            Accessible.name: i18nc("@action:button", "Previous")
                            QQC2.ToolTip.text: i18nc("@info:tooltip", "Previous")
                            QQC2.ToolTip.visible: hovered
                            icon.color: toolTip.Platform.Theme.textColor
                            icon.name: Qt.application.layoutDirection === Qt.RightToLeft ? "go-next-symbolic" : "go-previous-symbolic"

                            onClicked: Onboarding.previous()
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        QQC2.ToolButton {
                            objectName: "onboardingNextButton"

                            Layout.preferredHeight: implicitHeight
                            Layout.preferredWidth: implicitWidth
                            visible: Onboarding.hasNextItem

                            Accessible.name: i18nc("@action:button", "Next")
                            QQC2.ToolTip.text: i18nc("@info:tooltip", "Next")
                            QQC2.ToolTip.visible: hovered
                            icon.color: toolTip.Platform.Theme.textColor
                            icon.name: Qt.application.layoutDirection === Qt.RightToLeft ? "go-previous-symbolic" : "go-next-symbolic"

                            onClicked: Onboarding.next()
                        }

                        QQC2.ToolButton {
                            objectName: "onboardingCancelButton"

                            Layout.preferredHeight: implicitHeight
                            Layout.preferredWidth: implicitWidth

                            Accessible.name: i18nc("@action:button", "Cancel")
                            QQC2.ToolTip.text: i18nc("@info:tooltip", "Cancel")
                            QQC2.ToolTip.visible: hovered
                            icon.color: toolTip.Platform.Theme.textColor
                            icon.name: "dialog-cancel-symbolic"

                            onClicked: Onboarding.stop()
                        }
                    }
                }
            }
            dim: false
            width: Math.min(implicitWidth, root.width - 2 * margins)
            x: Math.max(availableLeft, Math.min(preferredX, availableRight - width))
            y: {
                if (fitsAbove) {
                    return preferredYAbove;
                }
                if (fitsBelow) {
                    return preferredYBelow;
                }
                return Math.max(availableTop, Math.min(preferredYAbove, availableBottom - height));
            }
            modal: true
            visible: parent.visible
        }
    }
}
