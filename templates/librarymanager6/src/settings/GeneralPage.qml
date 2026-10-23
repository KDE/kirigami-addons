// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
// SPDX-License-Identifier: GPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.ki18n
import org.kde.kirigamiaddons.formcard as FormCard

FormCard.FormCardPage {
    id: root

    title: KI18n.i18nc("@title", "General")

    FormCard.FormHeader {
        title: KI18n.i18nc("@title:group", "My Group:")
    }

    FormCard.FormCard {
        FormCard.FormTextFieldDelegate {
            label: KI18n.i18nc("@label:textbox", "My Label:")
        }
    }
}
