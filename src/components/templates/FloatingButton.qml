/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

/*!
   \qmltype FloatingButton
   \inqmlmodule org.kde.kirigamiaddons.components.templates
   \brief Shared API and clickable margins for floating buttons.
 */
T.RoundButton {
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

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

    topPadding: padding + topMargin
    leftPadding: padding + leftMargin
    rightPadding: padding + rightMargin
    bottomPadding: padding + bottomMargin

    topInset: topMargin
    leftInset: leftMargin
    rightInset: rightMargin
    bottomInset: bottomMargin

    display: T.AbstractButton.IconOnly
    spacing: 0
    hoverEnabled: !Kirigami.Settings.hasTransientTouchInput
}
