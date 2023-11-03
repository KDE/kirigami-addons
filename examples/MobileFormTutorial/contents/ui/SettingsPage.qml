import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami
import org.kde.kirigamiaddons.formcard 1.0 as FormCard

FormCard.FormCardPage {

    FormCard.FormHeader {
        title: i18n("General")
    }

    FormCard.FormCard {
        FormCard.FormTextDelegate {
            text: i18n("Current Color Scheme")
            description: "Breeze"
        }
        FormCard.FormComboBoxDelegate {
            id: combobox
            text: i18n("Default Profile")
            description: i18n("The profile to be loaded by default.")
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
            text: i18n("Show Tray Icon")
            onToggled: {
                if (checkState) {
                    console.info("A tray icon appears on your system!")
                } else {
                    console.info("The tray icon disappears!")
                }
            }
        }
    }

    FormCard.FormHeader {
        title: i18n("Autosave")
    }

    FormCard.FormCard {
        FormCard.FormSwitchDelegate {
            id: autosave
            text: i18n("Enabled")
        }
        FormCard.FormDelegateSeparator {
            above: autosave
            below: firstradio
            visible: autosave.checked
        }
        FormCard.FormRadioDelegate {
            id: firstradio
            text: i18n("After every change")
            visible: autosave.checked
        }
        FormCard.FormRadioDelegate {
            text: i18n("Every 10 minutes")
            visible: autosave.checked
        }
        FormCard.FormRadioDelegate {
            text: i18n("Every 30 minutes")
            visible: autosave.checked
        }
    }

    FormCard.FormHeader {
        title: i18n("Accounts")
    }

    FormCard.FormCard {
        FormCard.FormSectionText {
            text: i18n("Online Account Settings")
        }
        FormCard.FormTextDelegate {
            id: lastaccount
            leading: Kirigami.Icon {source: "user"}
            text: "John Doe"
            description: i18n("The Maintainer ™️")
        }
        FormCard.FormDelegateSeparator {
            above: lastaccount
            below: addaccount
        }
        FormCard.FormButtonDelegate {
            id: addaccount
            icon.name: "list-add"
            text: i18n("Add a new account")
            onClicked: console.info("Clicked!")
        }
    }
}
