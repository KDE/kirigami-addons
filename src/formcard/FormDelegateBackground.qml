/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

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
Kirigami.ShadowedRectangle {
    id: root

    /*!
       \qmlproperty Control control
       \brief The control to which the background will be assigned.
     */
    required property T.Control control

    readonly property bool _roundCorners: control?.parent?._roundCorners === true
    readonly property bool _isFirst: _roundCorners && control.parent._firstVisibleItem === control
    readonly property bool _isLast: _roundCorners && control.parent._lastVisibleItem === control

    readonly property real _colorOpacity: !control.enabled ? 0
        : control.pressed ? 0.2
        : control.visualFocus ? 0.1
        : !Kirigami.Settings.tabletMode && control.hovered ? 0.07
        : 0

    color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, _colorOpacity)

    corners {
        topLeftRadius: _isFirst ? Kirigami.Units.cornerRadius : 0
        topRightRadius: _isFirst ? Kirigami.Units.cornerRadius : 0
        bottomLeftRadius: _isLast ? Kirigami.Units.cornerRadius : 0
        bottomRightRadius: _isLast ? Kirigami.Units.cornerRadius : 0
    }

    Behavior on color {
        ColorAnimation { duration: Kirigami.Units.shortDuration }
    }
}
