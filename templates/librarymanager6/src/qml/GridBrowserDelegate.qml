// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Window
import QtQml.Models
import QtQuick.Layouts
import QtQuick.Effects

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.delegates as Delegates
import org.kde.quickcharts as Charts

Delegates.RoundedItemDelegate {
    id: root

    required property url thumbnail
    required property string title
    required property string author
    required property string fallBackIconName
    required property int currentProgress

    text: title

    property color stateIndicatorColor: {
        if (root.activeFocus || root.pressed || root.hovered) {
            return Kirigami.Theme.highlightColor;
        } else {
            return "transparent";
        }
    }

    property real stateIndicatorOpacity: {
        if ((!Kirigami.Settings.isMobile && root.activeFocus) ||
            !Kirigami.Settings.isMobile || root.pressed || root.hovered) {
            return 0.3;
        } else {
            return 0;
        }
    }

    contentItem: ColumnLayout {
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: root.width - 2 * Kirigami.Units.largeSpacing

            Image {
                id: coverImage

                width: root.width - 2 * Kirigami.Units.largeSpacing
                height: root.width - 2 * Kirigami.Units.largeSpacing

                fillMode: Image.PreserveAspectFit
                source: root.thumbnail
                asynchronous: true

                sourceSize {
                    width: width
                    height: height
                }

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: Kirigami.Settings.isMobile ? 0 : Kirigami.Units.largeSpacing
                }
            }

            MultiEffect {
                source: coverImage
                enabled: !Kirigami.Settings.isMobile // don't use drop shadow on mobile

                shadowColor: Qt.rgba(0, 0, 0, 0.2)
                autoPaddingEnabled: true
                shadowBlur: 1.0
                shadowEnabled: true
                shadowVerticalOffset: 3
                shadowHorizontalOffset: 1

                anchors.fill: coverImage
            }

            Kirigami.Icon {
                id: fallBackIcon

                anchors {
                    fill: coverImage
                    margins: Kirigami.Settings.isMobile ? 0 : Kirigami.Units.largeSpacing
                }

                source: root.fallBackIconName
                visible: (coverImage.status === Image.Error || coverImage.status === Image.Loading ) && source !== undefined
            }

            Charts.PieChart {
                id: chart

                width: Kirigami.Units.gridUnit
                height: Kirigami.Units.gridUnit

                filled: true

                visible: root.currentProgress !== 0 && root.currentProgress !== 100 && root.fallBackIconName === '' && Config.showProgress

                anchors {
                    right: coverImage.right
                    top: coverImage.top
                }

                range {
                    from: 0
                    to: 100
                    automatic: false
                }

                valueSources: Charts.SingleValueSource {
                    value: root.currentProgress
                }

                colorSource: Charts.SingleValueSource {
                    value: Kirigami.Theme.highlightColor
                }
            }

            QQC2.Label {
                visible: root.currentProgress === 0 && root.fallBackIconName === ''

                text: i18nc("should be keep short, inside a label. Will be in uppercase", "New")
                color: "white"
                padding: 3

                background: Rectangle {
                    color: Kirigami.Theme.highlightColor
                    radius: height
                }

                anchors {
                    right: coverImage.right
                    top: coverImage.top
                }
            }
        }

        // labels
        RowLayout {
            id: labels

            Layout.fillWidth: true

            TextMetrics {
                id: mainLabelSize
                font: mainLabel.font
                text: mainLabel.text
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                spacing: 0

                Kirigami.Heading {
                    id: mainLabel
                    text: root.title

                    level: Kirigami.Settings.isMobile ? 6 : 4

                    // FIXME: Center-aligned text looks better overall, but
                    // sometimes results in font kerning issues
                    // See https://bugreports.qt.io/browse/QTBUG-49646
                    horizontalAlignment: Kirigami.Settings.isMobile ? Text.AlignLeft : Text.AlignHCenter

                    Layout.fillWidth: true
                    Layout.maximumHeight: mainLabelSize.boundingRect.height
                    Layout.alignment: Kirigami.Settings.isMobile ? Qt.AlignLeft : Qt.AlignVCenter
                    Layout.leftMargin: Kirigami.Settings.isMobile ? 0 : Kirigami.Units.largeSpacing
                    Layout.rightMargin: Kirigami.Settings.isMobile ? 0 : Kirigami.Units.largeSpacing

                    wrapMode: !Kirigami.Settings.isMobile && QQC2.Label.NoWrap
                    maximumLineCount: Kirigami.Settings.isMobile ? 1 : 2
                    elide: Text.ElideRight
                }

                QQC2.Label {
                    id: secondaryLabel

                    text: root.author
                    opacity: 0.6

                    // FIXME: Center-aligned text looks better overall, but
                    // sometimes results in font kerning issues
                    // See https://bugreports.qt.io/browse/QTBUG-49646
                    horizontalAlignment: Kirigami.Settings.isMobile ? Text.AlignLeft : Text.AlignHCenter

                    Layout.fillWidth: true
                    Layout.alignment: Kirigami.Settings.isMobile ? Qt.AlignLeft : Qt.AlignVCenter
                    Layout.topMargin: Kirigami.Settings.isMobile ? Kirigami.Units.smallSpacing : 0
                    Layout.leftMargin: Kirigami.Settings.isMobile ? 0 : Kirigami.Units.largeSpacing
                    Layout.rightMargin: Kirigami.Settings.isMobile ? 0 : Kirigami.Units.largeSpacing

                    maximumLineCount: Kirigami.Settings.isMobile ? 1 : -1
                    elide: Text.ElideRight
                    font: Kirigami.Settings.isMobile ? Kirigami.Theme.smallFont : Kirigami.Theme.defaultFont
                }
            }
        }
    }
}
