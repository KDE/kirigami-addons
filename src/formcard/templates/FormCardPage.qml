// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

/*!
   \qmltype FormCardPage
   \inqmlmodule org.kde.kirigamiaddons.formcard.templates
   \brief A scrollable page used as a container for one or more FormCards.

   \since 0.11.0
 */
Kirigami.ScrollablePage {
    id: root

    default property alias cards: internalLayout.data

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

    ColumnLayout {
        id: internalLayout

        spacing: 0
    }
}
