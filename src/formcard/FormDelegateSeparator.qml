/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQml
import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

/*!
   \qmltype FormDelegateSeparator
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A context-aware separator.

   This is a standard \l {Separator} {Kirigami.Separator} that can be hidden upon hovering
   the mouse over the \l above or \l below delegate, allowing for a subtle
   but smooth animation feedback.

   Its two properties are particularly useful when it is not immediately known
   which delegate will fill the \l above or \l below position, such as delegates
   provided from a model or managed by a Loader.

   \sa {Separator} {Kirigami.Separator}
 */
Kirigami.Separator {
    id: root

    /*!
       \brief The delegate immediately above the separator.
     */
    property Item above: _index > 0 ? _siblings[_index - 1] : null

    /*!
       \brief The delegate immediately below the separator.
     */
    property Item below: _index !== -1 && _index < _siblings.length - 1 ? _siblings[_index + 1] : null

    opacity: 0.5

    property real hMargins: parent._internal_formcard_margins ? parent._internal_formcard_margins : Kirigami.Units.largeSpacing
    Layout.leftMargin: hMargins
    Layout.rightMargin: hMargins
    Layout.fillWidth: true

    // QML automatically tracks parent.visibleChildren for changes
    readonly property var _siblings: parent ? parent.visibleChildren : []

    // Automatically recalculates when _siblings or visible changes
    readonly property int _index: {
        if (!visible) {
            return -1;
        }

        for (let i = 0; i < _siblings.length; ++i) {
            if (_siblings[i] === root) {
                return i;
            }
        }
        return -1;
    }

    states: State {
        name: "invisible"
        when: isActive(root.above) || isActive(root.below)

        PropertyChanges {
            root.opacity: 0
            root.hMargins: 0
        }

        function isActive(item: Item): bool {
            return item?.background?.visible && item.enabled && (item.visualFocus || item.pressed || (item.hovered && !Kirigami.Settings.tabletMode));
        }
    }

    transitions: Transition {
        to: "invisible"
        reversible: true

        ParallelAnimation {
            PropertyAnimation {
                property: "hMargins"
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
            PropertyAnimation {
                property: "opacity"
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
    }
}
