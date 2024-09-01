// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kitemmodels
import org.kde.kirigamiaddons.statefulapp as StatefulApp
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kirigamiaddons.delegates as Delegates

Kirigami.OverlayDrawer {
    id: root

    required property var libraryModel
    readonly property string fallBackIconName: 'application-epub+zip'

    edge: Qt.application.layoutDirection === Qt.RightToLeft ? Qt.RightEdge : Qt.LeftEdge
    modal: Kirigami.Settings.isMobile || (applicationWindow().width < Kirigami.Units.gridUnit * 50 && !collapsed) // Only modal when not collapsed, otherwise collapsed won't show.
    z: modal ? Math.round(position * 10000000) : 100
    drawerOpen: !Kirigami.Settings.isMobile && enabled
    enabled: pageStack.currentItem
    onEnabledChanged: drawerOpen = !Kirigami.Settings.isMobile && enabled
    width: Kirigami.Units.gridUnit * 16
    Behavior on width {
        NumberAnimation {
            duration: Kirigami.Units.longDuration
            easing.type: Easing.InOutQuad
        }
    }
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    handleClosedIcon.source: modal ? null : "sidebar-expand-left"
    handleOpenIcon.source: modal ? null : "sidebar-collapse-left"
    handleVisible: modal
    onModalChanged: if (!modal) {
        drawerOpen = true;
    }

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0

    contentItem: ColumnLayout {
        spacing: 0

        QQC2.ToolBar {
            Layout.fillWidth: true
            Layout.preferredHeight: QQC2.ApplicationWindow.window.pageStack.globalToolBar.preferredHeight

            leftPadding: Kirigami.Units.smallSpacing
            rightPadding: Kirigami.Units.smallSpacing
            topPadding: Kirigami.Units.smallSpacing
            bottomPadding: Kirigami.Units.smallSpacing

            contentItem: Kirigami.SearchField {
                TapHandler {
                    onTapped: {
                        searchDialog.open();
                    }
                    acceptedButtons: Qt.RightButton | Qt.LeftButton
                }
                Keys.onPressed: (event) => {
                    if (event.key !== Qt.Key_Tab || event.key !== Qt.Key_Backtab) {
                        searchDialog.open();
                        searchDialog.text = text;
                    }
                }
                onActiveFocusChanged: if (activeFocus) {
                    searchDialog.open();
                }
                Keys.priority: Keys.AfterItem
            }

            Kirigami.SearchDialog {
                id: searchDialog

                parent: QQC2.Overlay.overlay

                onTextChanged: {
                    searchFilterProxyModel.setFilterFixedString(text)
                }

                model: KSortFilterProxyModel {
                    id: searchFilterProxyModel
                    sourceModel: root.libraryModel
                    filterRoleName: 'title'
                }

                delegate: Delegates.RoundedItemDelegate {
                    id: searchDelegate

                    required property int index
                    required property string title
                    required property string author
                    required property url thumbnail

                    highlighted: activeFocus

                    onClicked: searchDialog.close();

                    contentItem: RowLayout {
                        spacing: Kirigami.Units.smallSpacing

                        Item {
                            Layout.fillHeight: true
                            Layout.preferredWidth: height

                            Image {
                                id: coverImage

                                fillMode: Image.PreserveAspectFit
                                source: searchDelegate.thumbnail
                                asynchronous: true

                                sourceSize {
                                    width: width
                                    height: height
                                }

                                anchors.fill: parent
                            }

                            Kirigami.Icon {
                                id: fallBackIcon

                                anchors {
                                    fill: coverImage
                                    margins: Kirigami.Settings.isMobile ? 0 : Kirigami.Units.largeSpacing
                                }

                                source: root.fallBackIconName
                                visible: (coverImage.status === Image.Error || coverImage.status === Image.Loading ) && source !== undefined
                            }
                        }

                        ColumnLayout {
                            spacing: Kirigami.Units.smallSpacing
                            QQC2.Label {
                                Layout.fillWidth: true
                                text: searchDelegate.title
                                wrapMode: Text.WordWrap
                            }
                            QQC2.Label {
                                Layout.fillWidth: true
                                text: searchDelegate.author
                                wrapMode: Text.WordWrap
                                font: Kirigami.Theme.smallFont
                            }
                        }
                    }
                }

                emptyText: i18n("No search results")
            }
        }

        QQC2.ButtonGroup {
            id: placeGroup
        }

        QQC2.ScrollView {
            id: scrollView

            Layout.fillHeight: true
            Layout.fillWidth: true

            contentWidth: availableWidth
            topPadding: Kirigami.Units.smallSpacing / 2

            component PlaceItem : Delegates.RoundedItemDelegate {
                id: item
                signal triggered;
                checkable: true
                Layout.fillWidth: true
                Keys.onDownPressed: nextItemInFocusChain().forceActiveFocus(Qt.TabFocusReason)
                Keys.onUpPressed: nextItemInFocusChain(false).forceActiveFocus(Qt.TabFocusReason)
                Accessible.role: Accessible.MenuItem
                highlighted: checked || activeFocus
                onToggled: if (checked) {
                    item.triggered();
                }
            }

            ColumnLayout {
                spacing: 0
                width: scrollView.width
                PlaceItem {
                    id: goHomeButton
                    text: i18nc("Switch to the listing page showing the most recently read books", "Home");
                    icon.name: "go-home";
                    checked: true
                    QQC2.ButtonGroup.group: placeGroup
                }
                PlaceItem {
                    text: i18nc("Switch to the listing page showing the most recently discovered books", "Recently Added Books")
                    icon.name: "appointment-new";
                    QQC2.ButtonGroup.group: placeGroup
                }
                PlaceItem {
                    text: i18nc("Open a book from somewhere on disk (uses the open dialog, or a drilldown on touch devices)", "Open Other...")
                    icon.name: "document-open";
                    QQC2.ButtonGroup.group: null
                    checkable: false
                }

                PlaceItem {
                    text: i18nc("Open the settings page", "Settings")
                    icon.name: "configure"
                    action: Kirigami.Action {
                        fromQAction: application.action('options_configure')
                    }
                    QQC2.ButtonGroup.group: placeGroup
                    checkable: false
                    Layout.bottomMargin: Kirigami.Units.smallSpacing / 2
                }

                Kirigami.ListSectionHeader {
                    text: i18nc("Heading for switching to listing page showing items grouped by some properties", "Group By")
                }
                PlaceItem {
                    text: i18nc("Switch to the listing page showing items grouped by author", "Author");
                    icon.name: "actor";
                    QQC2.ButtonGroup.group: placeGroup
                }
                PlaceItem {
                    text: i18nc("Switch to the listing page showing items grouped by series", "Series");
                    icon.name: "edit-group";
                    QQC2.ButtonGroup.group: placeGroup
                }
                PlaceItem {
                    text: i18nc("Switch to the listing page showing items grouped by publisher", "Publisher");
                    icon.name: "view-media-publisher";
                    QQC2.ButtonGroup.group: placeGroup
                }
                PlaceItem {
                    text: i18nc("Switch to the listing page showing items grouped by genres", "Keywords");
                    icon.name: "tag";
                    QQC2.ButtonGroup.group: placeGroup
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
