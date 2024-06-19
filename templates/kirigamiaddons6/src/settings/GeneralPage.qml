// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
// SPDX-License-Identifier: GPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigamiaddons.formcard as FormCard

FormCard.FormCardPage {
    id: root

    title: i18nc("@title", "General")

    FormCard.FormHeader {
        title: i18nc("@title:group", "My Group")
    }

    FormCard.FormHeader {
        title: i18nc("@title:group", "My Group:")
    }

    FormCard.FormCard {
        FormCard.FormTextFieldDelegate {
            label: i18nc("@label:textbox", "My Label:")
        }
    }
}
