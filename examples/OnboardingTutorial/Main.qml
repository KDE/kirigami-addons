// SPDX-FileCopyrightText: 2026 Sandro Andrade <sandroandrade@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigami.platform as Platform
import org.kde.kirigamiaddons.onboarding

Kirigami.ApplicationWindow {
    id: root

    height: 480
    title: qsTr("Kirigami Addons Onboarding Tutorial")
    visible: true
    width: 640

    Onboarding.onFinished: swipeView.currentIndex = 0

    //! [0]
    Shortcut {
        context: Qt.ApplicationShortcut
        sequence: "F1"

        onActivated: Onboarding.start()
    }
    //! [0]

    Shortcut {
        context: Qt.ApplicationShortcut
        sequence: "F2"

        onActivated: Onboarding.start("advanced")
    }

    Component {
        id: onboardingAdditionalData

        //! [3]
        ColumnLayout {
            readonly property var additionalData: Onboarding.currentItem?.additionalData ?? ({})

            Platform.Theme.colorSet: Platform.Theme.Tooltip
            Platform.Theme.inherit: false

            implicitWidth: Math.max(video.Layout.preferredWidth, videoCaption.implicitWidth)
            spacing: 0
            visible: video.source.toString().length > 0

            AnimatedImage {
                id: video

                Layout.alignment: Qt.AlignHCenter
                Layout.maximumHeight: Kirigami.Units.gridUnit * 7
                Layout.maximumWidth: Kirigami.Units.gridUnit * 14
                Layout.preferredHeight: implicitWidth > 0 ? Math.min(Layout.preferredWidth * implicitHeight / implicitWidth, Layout.maximumHeight) : 0
                Layout.preferredWidth: implicitHeight > 0 && implicitWidth > 0 ? Math.min(implicitWidth, Layout.maximumWidth, Layout.maximumHeight * implicitWidth / implicitHeight) : 0
                fillMode: Image.PreserveAspectFit
                sourceSize.width: Layout.maximumWidth
                source: parent.additionalData.video ?? ""
            }

            QQC2.Label {
                id: videoCaption

                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: Math.min(implicitWidth, video.Layout.preferredWidth)
                color: Platform.Theme.textColor
                horizontalAlignment: Text.AlignHCenter
                text: parent.additionalData.videoCaption ?? ""
                visible: text.length > 0
                wrapMode: Text.WordWrap
            }
        }
        //! [3]
    }

    Binding {
        target: Onboarding
        property: "additionalDataComponent"
        value: onboardingAdditionalData
    }

    //! [5]
    Item {
        id: pageHost

        anchors.fill: parent
        Onboarding.isSource: true
        Onboarding.sourceGroups: ["", "advanced"]

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            QQC2.SwipeView {
                id: swipeView

                Layout.fillHeight: true
                Layout.fillWidth: true
                interactive: !Onboarding.active

                Page1 {
                    swipeView: swipeView
                }

                Page2 {
                    swipeView: swipeView
                }

                Page3 {
                    swipeView: swipeView
                }
            }

            QQC2.PageIndicator {
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: Kirigami.Units.largeSpacing
                count: swipeView.count
                currentIndex: swipeView.currentIndex
            }
        }
    }
    //! [5]
}
