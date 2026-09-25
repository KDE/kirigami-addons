/*
 * Copyright 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

// A status message for form delegates. It intentionally has no actions,
// close button, or show/hide animations.
Rectangle {
    id: root

    property string text: ""
    property int type: Kirigami.MessageType.Information

    readonly property color accentColor: {
        switch (type) {
        case Kirigami.MessageType.Positive:
            return Kirigami.Theme.positiveTextColor;
        case Kirigami.MessageType.Warning:
            return Kirigami.Theme.neutralTextColor;
        case Kirigami.MessageType.Error:
            return Kirigami.Theme.negativeTextColor;
        default:
            return Kirigami.Theme.activeTextColor;
        }
    }

    implicitWidth: content.implicitWidth + 2 * Kirigami.Units.mediumSpacing
    implicitHeight: content.implicitHeight + 2 * Kirigami.Units.mediumSpacing

    radius: Kirigami.Units.cornerRadius
    color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, accentColor, 0.2)

    Accessible.role: Accessible.AlertMessage
    Accessible.ignored: !visible
    Accessible.name: text
    Accessible.description: {
        switch (type) {
        case Kirigami.MessageType.Positive:
            return qsTr("Success");
        case Kirigami.MessageType.Warning:
            return qsTr("Warning");
        case Kirigami.MessageType.Error:
            return qsTr("Error");
        default:
            return qsTr("Note");
        }
    }

    RowLayout {
        id: content

        anchors.fill: parent
        anchors.margins: Kirigami.Units.mediumSpacing
        spacing: Kirigami.Units.largeSpacing

        Kirigami.Icon {
            source: {
                switch (root.type) {
                case Kirigami.MessageType.Positive:
                    return "emblem-success";
                case Kirigami.MessageType.Warning:
                    return "emblem-warning";
                case Kirigami.MessageType.Error:
                    return "emblem-error";
                default:
                    return "emblem-information";
                }
            }
            color: root.accentColor
            Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
            Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
            Layout.alignment: Qt.AlignTop
            Accessible.ignored: true
        }

        Controls.Label {
            text: root.text
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            Accessible.ignored: true
        }
    }
}
