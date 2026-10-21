/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T

/*!
   \qmltype SegmentedButton
   \inqmlmodule org.kde.kirigamiaddons.components.templates
   \brief Shared actions and layout for segmented buttons.
 */
RowLayout {
    id: root

    /*! This property holds the actions represented by the segments. */
    property list<T.Action> actions

    /*!
       The component used to display each segment. It receives the action as
       modelData and its position as index.
     */
    property Component delegate

    /*! \internal The number of segments. */
    readonly property int _buttonCount: repeater.count

    spacing: -1

    Repeater {
        id: repeater

        model: root.actions
        delegate: root.delegate
    }
}
