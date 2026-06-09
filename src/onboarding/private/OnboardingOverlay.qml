// SPDX-FileCopyrightText: 2026 Sandro Andrade <sandroandrade@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.onboarding

Item {
    id: root

    required property Item sourceItem

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

                    spacing: Kirigami.Units.smallSpacing
                    readonly property bool hasVisibleAdditionalData: additionalDataLoader.status === Loader.Ready && additionalDataLoader.item && additionalDataLoader.item.visible

                    QQC2.Label {
                        Layout.fillWidth: true
                        Layout.maximumWidth: Kirigami.Units.gridUnit * 14
                        color: Kirigami.Theme.highlightedTextColor
                        text: Onboarding.currentText
                        wrapMode: Text.WordWrap
                    }

                    QQC2.MenuSeparator {
                        Layout.bottomMargin: -parent.spacing / 2
                        Layout.fillWidth: true
                        Layout.topMargin: -parent.spacing / 2
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

                    QQC2.MenuSeparator {
                        Layout.bottomMargin: -parent.spacing / 2
                        Layout.fillWidth: true
                        Layout.topMargin: -parent.spacing / 2
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Kirigami.Units.smallSpacing

                        QQC2.ToolButton {
                            Layout.preferredHeight: implicitHeight
                            Layout.preferredWidth: implicitWidth
                            visible: Onboarding.hasPreviousItem

                            Accessible.name: i18nc("@action:button", "Previous")
                            QQC2.ToolTip.text: i18nc("@info:tooltip", "Previous")
                            QQC2.ToolTip.visible: hovered
                            icon.color: Kirigami.Theme.highlightedTextColor
                            icon.name: Qt.application.layoutDirection === Qt.RightToLeft ? "go-next-symbolic" : "go-previous-symbolic"

                            onClicked: Onboarding.previous()
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        QQC2.ToolButton {
                            Layout.preferredHeight: implicitHeight
                            Layout.preferredWidth: implicitWidth
                            visible: Onboarding.hasNextItem

                            Accessible.name: i18nc("@action:button", "Next")
                            QQC2.ToolTip.text: i18nc("@info:tooltip", "Next")
                            QQC2.ToolTip.visible: hovered
                            icon.color: Kirigami.Theme.highlightedTextColor
                            icon.name: Qt.application.layoutDirection === Qt.RightToLeft ? "go-previous-symbolic" : "go-next-symbolic"

                            onClicked: Onboarding.next()
                        }

                        QQC2.ToolButton {
                            Layout.preferredHeight: implicitHeight
                            Layout.preferredWidth: implicitWidth

                            Accessible.name: i18nc("@action:button", "Cancel")
                            QQC2.ToolTip.text: i18nc("@info:tooltip", "Cancel")
                            QQC2.ToolTip.visible: hovered
                            icon.color: Kirigami.Theme.highlightedTextColor
                            icon.name: "dialog-cancel-symbolic"

                            onClicked: Onboarding.stop()
                        }
                    }
                }
            }
            modal: true
            visible: parent.visible
        }
    }
}
