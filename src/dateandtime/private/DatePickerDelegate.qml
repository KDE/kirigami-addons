// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami
import org.kde.kirigamiaddons.delegates 1.0 as Delegates

Delegates.RoundedItemDelegate {
    id: root

    required property int index
    required property date date
    required property var minimumDate
    required property var maximumDate
    required property Repeater repeater
    required property T.Action previousAction
    required property T.Action nextAction

    readonly property bool inScope: (!minimumDate || minimumDate.valueOf() <= date.valueOf())
        && (!maximumDate || maximumDate.valueOf() >= date.valueOf())

    leftInset: 0
    rightInset: 0

    focusPolicy: inScope ? Qt.TabFocus : Qt.NoFocus
    enabled: inScope

    focus: inScope && (index === 0 || !repeater.itemAt(index - 1).inScope)

    contentItem: Delegates.DefaultContentItem {
        itemDelegate: root

        labelItem {
            rightPadding: Kirigami.Units.mediumSpacing
            leftPadding: Kirigami.Units.mediumSpacing
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Keys.onLeftPressed: if (inScope) {
        if (index !== 0) {
            const item = repeater.itemAt(index - 1);
            if (item.inScope) {
                item.forceActiveFocus();
            }
        } else {
            goPreviousAction.trigger();
        }
    }

    Keys.onRightPressed: if (inScope) {
        if (index !== repeater.count - 1) {
            const item = repeater.itemAt(index + 1);
            if (item.inScope) {
                item.forceActiveFocus();
            }
        } else {
            goNextAction.trigger();
        }
    }

    Layout.fillWidth: true
    Layout.fillHeight: true
}
