// SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-FileCopyrightText: 2021 Felipe Kinoshita <kinofhek@gmail.com>
// SPDX-FileCopyrightText: 2021 Marco Martin <mart@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami
import org.kde.kirigamiaddons.delegates 1.0 as Delegates

/**
 * A container for setting actions showing them in a list view and displaying
 * the actual page next to it.
 *
 * To open a setting page, you should use `PageRow::pushDialogLayers`
 *
 * @since KirigamiAddons 0.11.0
 * @inherit kde::org::kirigami::PageRow
 * @deprecated Since 1.3.0, use ConfigurationsView instead.
 */
Kirigami.PageRow {
    id: root

    /**
     * @brief The default page that will be shown when opened.
     *
     * This only applies when the categorized settings object is wide enough to
     * show multiple pages.
     *
     * @see actions
     */
    property string defaultPage

    /**
     * @brief The list of pages for the settings
     */
    property list<Kirigami.PagePoolAction> actions

    property alias _stack: root
    property Kirigami.PagePool _pool: Kirigami.PagePool {}

    readonly property string title: root.depth < 2 ? i18ndc("kirigami-addons6", "@title:window", "Settings") :i18ndc("kirigami-addons6", "@title:window", "Settings — %1", root.get(1).title)

    property bool completed: false

    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0
    topPadding: 0

    // Hack to not base all calculation based on main popup
    function applicationWindow() {
        return _fakeApplicationWindow;
    }

    readonly property QtObject _fakeApplicationWindow: QtObject {
        readonly property Kirigami.PageRow pageStack: root
        readonly property bool controlsVisible: true
        readonly property QtObject globalDrawer: null
        readonly property QtObject contextDrawer: null
        readonly property double width: root.width
        readonly property double height: root.height
        readonly property var overlay: root
    }

    globalToolBar {
        style: Kirigami.ApplicationHeaderStyle.ToolBar
        showNavigationButtons: if (root.currentIndex > 0) {
            Kirigami.ApplicationHeaderStyle.ShowBackButton
        } else {
            0
        }
    }

    signal backRequested(var event)
    onBackRequested: event => {
        if (root.depth > 1 && !root.wideMode && root.currentIndex !== 0) {
            event.accepted = true;
            root.pop();
        }
    }

    columnView.columnWidth: Kirigami.Units.gridUnit * 13

    initialPage: Kirigami.ScrollablePage {
        bottomPadding: 0
        leftPadding: 0
        rightPadding: 0
        topPadding: 0

        titleDelegate: RowLayout {
            Layout.fillWidth: true

            QQC2.ToolButton {
                icon.name: "go-previous-view"
                text: i18ndc("kirigami-addons6", "@action:intoolbar", "Go back")
                display: QQC2.AbstractButton.IconOnly
                onClicked: pageStack.layers.pop()
                visible: pageStack.layers.depth > 1
            }

            Kirigami.SearchField {
                Layout.fillWidth: true
                onTextChanged: listview.filterText = text.toLowerCase();
            }
        }

        ListView {
            id: listview

            property string filterText: ""
            property bool initDone: false

            currentIndex: -1
            topMargin: Math.round(Kirigami.Units.smallSpacing / 2)
            bottomMargin: Math.round(Kirigami.Units.smallSpacing / 2)

            onWidthChanged: if (!initDone && root.width >= Kirigami.Units.gridUnit * 30) {
                let defaultAction = getActionByName(defaultPage);
                if (defaultAction) {
                    defaultAction.trigger();
                    listview.currentIndex = indexOfAction(defaultAction);
                } else {
                    actions[0].trigger();
                    listview.currentIndex = 0;
                    if (root.currentItem.title.length === 0) {
                        root.currentItem.title = actions[0].text;
                    }
                }
                initDone = true;
            }
            model: {
                const isFiltering = filterText.length !== 0;
                let filteredActions = [];
                for (let i in actions) {
                    const action = actions[i];
                    const actionPassesFilter = action.text.toLowerCase().includes(filterText);
                    if (action.visible && (isFiltering ? actionPassesFilter : true)) {
                        filteredActions.push(action);
                    }
                }
                return filteredActions;
            }
            delegate: Delegates.RoundedItemDelegate {
                id: settingDelegate

                required property int index
                required property var modelData

                action: modelData
                checked: ListView.view.currentIndex === settingDelegate.index

                onClicked: {
                    ListView.view.currentIndex = settingDelegate.index;
                    if (root.currentItem.title.length === 0) {
                        root.currentItem.title = text;
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        root.completed = true;
    }

    function getActionByName(actionName) {
        for (let i in actions) {
            if (actions[i].actionName == actionName) {
                return actions[i];
            }
        }
    }

    function indexOfAction(action) {
        for (let i in actions) {
            if (actions[i] == action) {
                return i;
            }
        }
    }
}

