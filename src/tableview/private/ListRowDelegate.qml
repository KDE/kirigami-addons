/*
 * Copyright 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

QQC2.ItemDelegate {
    id: delegate

    Accessible.role: Accessible.Row

    padding: 0
    horizontalPadding: 0

    required property var model
    required property int index

    property bool alternatingRows

    background: Rectangle {
        color: {
            if (delegate.enabled) {
                if (delegate.down || delegate.highlighted) {
                    return Kirigami.Theme.highlightColor
                }

                if (delegate.hovered && !Kirigami.Settings.isMobile) {
                    return Qt.alpha(Kirigami.Theme.hoverColor, 0.3)
                }
            }

            if (delegate.alternatingRows && index % 2) {
                return Kirigami.Theme.alternateBackgroundColor;
            }

            return "Transparent"
        }
    }

    contentItem: Row {
        spacing: 0

        Repeater {
            model: root.__columnModel

            delegate: ListCellDelegate {
                implicitWidth: root.__columnModel.get(index)?.headerComponent.width ?? 0
                implicitHeight: root.__rowHeight
                entry: delegate.model
                rowIndex: delegate.index
            }
        }
    }

    onClicked: delegate.forceActiveFocus()
}
