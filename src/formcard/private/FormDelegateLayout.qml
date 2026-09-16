/*
 * Copyright 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts

/*! Internal layout shared by form delegates with leading and trailing items. */
RowLayout {
    id: root

    property Item leading: null
    property Item trailing: null
    property real leadingPadding: 0
    property real trailingPadding: 0

    default property alias content: contentLayout.data

    spacing: 0

    Layout.fillWidth: true

    LayoutItemProxy {
        target: root.leading
        visible: target && target.visible
        Layout.rightMargin: visible ? root.leadingPadding : 0
    }

    RowLayout {
        id: contentLayout

        Layout.fillWidth: true
        spacing: 0
    }

    LayoutItemProxy {
        target: root.trailing
        visible: target && target.visible
        Layout.leftMargin: visible ? root.trailingPadding : 0
    }
}
