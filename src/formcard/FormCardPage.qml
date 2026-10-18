// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard.templates as T

/*!
   \qmltype FormCardPage
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A scrollable page used as a container for one or more FormCards.

   \since 0.11.0
 */
T.FormCardPage {
    topPadding: 0
    leftPadding: 0
    rightPadding: 0

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
}
