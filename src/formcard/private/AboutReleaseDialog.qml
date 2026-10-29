// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigamiaddons.private
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCardModule

AboutDialog {
    id: root

    required property var releases
    property bool showOnlyNewReleases: false

    title: I18n.i18n("Release history")
    implicitHeight: Math.min(parent ? parent.height - Kirigami.Units.gridUnit * 2 : Kirigami.Units.gridUnit * 32,
                             Kirigami.Units.gridUnit * 32,
                             implicitHeaderHeight + releasesColumn.implicitHeight + Kirigami.Units.gridUnit * 2)

    contentItem: QQC2.ScrollView {
        id: releasesScrollView
        contentWidth: availableWidth
        contentHeight: releasesColumn.implicitHeight + Kirigami.Units.gridUnit * 2
        QQC2.ScrollBar.horizontal.policy: QQC2.ScrollBar.AlwaysOff
        QQC2.ScrollBar.vertical.interactive: Kirigami.Settings.style !== 'Material'

        ColumnLayout {
            id: releasesColumn
            x: Kirigami.Units.gridUnit
            y: Kirigami.Units.gridUnit
            width: releasesScrollView.availableWidth - Kirigami.Units.gridUnit * 2
            spacing: Kirigami.Units.largeSpacing * 2

            Repeater {
                model: root.showOnlyNewReleases
                    ? root.releases.filter((release, index) => FormCardModule.AboutComponent.newReleaseIndexes.includes(index))
                    : root.releases
                delegate: ColumnLayout {
                    required property var modelData

                    Layout.fillWidth: true
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 30
                    spacing: Kirigami.Units.smallSpacing

                    QQC2.Label {
                        Layout.fillWidth: true
                        text: modelData.version
                        font.bold: true
                    }

                    QQC2.Label {
                        Layout.fillWidth: true
                        text: modelData.date.toLocaleDateString()
                        color: Kirigami.Theme.disabledTextColor
                        visible: modelData.date && modelData.date.getTime() !== 0
                    }

                    QQC2.Label {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                        text: modelData.description
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                        onLinkActivated: (link) => Qt.openUrlExternally(link)
                        visible: text.length > 0
                    }

                    FormCardModule.FormLinkDelegate {
                        Layout.fillWidth: true
                        text: I18n.i18n("More information")
                        url: modelData.url
                        visible: url.toString().length > 0
                    }
                }
            }

            QQC2.Button {
                Layout.alignment: Qt.AlignHCenter
                visible: root.showOnlyNewReleases
                text: I18n.i18n("Show older changes…")
                onClicked: root.showOnlyNewReleases = false
            }
        }
    }
}
