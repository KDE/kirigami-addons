/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.4 as Kirigami

/**
 * @brief A context-aware separator.
 *
 * This is a standard Kirigami.Separator that can be hidden upon hovering
 * the mouse over the ::above or ::below delegate, allowing for a subtle
 * but smooth animation feedback.
 *
 * Its two properties are particularly useful when it is not immediately known
 * which delegate will fill the ::above or ::below position, such as delegates
 * provided from a model or managed by a Loader.
 *
 * @see Kirigami.Separator
 *
 * @inherit Kirigami.Separator
 */
Kirigami.Separator {
    /**
     * @brief The delegate immediately above the separator.
     */
    property var above
    /**
     * @brief The delegate immediately below the separator.
     */
    property var below

    Layout.leftMargin: Kirigami.Units.largeSpacing
    Layout.rightMargin: Kirigami.Units.largeSpacing
    Layout.fillWidth: true

    opacity: (!above || above.background === null || !(above.enabled && ((above.visualFocus || above.hovered && !Kirigami.Settings.tabletMode) || above.pressed))) &&
        (!below || below.background === null || !(below.enabled && ((below.visualFocus || below.hovered && !Kirigami.Settings.tabletMode) || below.pressed))) ? 0.5 : 0
}
