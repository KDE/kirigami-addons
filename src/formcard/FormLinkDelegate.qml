// SPDX-FileCopyrightText: 2025 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as Components
import org.kde.kirigamiaddons.formcard as FormCard

/*!
   \qmltype FormLinkDelegate
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A form delegate that contains a URL.

   It will open the url by default, allow to copy it if triggered with the
   secondary mouse button.

   \since 1.8.0
 */
FormCard.FormButtonDelegate {
    id: root

    /*!
       This property holds the url used by the form link delegate.
     */
    property string url

    Accessible.role: Accessible.Link

    trailingLogo.source: Application.layoutDirection === Qt.RightToLeft ? "open-link-symbolic-rtl" : "open-link-symbolic"
    visible: url.length > 0

    onClicked: Qt.openUrlExternally(url);
    onPressAndHold: {
        const menuItem = menu.createObject(root);
        menuItem.popup();
    }

    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: {
            const menuItem = menu.createObject(root);
            menuItem.popup(root.Controls.Overlay.overlay);
        }
    }

    Component {
        id: menu

        Components.ConvergentContextMenu {
            parent: root.Controls.Overlay.overlay

            Controls.Action {
                text: i18ndc("kirigamiaddons6", "@action:inmnenu", "Open Link")
                icon.name: "edit-copy-symbolic"
                onTriggered: Qt.openUrlExternally(root.url);
            }

            Controls.Action {
                text: i18ndc("kirigamiaddons6", "@action:inmnenu", "Copy Link to Clipboard")
                icon.name: "edit-copy-symbolic"
                onTriggered: {
                    FormCard.AboutComponent.copyTextToClipboard(root.url)
                    const application = root.Controls.ApplicationWindow.window as Kirigami.AbstractApplicationWindow;
                    if (application) {
                        application.showPassiveNotification(i18ndc("kirigamiaddons6", "@info:status", "Url copied to clipboard."))
                    }
                }
            }
        }
    }
}
