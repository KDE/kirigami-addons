/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

/**
 * @brief A Form delegate that corresponds to a combobox.
 *
 * This component is used for individual settings that can have multiple
 * possible values shown in a vertical list, typically defined in a ::model.
 *
 * Many of its properties require familiarity with QtQuick.Controls.ComboBox.
 *
 * Use the inherited QtQuick.Controls.AbstractButton.text property to define
 * the main text of the combobox.
 *
 * If you need a purely on/off toggle, use a FormSwitchDelegate instead.
 *
 * If you need an on/off/tristate toggle, use a FormCheckDelegate instead.
 *
 * If you need multiple toggles instead of multiple values for the same
 * setting, consider using a FormRadioDelegate.
 *
 * @since org.kde.kirigamiaddons.labs.mobileform 0.1
 *
 * @see QtQuick.Controls.AbstractButton
 * @see FormSwitchDelegate
 * @see FormCheckDelegate
 * @see FormRadioDelegate
 *
 * @inherit AbstractFormDelegate
 */
AbstractFormDelegate {
    id: controlRoot

    /**
     * @brief This signal is emitted when the item at @p index is activated
     * by the user.
     */
    signal activated(int index)

    /**
     * @brief This signal is emitted when the Return or Enter key is pressed
     * while an editable combo box is focused.
     *
     * @see editable
     */
    signal accepted()

    /**
     * @brief A label that contains secondary text that appears under the
     * inherited text property.
     *
     * This provides additional information shown in a faint gray color.
     *
     * This is supposed to be a short text and the API user should avoid
     * making it longer than two lines.
     */
    property string description: ""

    /**
     * @brief This property holds the value of the current item in the combobox.
     */
    property alias currentValue: combobox.currentValue

    /**
     * @brief This property holds the text of the current item in the combobox.
     *
     * @see displayText
     */
    property alias currentText: combobox.currentText

    /**
     * @brief This property holds the model providing data for the combobox.
     *
     * @see displayText
     * @see QtQuick.Controls.ComboBox.model
     * @see <a href="https://doc.qt.io/qt-6/qtquick-modelviewsdata-modelview.html">Models and Views in QtQuick</a>
     */
    property var model

    /**
     * @brief This property holds the `textRole` of the internal combobox.
     *
     * @see QtQuick.Controls.ComboBox.textRole
     */
    property alias textRole: combobox.textRole

    /**
     * @brief This property holds the `valueRole` of the internal combobox.
     *
     * @see QtQuick.Controls.ComboBox.valueRole
     */
    property alias valueRole: combobox.valueRole

    /**
     * @brief This property holds the `currentIndex` of the internal combobox.
     *
     * default: `-1` when the ::model has no data, `0` otherwise
     *
     * @see QtQuick.Controls.ComboBox.currentIndex
     */
    property alias currentIndex: combobox.currentIndex

    /**
     * @brief This property holds the `highlightedIndex` of the internal combobox.
     *
     * @see QtQuick.Controls.ComboBox.highlightedIndex
     */
    property alias highlightedIndex: combobox.highlightedIndex

    /**
     * @brief This property holds the `displayText` of the internal combobox.
     *
     * This can be used to slightly modify the text to be displayed in the combobox, for instance, by adding a string with the ::currentText.
     *
     * @see QtQuick.Controls.ComboBox.displayText
     */
    property alias displayText: combobox.displayText

    /**
     * @brief This property holds the `editable` property of the internal combobox.
     *
     * This turns the combobox editable, allowing the user to specify
     * existing values or add new ones.
     *
     * Use this only when ::displayMode is set to
     * FormComboBoxDelegate.ComboBox.
     *
     * @see QtQuick.Controls.ComboBox.editable
     */
    property alias editable: combobox.editable

    /**
     * @brief This property holds the `editText` property of the internal combobox.
     *
     * @see QtQuick.Controls.ComboBox.editText
     */
    property alias editText: combobox.editText

    /** @brief The enum used to determine the ::displayMode. **/
    enum DisplayMode {
        /**
         * A standard combobox component containing a vertical list of values.
         */
        ComboBox,
        /**
         * A button with similar appearance to a combobox that, when clicked,
         * shows a Kirigami.OverlaySheet at the middle of the window
         * containing a vertical list of values.
         */
        Dialog,
        /**
         * A button with similar appearance to a combobox that, when clicked,
         * shows a Kirigami.ScrollablePage in a new window containing a
         * vertical list of values.
         */
        Page
    }

    /** 
     * @brief This property holds what display mode the delegate should show as.
     *
     * Set this property to the desired ::DisplayMode.
     *
     * default: `FormComboBoxDelegate.ComboBox`
     *
     * @see DisplayMode
     */
    property int displayMode: Kirigami.Settings.isMobile ? FormComboBoxDelegate.Dialog : FormComboBoxDelegate.ComboBox

    /**
     * @brief The delegate component to use as entries in the combobox display mode.
     */
    property Component comboBoxDelegate: QQC2.ItemDelegate {
        implicitWidth: ListView.view ? ListView.view.width : Kirigami.Units.gridUnit * 16
        text: controlRoot.textRole ? (Array.isArray(controlRoot.model) ? modelData[controlRoot.textRole] : model[controlRoot.textRole]) : modelData
        highlighted: controlRoot.highlightedIndex === index
        property bool separatorVisible: false
        Kirigami.Theme.colorSet: controlRoot.Kirigami.Theme.inherit ? controlRoot.Kirigami.Theme.colorSet : Kirigami.Theme.View
        Kirigami.Theme.inherit: controlRoot.Kirigami.Theme.inherit
    }

    /**
     * @brief The delegate component to use as entries for each value in the dialog and page display mode.
     */
    property Component dialogDelegate: QQC2.RadioDelegate {
        implicitWidth: ListView.view ? ListView.view.width : Kirigami.Units.gridUnit * 16
        text: controlRoot.textRole ? (Array.isArray(controlRoot.model) ? modelData[controlRoot.textRole] : model[controlRoot.textRole]) : modelData
        checked: controlRoot.currentIndex === index
        property bool separatorVisible: false
        Kirigami.Theme.colorSet: controlRoot.Kirigami.Theme.inherit ? controlRoot.Kirigami.Theme.colorSet : Kirigami.Theme.View
        Kirigami.Theme.inherit: controlRoot.Kirigami.Theme.inherit
        onClicked: {
            controlRoot.currentIndex = index;
            controlRoot.activated(index);
            controlRoot.closeDialog();
        }
    }

    /**
     * @brief Closes the dialog or layer.
     *
     * This function can be used when reimplementing the ::page or ::dialog.
     */
    function closeDialog() {
        if (_selectionPageItem) {
            _selectionPageItem.closeDialog();
            _selectionPageItem = null;
        }

        if (dialog) {
            dialog.close();
        }
    }

    property var _selectionPageItem: null
    property real __indicatorMargin: controlRoot.indicator && controlRoot.indicator.visible && controlRoot.indicator.width > 0 ? controlRoot.spacing + indicator.width + controlRoot.spacing : 0

    leftPadding: horizontalPadding + (!controlRoot.mirrored ? 0 : __indicatorMargin)
    rightPadding: horizontalPadding + (controlRoot.mirrored ? 0 : __indicatorMargin)


    // use connections instead of onClicked on root, so that users can supply
    // their own behaviour.
    Connections {
        target: controlRoot
        function onClicked() {
            if (controlRoot.displayMode === FormComboBoxDelegate.Dialog) {
                controlRoot.dialog.open();
            } else if (controlRoot.displayMode === FormComboBoxDelegate.Page) {
                controlRoot._selectionPageItem = applicationWindow().pageStack.pushDialogLayer(page)
            } else {
                combobox.popup.open();
            }
        }
    }

    /**
     * @brief The dialog component used for the combobox.
     * 
     * This property allows to override the internal dialog
     * with a custom component.
     */
    property var dialog: Kirigami.Dialog {
        id: dialog
        showCloseButton: false
        title: controlRoot.text
        preferredWidth: Kirigami.Units.gridUnit * 16

        ColumnLayout {
            spacing: 0

            Repeater {
                model: controlRoot.model
                delegate: controlRoot.dialogDelegate
            }

            QQC2.TextField {
                visible: controlRoot.editable
                onTextChanged: controlRoot.editText = text;
                Layout.fillWidth: true
            }
        }
    }

    /**
     * @brief The page component used for the combobox, if applicable.
     * 
     * This property allows to override the internal
     * Kirigami.ScrollablePage with a custom component.
     */
    property Component page: Kirigami.ScrollablePage {
        title: controlRoot.text

        ListView {
            spacing: 0
            model: controlRoot.model
            delegate: controlRoot.dialogDelegate

            footer: QQC2.TextField {
                visible: controlRoot.editable
                onTextChanged: controlRoot.editText = text;
                Layout.fillWidth: true
            }
        }
    }

    function indexOfValue(value) {
        return combobox.indexOfValue(value);
    }

    focusPolicy: Qt.StrongFocus
    Accessible.description: description

    contentItem: RowLayout {
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            QQC2.Label {
                Layout.fillWidth: true
                text: controlRoot.text
                elide: Text.ElideRight
                color: controlRoot.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                wrapMode: Text.Wrap
                maximumLineCount: 2
            }

            QQC2.Label {
                visible: controlRoot.description !== ""
                Layout.fillWidth: true
                text: controlRoot.description
                color: Kirigami.Theme.disabledTextColor
                wrapMode: Text.Wrap
            }
        }

        QQC2.Label {
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: Kirigami.Units.smallSpacing
            color: Kirigami.Theme.disabledTextColor
            text: controlRoot.displayText
            visible: controlRoot.displayMode === FormComboBoxDelegate.Dialog || controlRoot.displayMode === FormComboBoxDelegate.Page
        }

        QQC2.ComboBox {
            id: combobox
            focusPolicy: Qt.NoFocus // provided by parent
            model: controlRoot.model
            visible: controlRoot.displayMode == FormComboBoxDelegate.ComboBox
            delegate: controlRoot.comboBoxDelegate
            currentIndex: controlRoot.currentIndex
            onActivated: index => controlRoot.activated(index)
            onAccepted: controlRoot.accepted()
        }

        FormArrow {
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            direction: FormArrow.Down
            visible: controlRoot.displayMode === FormComboBoxDelegate.Dialog || controlRoot.displayMode === FormComboBoxDelegate.Page
        }
    }
}

