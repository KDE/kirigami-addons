// SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Templates 2.15 as T
import QtQuick.Layouts 1.15

/**
 * @brief Header content with actions after the label.
 */
RowLayout {
    id: root

    /**
     * @brief This property holds the header title.
     *
     * @property string title
     */
    property alias title: headerContent.text

    /**
     * @brief A list of actions to show as ToolButtons after the header.
     */
    property list<T.Action> actions

    QQC2.Label {
        id: headerContent
        Layout.fillWidth: true
        font.weight: Font.DemiBold
        wrapMode: Text.WordWrap
        Accessible.role: Accessible.Heading
    }
    Repeater {
        model: root.actions

        QQC2.ToolButton {
            required property var modelData

            action: modelData
            visible: modelData
        }
    }
}
