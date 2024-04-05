import QtQuick 2.15
import org.kde.kirigami 2.20 as Kirigami
import org.kde.kirigamiaddons.formcard 1.0 as FormCard

FormCard.FormPage {
    title: i18nc("@title", "Settings")

    FormCard.FormGroup {
        title: i18nc("@title:group", "General")

        FormCard.FormTextDelegate {
            text: i18nc("@info", "Current Color Scheme")
            description: "Breeze"
        }

        FormCard.FormComboBoxDelegate {
            id: combobox
            text: i18nc("@label:listbox", "Default Profile")
            description: i18nc("@info:whatsthis", "The profile to be loaded by default.")
            displayMode: FormCard.FormComboBoxDelegate.ComboBox
            currentIndex: 0
            editable: false
            model: ["Work", "Personal"]
        }

        FormCard.FormDelegateSeparator {
            above: combobox
            below: checkbox
        }

        FormCard.FormCheckDelegate {
            id: checkbox
            text: i18nc("@option:check", "Show Tray Icon")
            onToggled: {
                if (checkState) {
                    console.info("A tray icon appears on your system!")
                } else {
                    console.info("The tray icon disappears!")
                }
            }
        }
    }

    FormCard.FormGroup {
        title: i18nc("@title:group", "Autosave")

        FormCard.FormSwitchDelegate {
            id: autosave
            text: i18nc("@option:check", "Enabled")
        }
        FormCard.FormDelegateSeparator {
            above: autosave
            below: firstradio
            visible: autosave.checked
        }
        FormCard.FormRadioDelegate {
            id: firstradio
            text: i18nc("@option:radio", "After every change")
            visible: autosave.checked
        }
        FormCard.FormRadioDelegate {
            text: i18nc("@option:radio", "Every 10 minutes")
            visible: autosave.checked
        }
        FormCard.FormRadioDelegate {
            text: i18nc("@option:radio", "Every 30 minutes")
            visible: autosave.checked
        }
    }

    FormCard.FormGroup {
        title: i18nc("@title:group", "Accounts")

        FormCard.FormSectionText {
            text: i18nc("@info:whatsthis", "Online Account Settings")
        }
        FormCard.FormTextDelegate {
            id: lastaccount
            leading: Kirigami.Icon {source: "user"}
            text: "John Doe"
            description: i18nc("@info:credit", "The Maintainer ™️")
        }
        FormCard.FormDelegateSeparator {
            above: lastaccount
            below: addaccount
        }
        FormCard.FormButtonDelegate {
            id: addaccount
            icon.name: "list-add"
            text: i18nc("@action:button", "Add a new account")
            onClicked: console.info("Clicked!")
        }
    }
}
