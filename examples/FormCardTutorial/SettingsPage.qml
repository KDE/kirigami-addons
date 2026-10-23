import QtQuick
import org.kde.ki18n
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

FormCard.FormCardPage {
    id: root

    title: KI18n.i18nc("@title", "Settings")

    FormCard.FormHeader {
        title: KI18n.i18nc("@title:group", "General")
    }

    FormCard.FormCard {
        FormCard.FormTextDelegate {
            text: KI18n.i18nc("@info", "Current Color Scheme")
            description: "Breeze"
        }

        FormCard.FormComboBoxDelegate {
            id: combobox
            text: KI18n.i18nc("@label:listbox", "Default Profile")
            description: KI18n.i18nc("@info:whatsthis", "The profile to be loaded by default.")
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
            text: KI18n.i18nc("@option:check", "Show Tray Icon")
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
        title: KI18n.i18nc("@title:group", "Autosave")
    }

    FormCard.FormCard {
        FormCard.FormSwitchDelegate {
            id: autosave
            text: KI18n.i18nc("@option:check", "Enabled")
        }
        FormCard.FormDelegateSeparator {
            above: autosave
            below: firstradio
            visible: autosave.checked
        }
        FormCard.FormRadioDelegate {
            id: firstradio
            text: KI18n.i18nc("@option:radio", "After every change")
            visible: autosave.checked
        }
        FormCard.FormRadioDelegate {
            text: KI18n.i18nc("@option:radio", "Every 10 minutes")
            visible: autosave.checked
        }
        FormCard.FormRadioDelegate {
            text: KI18n.i18nc("@option:radio", "Every 30 minutes")
            visible: autosave.checked
        }
    }

    FormCard.FormHeader {
        title: KI18n.i18nc("@title:group", "Accounts")
    }

    FormCard.FormCard {
        FormCard.FormSectionText {
            text: KI18n.i18nc("@info:whatsthis", "Online Account Settings")
        }
        FormCard.FormTextDelegate {
            id: lastaccount
            leading: Kirigami.Icon {source: "user"}
            text: "John Doe"
            description: KI18n.i18nc("@info:credit", "The Maintainer ™️")
        }
        FormCard.FormDelegateSeparator {
            above: lastaccount
            below: addaccount
        }
        FormCard.FormButtonDelegate {
            id: addaccount
            icon.name: "list-add"
            text: KI18n.i18nc("@action:button", "Add a new account")
            onClicked: console.info("Clicked!")
        }
    }
}
