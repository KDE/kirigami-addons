/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.20 as Kirigami
import org.kde.kirigamiaddons.formcard 1.0 as FormCard
import org.kde.kirigamiaddons.components 1.0 as Components

Kirigami.ApplicationWindow {
    id: appwindow

    title: "Form Card Example"

    width: Kirigami.Settings.isMobile ? 400 : 800
    height: Kirigami.Settings.isMobile ? 550 : 500

    pageStack.defaultColumnWidth: Kirigami.Units.gridUnit * 35
    pageStack.globalToolBar.style: Kirigami.ApplicationHeaderStyle.ToolBar;
    pageStack.globalToolBar.showNavigationButtons: Kirigami.ApplicationHeaderStyle.ShowBackButton;

    pageStack.initialPage: pageComponent
    // Dummy implementation of ki18n
    function i18nd(context, text) {
        return text;
    }

    function i18ndp(context, text1, text2, number) {
        return number === 1 ? text1 : text2;
    }

    function i18nc(context, text) {
        return text;
    }

    function i18ndc(context, strng, text) {
        return text;
    }

    LayoutMirroring.enabled: false

    FormCard.FormDialog {
        id: formDialog

        title: "Add Thingy"

        standardButtons: Controls.Dialog.Ok | Controls.Dialog.Cancel

        FormCard.FormTextFieldDelegate {
            label: i18nc("@label:textbox Notebook name", "Name:")
        }

        FormCard.FormDelegateSeparator {}

        FormCard.FormButtonDelegate {
            text: i18nc("@action:button", "Color")
            icon.name: "color-picker"
        }

        FormCard.FormDelegateSeparator {}

        FormCard.FormButtonDelegate {
            text: i18nc("@action:button", "Icon")
            icon.name: "preferences-desktop-emoticons"
        }
    }

    Component {
        id: aboutComponent
        FormCard.AboutPage {
            aboutData: {
                "displayName": "KirigamiApp",
               "productName" : "kirigami/app",
               "componentName" : "kirigamiapp",
               "shortDescription" : "A Kirigami example",
               "homepage" : "",
               "bugAddress" : "submit@bugs.kde.org",
               "version" : "5.14.80",
               "otherText" : "",
               "authors" : [
                   {
                       "name" : "Paul Müller",
                       "task" : "Concept and development",
                       "emailAddress" : "somebody@kde.org",
                       "webAddress" : "",
                       "ocsUsername" : ""
                   }
               ],
               "credits" : [],
               "translators" : [],
               "licenses" : [
                   {
                       "name" : "GPL v2",
                       "text" : "long, boring, license text",
                       "spdx" : "GPL-2.0"
                   }
               ],
               "copyrightStatement" : "© 2010-2018 Plasma Development Team",
               "desktopFileName" : "org.kde.kirigamiapp"
           }
        }
    }

    Component {
        id: pageComponent
        FormCard.FormCardPage {
            id: page
            title: "Mobile Form Layout"

            // Form Grid
            FormCard.FormGridContainer {
                id: container

                Layout.fillWidth: true
                Layout.topMargin: Kirigami.Units.gridUnit

                infoCards: [
                    FormCard.FormGridContainer.InfoCard {
                        title: "42"
                        subtitle: "Posts"
                    },
                    FormCard.FormGridContainer.InfoCard {
                        title: "42"
                        subtitle: "Followers"
                    },
                    FormCard.FormGridContainer.InfoCard {
                        title: "42"
                        subtitle: "Follows"
                        action: Kirigami.Action {
                            onTriggered: applicationWindow().showPassiveNotification("42 Follows")
                        }
                    }
                ]
            }

            FormCard.FormHeader {
                title: "About"
            }
            FormCard.FormCard {
                FormCard.FormButtonDelegate {
                    id: aboutDelegate
                    text: "About"
                    onClicked: applicationWindow().pageStack.push(aboutComponent)
                }
            }

            FormCard.FormHeader {
                title: "Date and time"
            }

            FormCard.FormCard {
                FormCard.FormDateTimeDelegate {}

                FormCard.FormDelegateSeparator {}

                FormCard.FormDateTimeDelegate {
                    text: "Arrival day:"
                    minimumDate: new Date()
                    dateTimeDisplay: FormCard.FormDateTimeDelegate.DateTimeDisplay.Date
                }

                FormCard.FormDelegateSeparator {}

                FormCard.FormDateTimeDelegate {
                    text: "Arrival time:"
                    dateTimeDisplay: FormCard.FormDateTimeDelegate.DateTimeDisplay.Time
                    status: Kirigami.MessageType.Warning
                    statusMessage: value.getHours() < 8 ? "Very early!" : ""
                }
            }

            FormCard.FormHeader {
                title: "Buttons"
            }
            FormCard.FormCard {
                Layout.fillWidth: true

                FormCard.FormButtonDelegate {
                    id: delegate1
                    text: "Button"
                    description: "Click me!"
                    onClicked: applicationWindow().pageStack.push(pageComponent)
                }

                FormCard.FormDelegateSeparator { above: delegate1; below: delegate2 }

                FormCard.FormButtonDelegate {
                    id: delegate2
                    text: "Form Dialog"
                    onClicked: formDialog.open()
                }

                FormCard.FormDelegateSeparator { above: delegate2; below: delegate3 }

                FormCard.FormButtonDelegate {
                    id: delegate3
                    text: "Notification Settings"
                    icon.name: "notifications"
                }
            }

            FormCard.FormSectionText {
                text: "The form components support keyboard navigation with Tab and Shift+Tab."
            }

            // checkboxes
            FormCard.FormHeader {
                title: "Checkboxes"
            }
            FormCard.FormCard {
                FormCard.FormCheckDelegate {
                    id: checkbox1
                    text: "Check the first box"
                }

                FormCard.FormGroup {
                    Layout.fillWidth: true
                    title: "Buttons"

                    FormCard.FormButtonDelegate {
                        id: delegate1
                        text: "Button"
                        description: "Click me!"
                        onClicked: applicationWindow().pageStack.push(pageComponent)
                    }

                    FormCard.FormDelegateSeparator { above: delegate1; below: delegate2 }

                    FormCard.FormButtonDelegate {
                        id: delegate2
                        text: "Form Dialog"
                        onClicked: formDialog.open()
                    }

                    FormCard.FormDelegateSeparator { above: delegate2; below: delegate3 }

                    FormCard.FormButtonDelegate {
                        id: delegate3
                        text: "Notification Settings"
                        icon.name: "notifications"
                    }
                }

                FormCard.FormCheckDelegate {
                    id: checkbox3
                    text: "Check the third box"
                }
            }
            
            FormCard.FormSectionText {
                text: "Use cards to denote relevant groups of settings."
            }

            // switches
            FormCard.FormHeader {
                title: "Switches"
            }
            FormCard.FormCard {
                FormCard.FormSwitchDelegate {
                    id: switch1
                    text: "Toggle the first switch"
                }

                // checkboxes
                FormCard.FormGroup {
                    title: "Checkboxes"

                    FormCard.FormCheckDelegate {
                        id: checkbox1
                        text: "Check the first box"
                    }

                FormCard.FormDelegateSeparator { above: switch2; below: switch3 }

                FormCard.FormSwitchDelegate {
                    id: switch3
                    text: "Toggle the third switch"
                    description: "This is a description for the switch."
                }
                
                FormCard.FormDelegateSeparator { above: switch3; below: layoutMirroring }

                FormCard.FormSwitchDelegate {
                    id: layoutMirroring
                    text: "Layout mirroring"
                    description: "Toggle layout mirroring to test flipped layouts."
                    onCheckedChanged: {
                        applicationWindow().LayoutMirroring.enabled = checked;
                    }
                }
            }

            // dropdowns
            // large amount of options -> push a new page
            // small amount of options -> open dialog
            FormCard.FormHeader {
                title: "Dropdowns"
            }
            FormCard.FormCard {
                FormCard.FormComboBoxDelegate {
                    id: dropdown1
                    text: "Select a color"
                    Component.onCompleted: currentIndex = indexOfValue("Breeze Blue")
                    model: ["Breeze Blue", "Konqi Green", "Velvet Red", "Bright Yellow"]
                }

                FormCard.FormDelegateSeparator { above: dropdown1; below: dropdown2 }

                FormCard.FormComboBoxDelegate {
                    id: dropdown2
                    text: "Select a shape"
                    Component.onCompleted: currentIndex = indexOfValue("Pentagon")
                    model: ["Circle", "Square", "Pentagon", "Triangle"]
                }

                FormCard.FormDelegateSeparator { above: dropdown2; below: dropdown3 }

                FormCard.FormComboBoxDelegate {
                    id: dropdown3
                    text: "Select a time format"
                    description: "This will be used system-wide."
                    Component.onCompleted: currentIndex = indexOfValue("Use System Default")
                    model: ["Use System Default", "24 Hour Time", "12 Hour Time"]
                }

                FormCard.FormDelegateSeparator { above: dropdown3; below: dropdown4 }

                FormCard.FormComboBoxDelegate {
                    id: dropdown4
                    text: "Select a color (page)"
                    displayMode: FormCard.FormComboBoxDelegate.DisplayMode.Page
                    Component.onCompleted: currentIndex = indexOfValue("Breeze Blue")
                    model: ["Breeze Blue", "Konqi Green", "Velvet Red", "Bright Yellow"]
                }
            }

            // radio buttons
            FormCard.FormHeader {
                title: "Radio buttons"
            }
            FormCard.FormCard {
                FormCard.FormRadioDelegate {
                    id: radio1
                    text: "Always on"
                }

                FormCard.FormRadioDelegate {
                    id: radio2
                    text: "On during the day"
                }

                FormCard.FormRadioDelegate {
                    id: radio3
                    text: "Always off"
                }
            }

            // misc
            FormCard.FormCard {
                Layout.topMargin: Kirigami.Units.largeSpacing

                FormCard.AbstractFormDelegate {
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

                FormCard.FormDelegateSeparator { below: textinput1 }

                FormCard.AbstractFormDelegate {
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

                FormCard.FormDelegateSeparator { above: textinput1; below: action1 }

                FormCard.AbstractFormDelegate {
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

            // info block
            FormCard.FormHeader {
                title: "Information"
            }
            FormCard.FormCard {
                FormCard.FormTextDelegate {
                    id: info1
                    text: "Color"
                    description: "Blue"
                }

                FormCard.FormDelegateSeparator {}

                FormCard.FormTextDelegate {
                    id: info2
                    text: "Best Desktop Environment"
                    description: "KDE Plasma (Mobile)"
                }

                FormCard.FormDelegateSeparator {}

                FormCard.FormTextDelegate {
                    id: info3
                    text: "Best Dragon"
                    description: "Konqi"
                    trailing: Controls.Button {
                        text: "Agree"
                        icon.name: "dialog-ok"
                    }
                }
            }

            FormCard.FormSectionText {
                text: "Use the text form delegates to display information."
            }

            // text fields
            FormCard.FormHeader {
                title: "Text Fields"
            }

            FormCard.FormCard {
                FormCard.FormTextFieldDelegate {
                    id: account
                    label: "Account name"
                }

                FormCard.FormDelegateSeparator {}

                FormCard.FormPasswordFieldDelegate {
                    id: password1
                    label: "Password"
                    statusMessage: "Password incorrect"
                    status: Kirigami.MessageType.Error
                    echoMode: TextInput.Password
                    text: "666666666"
                    showPasswordQuality: true
                }

                FormCard.FormDelegateSeparator {}

                FormCard.FormPasswordFieldDelegate {
                    id: password2
                    label: "Password"
                    statusMessage: "Password match"
                    text: "4242424242"
                    status: Kirigami.MessageType.Positive
                    echoMode: TextInput.Password
                }
            }

            // spin boxes fields
            FormCard.FormHeader {
                title: "Spin boxes"
            }
            FormCard.FormCard {
                FormCard.FormSpinBoxDelegate {
                    label: "Amount"
                    value: 42
                }

                FormCard.FormDelegateSeparator {}

                FormCard.FormSpinBoxDelegate {
                    label: "Amount 2"
                    value: 84
                    statusMessage: "This is too high"
                    status: Kirigami.MessageType.Error
                }
            }
        }
    }
}

