// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.ScrollablePage {
    id: root

    property var libraryModel

    title: i18nc("@title", "Library")

    GridView {
        id: contentDirectoryView

        leftMargin: Kirigami.Units.smallSpacing
        rightMargin: Kirigami.Units.smallSpacing
        topMargin: Kirigami.Units.smallSpacing
        bottomMargin: Kirigami.Units.smallSpacing

        model: root.libraryModel

        cellWidth: {
            const viewWidth = contentDirectoryView.width - Kirigami.Units.smallSpacing * 2;
            let columns = Math.max(Math.floor(viewWidth / 170), 2);
            return Math.floor(viewWidth / columns);
        }
        cellHeight: {
            if (Kirigami.Settings.isMobile) {
                return cellWidth + Kirigami.Units.gridUnit * 3
            } else {
                return 170 + Kirigami.Units.gridUnit * 3
            }
        }
        currentIndex: -1
        reuseItems: true
        activeFocusOnTab: true
        keyNavigationEnabled: true

        delegate: GridBrowserDelegate {
            width: Kirigami.Settings.isMobile ? contentDirectoryView.cellWidth : 170
            height: contentDirectoryView.cellHeight

            fallBackIconName: 'application-epub+zip';
        }

        Kirigami.PlaceholderMessage {
            anchors.centerIn: parent
            width: parent.width - (Kirigami.Units.largeSpacing * 4)
            visible: contentDirectoryView.count === 0
            icon.name: "application-epub+zip"
            text: i18nc("@info placeholder", "Add some books")
        }
    }
}
