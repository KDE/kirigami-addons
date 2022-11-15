/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.12 as Kirigami
import org.kde.kirigamiaddons.labs.mobileform 0.1 as MobileForm

Kirigami.ApplicationWindow {
    id: appwindow

    title: "Mobile Form Test"

    width: Kirigami.Settings.isMobile ? 400 : 800
    height: Kirigami.Settings.isMobile ? 550 : 500

    pageStack.defaultColumnWidth: Kirigami.Units.gridUnit * 35
    pageStack.globalToolBar.style: Kirigami.ApplicationHeaderStyle.ToolBar;
    pageStack.globalToolBar.showNavigationButtons: Kirigami.ApplicationHeaderStyle.ShowBackButton;

    pageStack.initialPage: pageComponent

    Component {
        id: pageComponent
        Kirigami.ScrollablePage {
            id: page
            title: "Mobile Form Layout"

            Kirigami.Theme.colorSet: Kirigami.Theme.Window
            Kirigami.Theme.inherit: false

            leftPadding: 0
            rightPadding: 0
            topPadding: Kirigami.Units.gridUnit
            bottomPadding: 0

            ColumnLayout {
                spacing: 0
                width: page.width

                MobileForm.FormCard {
                    Layout.fillWidth: true

                    contentItem: ColumnLayout {
                        spacing: 0

                        MobileForm.FormCardHeader {
                            title: "Buttons"
                        }

                        MobileForm.FormButtonDelegate {
                            id: delegate1
                            text: "Button"
                            onClicked: applicationWindow().pageStack.push(pageComponent)
                        }

                        MobileForm.FormDelegateSeparator { above: delegate1; below: delegate2 }

                        MobileForm.FormButtonDelegate {
                            id: delegate2
                            text: "Button 2"
                        }

                        MobileForm.FormDelegateSeparator { above: delegate2; below: delegate3 }

                        MobileForm.FormButtonDelegate {
                            id: delegate3
                            text: "Notification Settings"
                            icon.name: "notifications"
                        }
                    }
                }

                MobileForm.FormSectionText {
                    text: "Use cards to denote relevant groups of settings."
                }

                // checkboxes
                MobileForm.FormCard {
                    Layout.fillWidth: true
                    Layout.topMargin: Kirigami.Units.largeSpacing

                    contentItem: ColumnLayout {
                        spacing: 0

                        MobileForm.FormCardHeader {
                            title: "Checkboxes"
                        }

                        MobileForm.FormCheckDelegate {
                            id: checkbox1
                            text: "Check the first box"
                        }

                        MobileForm.FormCheckDelegate {
                            id: checkbox2
                            text: "Check the second box"
                        }

                        MobileForm.FormCheckDelegate {
                            id: checkbox3
                            text: "Check the third box"
                        }
                    }
                }

                // switches
                MobileForm.FormCard {
                    Layout.fillWidth: true
                    Layout.topMargin: Kirigami.Units.largeSpacing

                    contentItem: ColumnLayout {
                        spacing: 0

                        MobileForm.FormCardHeader {
                            title: "Switches"
                        }

                        MobileForm.FormSwitchDelegate {
                            id: switch1
                            text: "Toggle the first switch"
                        }

                        MobileForm.FormDelegateSeparator { above: switch1; below: switch2 }

                        MobileForm.FormSwitchDelegate {
                            id: switch2
                            text: "Toggle the second switch"
                        }

                        MobileForm.FormDelegateSeparator { above: switch2; below: switch3 }

                        MobileForm.FormSwitchDelegate {
                            id: switch3
                            text: "Toggle the third switch"
                            description: "This is a description for the switch."
                        }
                    }
                }

                // dropdowns
                // large amount of options -> push a new page
                // small amount of options -> open dialog
                MobileForm.FormCard {
                    Layout.fillWidth: true
                    Layout.topMargin: Kirigami.Units.largeSpacing

                    contentItem: ColumnLayout {
                        spacing: 0

                        MobileForm.FormCardHeader {
                            title: "Dropdowns"
                        }

                        MobileForm.FormComboBoxDelegate {
                            id: dropdown1
                            text: "Select a color"
                            Component.onCompleted: currentIndex = indexOfValue("Breeze Blue")
                            model: ["Breeze Blue", "Konqi Green", "Velvet Red", "Bright Yellow"]
                        }

                        MobileForm.FormDelegateSeparator { above: dropdown1; below: dropdown2 }

                        MobileForm.FormComboBoxDelegate {
                            id: dropdown2
                            text: "Select a shape"
                            Component.onCompleted: currentIndex = indexOfValue("Pentagon")
                            model: ["Circle", "Square", "Pentagon", "Triangle"]
                        }

                        MobileForm.FormDelegateSeparator { above: dropdown2; below: dropdown3 }

                        MobileForm.FormComboBoxDelegate {
                            id: dropdown3
                            text: "Select a time format"
                            description: "This will be used system-wide."
                            Component.onCompleted: currentIndex = indexOfValue("Use System Default")
                            model: ["Use System Default", "24 Hour Time", "12 Hour Time"]
                        }
                    }
                }

                // radio buttons
                MobileForm.FormCard {
                    Layout.fillWidth: true
                    Layout.topMargin: Kirigami.Units.largeSpacing

                    contentItem: ColumnLayout {
                        spacing: 0

                        MobileForm.FormCardHeader {
                            title: "Radio buttons"
                        }

                        MobileForm.FormRadioDelegate {
                            id: radio1
                            text: "Always on"
                        }

                        MobileForm.FormRadioDelegate {
                            id: radio2
                            text: "On during the day"
                        }

                        MobileForm.FormRadioDelegate {
                            id: radio3
                            text: "Always off"
                        }
                    }
                }

                // misc
                MobileForm.FormCard {
                    Layout.fillWidth: true
                    Layout.topMargin: Kirigami.Units.largeSpacing

                    contentItem: ColumnLayout {
                        spacing: 0

                        MobileForm.AbstractFormDelegate {
                            id: slider1
                            Layout.fillWidth: true

                            background: Item {}

                            contentItem: RowLayout {
                                spacing: Kirigami.Units.gridUnit
                                Kirigami.Icon {
                                    implicitWidth: Kirigami.Units.iconSizes.smallMedium
                                    implicitHeight: Kirigami.Units.iconSizes.smallMedium
                                    source: "brightness-low"
                                }

                                Controls.Slider {
                                    Layout.fillWidth: true
                                }

                                Kirigami.Icon {
                                    implicitWidth: Kirigami.Units.iconSizes.smallMedium
                                    implicitHeight: Kirigami.Units.iconSizes.smallMedium
                                    source: "brightness-high"
                                }
                            }
                        }

                        MobileForm.FormDelegateSeparator { above: slider1; below: textinput1 }

                        MobileForm.AbstractFormDelegate {
                            id: textinput1
                            Layout.fillWidth: true
                            contentItem: RowLayout {
                                Controls.Label {
                                    Layout.fillWidth: true
                                    text: "Enter text"
                                }

                                Controls.TextField {
                                    Layout.preferredWidth: Kirigami.Units.gridUnit * 8
                                    placeholderText: "Insert text…"
                                }
                            }
                        }

                        MobileForm.FormDelegateSeparator { above: textinput1; below: action1 }

                        MobileForm.AbstractFormDelegate {
                            id: action1
                            Layout.fillWidth: true
                            contentItem: RowLayout {
                                Controls.Label {
                                    Layout.fillWidth: true
                                    text: "Do an action"
                                }

                                Controls.Button {
                                    text: "Do Action"
                                    icon.name: "edit-clear-all"
                                }
                            }
                        }
                    }
                }

                // info block
                MobileForm.FormCard {
                    Layout.fillWidth: true
                    Layout.topMargin: Kirigami.Units.largeSpacing

                    contentItem: ColumnLayout {
                        spacing: 0

                        MobileForm.FormCardHeader {
                            title: "Information"
                        }

                        MobileForm.FormTextDelegate {
                            id: info1
                            text: "Color"
                            description: "Blue"
                        }

                        MobileForm.FormDelegateSeparator {}

                        MobileForm.FormTextDelegate {
                            id: info2
                            text: "Best Desktop Environment"
                            description: "KDE Plasma (Mobile)"
                        }

                        MobileForm.FormDelegateSeparator {}

                        MobileForm.FormTextDelegate {
                            id: info3
                            text: "Best Dragon"
                            description: "Konqi"
                        }

                        MobileForm.FormDelegateSeparator { above: info3; below: account }

                        MobileForm.FormTextFieldDelegate {
                            id: account
                            label: "Account name"
                        }

                        MobileForm.FormDelegateSeparator { above: account; below: password1 }

                        MobileForm.FormTextFieldDelegate {
                            id: password1
                            label: "Password"
                            statusMessage: "Password incorrect"
                            status: Kirigami.MessageType.Error
                            echoMode: TextInput.Password
                            text: "666666666"
                        }

                        MobileForm.FormDelegateSeparator { above: password1; below: password2 }

                        MobileForm.FormTextFieldDelegate {
                            id: password2
                            label: "Password"
                            statusMessage: "Password match"
                            text: "4242424242"
                            status: Kirigami.MessageType.Positive
                            echoMode: TextInput.Password
                        }
                    }
                }

                MobileForm.FormSectionText {
                    text: "Use the text form delegates to display information."
                }

                // TODO: "infinite" listview
            }
        }
    }
}

