import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.20 as Kirigami
import org.kde.kirigamiaddons.formcard 1.0 as FormCard

import org.kde.about 1.0

Kirigami.ApplicationWindow {
    id: root
    width: 600
    height: 700

    Component {
        id: aboutkde
        FormCard.AboutKDE {}
    }

    Component {
        id: aboutpage
        MyAboutPage {}
    }

    Component {
        id: settingspage
        SettingsPage {}
    }

    pageStack.initialPage: Kirigami.ScrollablePage {
        ColumnLayout {
            FormCard.FormCard {
                FormCard.FormButtonDelegate {
                    id: aboutKDEButton
                    icon.name: "kde"
                    text: i18nc("@action:button", "About KDE Page")
                    onClicked: root.pageStack.layers.push(aboutkde)
                }

                FormCard.FormDelegateSeparator {
                    above: aboutKDEButton
                    below: aboutPageButton
                }

                FormCard.FormButtonDelegate {
                    id: aboutPageButton
                    icon.name: "applications-utilities"
                    text: i18nc("@action:button", "About Addons Example")
                    onClicked: root.pageStack.layers.push(aboutpage)
                }

                FormCard.FormDelegateSeparator {
                    above: aboutPageButton
                    below: settingsButton
                }

                FormCard.FormButtonDelegate {
                    id: settingsButton
                    icon.name: "settings-configure"
                    text: i18nc("@action:button", "Single Settings Page")
                    onClicked: root.pageStack.layers.push(settingspage)
                }
            }
        }
    }
}
