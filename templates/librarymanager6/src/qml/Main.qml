// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.statefulapp as StatefulApp
import org.kde.kirigamiaddons.formcard as FormCard

import org.kde.librarytemplate
import org.kde.librarytemplate.settings as Settings

StatefulApp.StatefulWindow {
    id: root

    property int counter: 0

    title: i18nc("@title:window", "LibraryTemplate")

    windowName: "LibraryTemplate"

    minimumWidth: Kirigami.Units.gridUnit * 20
    minimumHeight: Kirigami.Units.gridUnit * 20

    application: LibraryTemplateApplication {
        configurationView: Settings.LibraryTemplateConfigurationView {}
    }

    ListModel {
        id: libraryModel

        ListElement {
            thumbnail: 'https://www.magicmurals.com/media/amasty/webp/catalog/product/cache/155d73b570b90ded8a140526fcb8f2da/a/d/adg-0000001048_1_jpg.webp'
            title: '1984'
            author: 'George Orwell'
            currentProgress: 75
        }

        ListElement {
            thumbnail: 'https://www.magicmurals.com/media/amasty/webp/catalog/product/cache/155d73b570b90ded8a140526fcb8f2da/a/d/adg-0000001048_1_jpg.webp'
            title: '1984'
            author: 'George Orwell'
            currentProgress: 45
        }

        ListElement {
            thumbnail: 'https://www.magicmurals.com/media/amasty/webp/catalog/product/cache/155d73b570b90ded8a140526fcb8f2da/a/d/adg-0000001048_1_jpg.webp'
            title: '1984'
            author: 'George Orwell'
            currentProgress: 15
        }

        ListElement {
            thumbnail: 'https://www.magicmurals.com/media/amasty/webp/catalog/product/cache/155d73b570b90ded8a140526fcb8f2da/a/d/adg-0000001048_1_jpg.webp'
            title: '1984'
            author: 'George Orwell'
            currentProgress: 0
        }

        ListElement {
            thumbnail: 'https://www.magicmurals.com/media/amasty/webp/catalog/product/cache/155d73b570b90ded8a140526fcb8f2da/a/d/adg-0000001048_1_jpg.webp'
            title: '1984'
            author: 'George Orwell'
            currentProgress: 75
        }

        ListElement {
            thumbnail: 'https://www.magicmurals.com/media/amasty/webp/catalog/product/cache/155d73b570b90ded8a140526fcb8f2da/a/d/adg-0000001048_1_jpg.webp'
            title: '1984'
            author: 'George Orwell'
            currentProgress: 35
        }
    }


    globalDrawer: Sidebar {
        libraryModel: libraryModel
    }

    pageStack.initialPage: LibraryPage {
        libraryModel: libraryModel
    }
}
