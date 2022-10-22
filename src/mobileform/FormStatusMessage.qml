/*
 * Copyright 2022 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

/**
 * Form delegate that corresponds to a text label.
 */
Control {
    /**
     * This property holds the current status of the text field.
     *
     * Depending on the status of the textField the statusMessage property will look different
     */
    property var status: AbstractFormDelegate.Status.Default

    /**
     * This property holds the current status message of the text field.
     */
    property string statusMessage: ''

    visible: statusMessage.length > 0

    Layout.fillWidth: true

    leftPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    rightPadding: Kirigami.Units.largeSpacing
    topPadding: Kirigami.Units.largeSpacing
    bottomPadding: Kirigami.Units.largeSpacing

    contentItem: RowLayout {
        Label {
            text: statusMessage
        }
    }

    background: Kirigami.ShadowedRectangle {
        visible: status !== AbstractFormDelegate.Status.Default
        radius: Kirigami.Units.smallSpacing

        color: switch (status) {
            case AbstractFormDelegate.Status.Default:
                return Kirigami.Theme.backgroundColor;
            case AbstractFormDelegate.Status.Success:
                return Qt.rgba(
                    Kirigami.Theme.positiveTextColor.r,
                    Kirigami.Theme.positiveTextColor.g,
                    Kirigami.Theme.positiveTextColor.b,
                    0.1
                )
            case AbstractFormDelegate.Status.Error:
                return Qt.rgba(
                    Kirigami.Theme.negativeTextColor.r,
                    Kirigami.Theme.negativeTextColor.g,
                    Kirigami.Theme.negativeTextColor.b,
                    0.1
                )
        }
        Kirigami.ShadowedRectangle {
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            corners {
                bottomLeftRadius: Kirigami.Units.smallSpacing
                topLeftRadius: Kirigami.Units.smallSpacing
                topRightRadius: 0
                bottomRightRadius: 0
            }
            color: switch (status) {
                case AbstractFormDelegate.Status.Default:
                    return Kirigami.Theme.textColor;
                case AbstractFormDelegate.Status.Success:
                    return Kirigami.Theme.positiveTextColor;
                case AbstractFormDelegate.Status.Error:
                    return Kirigami.Theme.negativeTextColor;
            }
            width: Kirigami.Units.smallSpacing
        }
    }
}

