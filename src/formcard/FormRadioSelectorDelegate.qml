// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as Components

/*!
   \qmltype FormRadioSelectorDelegate
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A FormCard delegate that allows switching between multiple options.

   This wraps a RadioSelector.

   Example:

   \qml
   FormCard.FormRadioSelectorDelegate {
     consistentWidth: false
     actions: [
         Kirigami.Action {
             text: i18nc("@option:radio", "Week")
             icon.name: "view-calendar-week-symbolic"
         },
         Kirigami.Action {
             text: i18nc("@option:radio", "3 Days")
             icon.name: "view-calendar-upcoming-days-symbolic"
         },
         Kirigami.Action {
             text: i18nc("@option:radio", "1 Day")
             icon.name: "view-calendar-day-symbolic"
         }
     ]
   }
   \endqml
   \since 1.6.0.
 */
AbstractFormDelegate {
    id: root

    /*!
       \brief This property holds a list of actions, each holding one of the options.
     */
    property alias actions: radioSelector.actions

    /*!
       \qmlproperty bool consistentWidth
       \brief This property holds whether all the items should have the same width.
     */
    property alias consistentWidth: radioSelector.consistentWidth

    /*!
       \qmlproperty int selectedIndex
       \brief This property holds the currently selected option.
     */
    property alias selectedIndex: radioSelector.selectedIndex

    topPadding: Kirigami.Units.largeSpacing
    bottomPadding: Kirigami.Units.largeSpacing

    background: null
    contentItem: Components.RadioSelector {
        id: radioSelector
    }
}
