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
    property Item above
    /*!
       \brief The delegate immediately below the separator.
     */
    property Item below

    Layout.leftMargin: parent._internal_formcard_margins ? parent._internal_formcard_margins : Kirigami.Units.largeSpacing
    Layout.rightMargin: parent._internal_formcard_margins ? parent._internal_formcard_margins : Kirigami.Units.largeSpacing
    Layout.fillWidth: true

    // We need to initialize above and below later otherwise nextItemInFocusChain
    // will return the element itself
    Timer {
        interval: 500
        running: !root.above || !root.below
        onTriggered: {
            if (!root.above) {
                root.above = root.nextItemInFocusChain(true);
            }
            if (!root.below) {
                root.below = root.nextItemInFocusChain(false);
            }
        }
    }

    opacity: (!above || above.background === null || !(above.enabled && ((above.visualFocus || above.hovered && !Kirigami.Settings.tabletMode) || above.pressed))) &&
        (!below || below.background === null || !(below.enabled && ((below.visualFocus || below.hovered && !Kirigami.Settings.tabletMode) || below.pressed))) ? 0.5 : 0
}
