// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components.templates as Templates

/*!
   \qmltype RadioSelectorButton
   \inqmlmodule org.kde.kirigamiaddons.components.templates
   \internal
 */
T.ToolButton {
    id: button

    required property Templates.RadioSelector selector

    required property T.Action modelData
    required property int index

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    Layout.fillWidth: true
    Layout.minimumWidth: implicitWidth

    action: modelData
    checkable: true
    visible: !(modelData instanceof Kirigami.Action) || modelData.visible
    hoverEnabled: !Kirigami.Settings.hasTransientTouchInput

    Accessible.role: Accessible.RadioButton

    onClicked: {
        checked = true;
        selector.selectedIndex = index;
    }

    Component.onCompleted: checked = index === selector.selectedIndex
}

