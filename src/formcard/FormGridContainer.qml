// SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
// SPDX-FileCopyrightText: 2023 Rishi Kumar <rsi.dev17@gmail.com>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard.templates as T

import "private" as Private

/*!
   \qmltype FormGridContainer
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief This component render a grid of small cards.

   This is used to display multiple information in a FormCard.FormLayout
   without taking too much vertical space.

   Form delegates can also be placed directly inside the container. In this
   mode, delegates are displayed in a two-column grid, each with its own card
   background.

   \qml
   import org.kde.kirigamiaddons.formcard as FormCard

   FormCard.FormGridContainer {
       id: container

       Layout.topMargin: Kirigami.Units.largeSpacing
       Layout.fillWidth: true

       infoCards: [
           FormCard.FormGridContainer.InfoCard {
               title: "42"
               subtitle: i18nc("@info:Number of Posts", "Posts")
           },
           FormCard.FormGridContainer.InfoCard {
               title: "42"
               subtitle: i18nc("@info:Number of followers.", "Followers")
           }
       ]
   }
   \endqml

   \qml
   import org.kde.kirigamiaddons.formcard as FormCard

   FormCard.FormGridContainer {
       FormCard.FormTextDelegate {
           text: "Name"
       }
       FormCard.FormSwitchDelegate {
           text: "Enable notifications"
       }
   }
   \endqml

   \since 0.11.0
 */
T.FormGridContainer {
    id: root

    component InfoCard: T.FormGridContainer.InfoCard {}

    borderWidth: 1
    cornerRadius: cardWidthRestricted ? Kirigami.Units.cornerRadius : 0

    backgroundDelegate: Private.FormCardBackground {
        rounded: root.cardWidthRestricted
        radius: root.cornerRadius
        border.width: root.borderWidth
    }
}
