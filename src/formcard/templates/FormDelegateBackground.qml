/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

/*!
   \qmltype FormDelegateBackground
   \inqmlmodule org.kde.kirigamiaddons.formcard.templates
   \brief Shared corner geometry for Form delegate backgrounds.

   Style implementations provide the color and interaction feedback.
 */
Kirigami.ShadowedRectangle {
    id: root

    /*!
       \qmlproperty Control control
       \brief The control to which the background will be assigned.
     */
    required property T.Control control

    readonly property real _cornerRadius: control?.parent?._cornerRadius ?? 0
    readonly property real _topRadius: control?.parent?._firstVisibleItem === control ? _cornerRadius : 0
    readonly property real _bottomRadius: control?.parent?._lastVisibleItem === control ? _cornerRadius : 0

    corners {
        topLeftRadius: _topRadius
        topRightRadius: _topRadius
        bottomLeftRadius: _bottomRadius
        bottomRightRadius: _bottomRadius
    }
}
