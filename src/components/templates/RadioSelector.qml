// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

/*!
   \qmltype RadioSelector
   \inqmlmodule org.kde.kirigamiaddons.components.templates
   \brief Shared actions, exclusive selection and layout for radio selectors.
 */
T.Control {
    id: root

    /*!
       \qmlproperty list<Action> actions
       \brief This property holds a list of actions, each holding one of the
       options.
     */
    property list<T.Action> actions

    /*!
       \brief This property holds whether all the items should have the same
       width.
       \default false
     */
    property bool consistentWidth: false

    /*!
       \brief This property holds the currently selected option.

       By default, it's the first actions or -1 if no actions is set.
     */
    property int selectedIndex: actions.length > 0 ? 0 : -1

    /*! The component used to display each option. */
    property Component delegate

    /*! The currently checked option button. */
    readonly property T.AbstractButton checkedButton: buttonGroup.checkedButton

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    Layout.fillWidth: consistentWidth
    Layout.minimumWidth: implicitWidth

    onSelectedIndexChanged: buttonGroup.checkedButton = selectedIndex >= 0 && selectedIndex < repeater.count
        ? repeater.itemAt(selectedIndex) : null

    QQC2.ButtonGroup {
        id: buttonGroup
        buttons: root.contentItem.children.filter(child => child instanceof T.AbstractButton)
    }

    contentItem: RowLayout {
        uniformCellSizes: root.consistentWidth
        spacing: root.spacing

        Repeater {
            id: repeater
            model: root.actions
            delegate: root.delegate
        }
    }
}
