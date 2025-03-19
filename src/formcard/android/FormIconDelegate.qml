// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts

import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kirigami as Kirigami

/**
  \brief A FormCard delegate for icons.
 
  Allow users to select icons. By default "Icon" is the default label
  but this can be overwritten with the `text` property.
 
  \code{qml}
  FormCard.FormCard {
      FormCard.FormIconDelegate {}
 
      FormCard.FormDelegateSeparator {}
 
      FormCard.FormIconDelegate {
          text: i18nc("@label", "Active icon")
          iconName: "actor-symbolic"
      }
  }
  \endcode
  \image html formcardicon.png
 
  \note This element is readonly on Android.
 
  \since 1.8.0
 */
FormCard.AbstractFormDelegate {
    id: root

    /**
     * This property holds the name of the selected icon.
     */
    property alias iconName: buttonIcon.source

    text: i18nc("@action:button", "Icon")
    icon.name: "preferences-desktop-emoticons-symbolic"
    onClicked: iconDialog.open()

    background: null
    contentItem: RowLayout {
        spacing: 0

        Kirigami.Icon {
            source: root.icon.name
            Layout.rightMargin: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
            implicitWidth: Kirigami.Units.iconSizes.small
            implicitHeight: Kirigami.Units.iconSizes.small
        }

        Controls.Label {
            Layout.fillWidth: true
            text: iconButton.text
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            maximumLineCount: 2
            Accessible.ignored: true // base class sets this text on root already
        }

        Kirigami.Icon {
            id: buttonIcon

            source: "addressbook-details-symbolic"
            Layout.preferredWidth: Kirigami.Units.iconSizes.small
            Layout.preferredHeight: Kirigami.Units.iconSizes.small
            Layout.rightMargin: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
        }
    }
}
