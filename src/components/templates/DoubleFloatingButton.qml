/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigami as Kirigami

/*!
   \qmltype DoubleFloatingButton
   \inqmlmodule org.kde.kirigamiaddons.components.templates
   \brief Shared actions, clickable margins and surface for paired floating buttons.
 */
Item {
    /*! The leading action. */
    property Kirigami.Action leadingAction

    /*! The trailing action. */
    property Kirigami.Action trailingAction

    /*!
       \qmlproperty real margins
       \qmlproperty real topMargin
       \qmlproperty real leftMargin
       \qmlproperty real rightMargin
       \qmlproperty real bottomMargin
       \default 0
       \brief Extra clickable area that adjusts both paddings and insets.
     */
    property real margins: 0
    property real topMargin: margins
    property real leftMargin: margins
    property real rightMargin: margins
    property real bottomMargin: margins

    /*! The surface behind the two buttons. */
    readonly property alias background: surface

    /*! The corner radius of the surface. */
    property alias radius: surface.radius
    /*! The background color of the surface. */
    property alias color: surface.color
    /*! The border of the surface. */
    property alias border: surface.border
    /*! The individual corner radii of the surface. */
    property alias corners: surface.corners
    /*! The shadow of the surface. */
    property alias shadow: surface.shadow

    Kirigami.ShadowedRectangle {
        id: surface
        anchors.fill: parent
    }
}
