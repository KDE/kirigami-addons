/*
 *   SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2

/**
 * @brief A wrapper around PageIndicator to provide additional features over the QQC2 version.
 *
 * This wrapper around PageIndicator exists because PageIndicator lacks some features
 * such as basic horizontal centering and tapping on the left/right side of dots
 * to change pages by one.
 *
 * The function bindCurrentIndex() must be overwritten instead of setting the
 * currentIndex directly to stop any bindings being broken.
 *
 * Example:
 * @code
 * ColumnLayout {
 *  ListView {
 *      id: listView
 *      model: someModel
 *  }
 *  AlbumPageIndicator {
 *      interactive: true
 *      count: listView.count
 *      function bindCurrentIndex() {
 *          currentIndex = Qt.binding(() => listView.currentIndex);
 *      }
 *      onCurrentIndexChanged: {
 *          listView.currentIndex = currentIndex;
 *      }
 *  }
 * @endcode
 *
 * @sa QQC2.PageIndicator, QTBUG-117864
 */
MouseArea {
    id: root

    /**
     * @brief Whether the control is interactive.
     */
    property alias interactive: indicator.interactive

    /**
     * @brief This property holds the index of the current page.
     */
    property alias currentIndex: indicator.currentIndex

    /**
     * @brief This property holds the number of pages.
     */
    property alias count: indicator.count

    /**
     * @brief This property determines the way the control accepts focus.
     */
    property alias focusPolicy: indicator.focusPolicy

    /**
     * @brief This property holds the top padding.
     */
    property alias topPadding: indicator.topPadding

    /**
     * @brief This property holds the bottom padding.
     */
    property alias bottomPadding: indicator.bottomPadding

    /**
     * @brief Set the binding for currentIndex.
     *
     * Instances must override this function instead of binding directly, because
     * assignments in a pure JavaScript handler of MouseArea will break any bindings,
     * requiring re-setting them.
     */
    function bindCurrentIndex() {
        // This is just an example of how a binding should look like. This
        // base implementation shouldn't actually be ever called.
        console.warn("Clients should override bindCurrentIndex()");
        currentIndex = Qt.binding(() => -1);
    }

    Component.onCompleted: bindCurrentIndex()
    // Let client code handle the change before we re-bind it back
    onCurrentIndexChanged: Qt.callLater(bindCurrentIndex)

    implicitHeight: indicator.implicitHeight
    implicitWidth: indicator.implicitWidth

    QQC2.PageIndicator {
        id: indicator

        LayoutMirroring.enabled: root.LayoutMirroring.enabled

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    onPressed: event => {
        let direction = 0;
        if (event.x < indicator.x) {
            direction = LayoutMirroring.enabled ? 1 : -1;
        } else if (event.x > indicator.x + indicator.width) {
            direction = LayoutMirroring.enabled ? -1 : 1;
        } else {
            return;
        }
        // Careful: assignment breaks binding! Read the note above.
        if (direction < 0) {
            if (indicator.currentIndex > 0) {
                indicator.currentIndex -= 1;
            }
        } else if (direction > 0) {
            if (indicator.currentIndex < indicator.count - 1) {
                indicator.currentIndex += 1;
            }
        }
    }
}
