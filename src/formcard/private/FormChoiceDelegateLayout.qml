/*
 * Copyright 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

/*! Internal layout shared by check and radio form delegates. */
ColumnLayout {
    id: root

    property Item leading: null
    property Item trailing: null
    property real leadingPadding: Kirigami.Units.smallSpacing
    property real trailingPadding: Kirigami.Units.smallSpacing
    property string description: ""
    property alias descriptionItem: internalDescriptionItem

    default property alias content: delegateLayout.content

    spacing: FormCardUnits.verticalSpacing

    Private.FormDelegateLayout {
        id: delegateLayout

        leading: root.leading
        trailing: root.trailing
        leadingPadding: root.leadingPadding
        trailingPadding: root.trailingPadding
    }

    Controls.Label {
        id: internalDescriptionItem

        visible: root.description !== ""
        Layout.fillWidth: true
        text: root.description
        color: Kirigami.Theme.disabledTextColor
        wrapMode: Text.Wrap
    }
}
