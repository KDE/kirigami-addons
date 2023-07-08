/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

/**
 * @brief A header for a FormCard.
 *
 * The FormCardHeader consists of a label with bold text, an optional subtitle,
 * and an additional separator to make it visually distinguishable as a
 * FormCard title/header.
 *
 * @since org.kde.kirigamiaddons.labs.mobileform 0.1
 * @deprecated Since 0.9, FormHeader replaces this component.
 */
ColumnLayout {
    id: root
    spacing: 0

    /**
     * @brief This property holds the header title.
     *
     * The title is displayed in bold.
     */
    property string title: ""

    /**
     * @brief This property holds the header subtitle.
     *
     * The subtitle is displayed in a faint gray color.
     */
    property string subtitle: ""

    ColumnLayout {
        visible: title !== "" || subtitle !== ""

        Layout.fillWidth: true
        Layout.bottomMargin: Kirigami.Units.largeSpacing
        Layout.topMargin: Kirigami.Units.largeSpacing
        Layout.leftMargin: Kirigami.Units.gridUnit
        Layout.rightMargin: Kirigami.Units.gridUnit

        spacing: Kirigami.Units.smallSpacing

        Label {
            Layout.fillWidth: true
            font.weight: Font.Bold
            text: title
            visible: title !== ""
            wrapMode: Text.Wrap
            Accessible.ignored: !visible
        }

        Label {
            color: Kirigami.Theme.disabledTextColor
            text: subtitle
            visible: subtitle !== ""
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            Accessible.ignored: !visible
        }
    }

    Kirigami.Separator {
        opacity: 0.5
        Layout.fillWidth: true
        Accessible.ignored: true
    }
}
