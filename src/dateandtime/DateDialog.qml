// SPDX-FileCopyrightText: 2021 Nicolas Fella <nicolas.fella@gmx.de>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.15 as Kirigami

/**
 * A dialog prompting the user to enter a date.
 * This may be a native system dialog.
 */
QtObject {
    id: root
    /**
     * The year of the selected date
     */
    property int year: __impl.year

    /**
     * The month of the selected date
     */
    property int month: __impl.month

    /**
     * The selected date
     */
    property date selectedDate: __impl.selectedDate

    /**
     * Emitted when the user accepted the dialog.
     */
    signal accepted()

    /**
     * Emitted when the user rejected the dialog.
     */
    signal rejected()

    /**
     * Open the dialog.
     */
    function open() {
        __impl.open()
    }

    property alias __impl: loader.item

    property var __loader: Loader {
        id: loader
        sourceComponent: __fallback
    }

    property var __fallback: Component {
        DatePopup {
            onAccepted: root.accepted()
            onCancelled: root.rejected()
        }
    }
}
