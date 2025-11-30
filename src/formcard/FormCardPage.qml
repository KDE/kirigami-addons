// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Window
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

/*!
   \qmltype FormCardPage
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A scrollable page used as a container for one or more FormCards.

   \since 0.11.0
 */
Kirigami.ScrollablePage {
    id: root

    default property alias cards: internalLayout.data

    topPadding: 0
    leftPadding: 0
    rightPadding: 0

    function findAncestor(item: Item, predicate: /*function Item => bool*/ var): Item {
        let target = item.parent
        while (target && !predicate(target)) {
            target = target.parent
        }
        return target
    }

    Connections {
        target: root.Window
        function onActiveFocusItemChanged(): void {
            const item = root.Window.activeFocusItem
            if (item && root.findAncestor(item, (item) => item === root)) {
                const itemPosition = root.flickable.contentItem.mapFromItem(item, 0, 0)
                root.ensureVisible(item, itemPosition.x - item.x, itemPosition.y - item.y)
            }
        }
    }

    background: Rectangle {
        Kirigami.Theme.colorSet: Kirigami.Theme.Window
        Kirigami.Theme.inherit: false

        Item {
            id: view

            Kirigami.Theme.colorSet: Kirigami.Theme.View
            Kirigami.Theme.inherit: false
        }

        color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, view.Kirigami.Theme.backgroundColor, 0.5);
    }

    ColumnLayout {
        id: internalLayout

        spacing: 0
    }
}
