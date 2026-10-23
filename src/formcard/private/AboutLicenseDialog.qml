// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

AboutDialog {
    id: root

    property string text

    contentItem: QQC2.ScrollView {
        id: scrollView

        contentWidth: availableWidth
        QQC2.ScrollBar.horizontal.policy: QQC2.ScrollBar.AlwaysOff

        Kirigami.SelectableLabel {
            width: scrollView.availableWidth
            text: root.text
            textMargin: Kirigami.Units.gridUnit
            wrapMode: Text.WordWrap
            onLinkActivated: link => Qt.openUrlExternally(link)
        }
    }
}
