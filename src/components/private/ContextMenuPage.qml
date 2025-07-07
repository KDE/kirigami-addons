// SPDX-FileCopyrightText: 2024 Joshua Goins <josh@redstrate.com>
// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Controls as T
import QtQuick.Layouts
import Qt.labs.qmlmodels

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as KirigamiComponents
import org.kde.kirigamiaddons.formcard as FormCard

QQC2.ScrollView {
    id: root

    required property list<T.Action> actions
    required property T.StackView stackView
    required property KirigamiComponents.BottomDrawer drawer
    property string title

    Layout.fillWidth: true

    property Component itemDelegate: FormCard.FormButtonDelegate {
        id: button

        required property T.Action modelData

        action: modelData
        visible: modelData.visible === undefined || modelData.visible

        leading: RowLayout {
            spacing: 0
            visible: modelData.checkable

            QQC2.CheckBox {
                id: checkBoxItem

                focusPolicy: Qt.NoFocus // provided by delegate
                visible: !(modelData instanceof Kirigami.Action) || !modelData.autoExclusive

                action: modelData

                topPadding: 0
                leftPadding: 0
                rightPadding: 0
                bottomPadding: 0

                contentItem: null // Remove right margin
                spacing: 0

                Accessible.ignored: true
            }

            QQC2.RadioButton {
                id: radioBoxItem

                focusPolicy: Qt.NoFocus // provided by delegate
                visible: modelData instanceof Kirigami.Action && modelData.autoExclusive

                action: modelData

                topPadding: 0
                leftPadding: 0
                rightPadding: 0
                bottomPadding: 0

                contentItem: null // Remove right margin
                spacing: 0

                Accessible.ignored: true
            }
        }

        Binding {
            when: !(modelData instanceof Kirigami.Action) || modelData.children.length === 0
            target: button.trailingLogo
            property: "source"
            value: ""
        }

        onClicked: {
            if (modelData instanceof Kirigami.Action && modelData.children.length > 0) {
                root.stackView.push(Qt.resolvedUrl('./ContextMenuPage.qml'), {
                    stackView: root.stackView,
                    actions: modelData.children,
                    title: modelData.text,
                    drawer: root.drawer,
                });
                return;
            }
            drawer.close();
        }
    }
    property Component separatorDelegate: FormCard.FormDelegateSeparator {
        property T.Action action
        visible: !(action instanceof Kirigami.Action) || action.visible
    }
    property Component loaderDelegate: Loader {
        property T.Action action
        Layout.fillWidth: item?.Layout.fillWidth ?? true
    }

    Instantiator {
        id: actionsInstantiator

        model: root.actions
        delegate: QtObject {
            id: delegate

            required property T.Action modelData
            readonly property T.Action action: modelData

            property QtObject item: null

            Component.onCompleted: {
                const isKirigamiAction = delegate.action instanceof Kirigami.Action;
                if (isKirigamiAction && delegate.action.separator) {
                    item = root.separatorDelegate.createObject(null, { action: delegate.action });
                } else if (delegate.action.displayComponent) {
                    item = root.loaderDelegate.createObject(null, {
                        actions: delegate.action,
                        sourceComponent: action.displayComponent,
                    });
                } else {
                    item = root.itemDelegate.createObject(null, { modelData: delegate.action });
                }
                columnLayout.children.push(item);
            }
        }
    }

    ColumnLayout {
        id: columnLayout

        width: root.availableWidth
        spacing: 0
    }
}
