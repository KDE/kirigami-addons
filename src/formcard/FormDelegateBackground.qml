/*
 * SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard.templates as T

/*!
   \qmltype FormDelegateBackground
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A background for Form delegates.

   This is a simple background that provides opacity feedback to the user
   when the control has focus or is currently being pressed, for example.

   This is used in AbstractFormDelegate so that new delegates provide this
   feedback by default, and can be easily overriden with an Item.

   \since 0.11.0

   \sa AbstractFormDelegate
 */
T.FormDelegateBackground {
    id: root

    readonly property real _colorOpacity: !control.enabled ? 0
        : control.pressed ? 0.2
        : control.visualFocus ? 0.1
        : !Kirigami.Settings.tabletMode && control.hovered ? 0.07
        : 0

    color: Kirigami.Theme.textColor
    opacity: _colorOpacity

    Behavior on opacity {
        NumberAnimation { duration: Kirigami.Units.shortDuration }
    }
}
