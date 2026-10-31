/*
 * Copyright 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts

/*!
    \qmltype FormDelegateLayout
    \internal Layout shared by form delegates with leading and trailing items.
*/
RowLayout {
    id: root

    property Item leading: null
    property Item trailing: null
    property real leadingPadding: 0
    property real trailingPadding: 0

    default property alias content: contentLayout.data

    spacing: 0

    Layout.fillWidth: true

    ContentItemLoader {
        readonly property bool _visible: root.leading && root.leading.visible
        Layout.rightMargin: _visible ? root.leadingPadding : 0
        implicitHeight: _visible ? root.leading.implicitHeight : 0
        implicitWidth: _visible ? root.leading.implicitWidth : 0
        contentItem: root.leading
    }

    RowLayout {
        id: contentLayout

        Layout.fillWidth: true
        spacing: 0
    }

    ContentItemLoader {
        readonly property bool _visible: root.trailing && root.trailing.visible
        Layout.leftMargin: _visible ? root.trailingPadding : 0
        implicitHeight: _visible ? root.trailing.implicitHeight : 0
        implicitWidth: _visible ? root.trailing.implicitWidth : 0
        contentItem: root.trailing
    }
}
