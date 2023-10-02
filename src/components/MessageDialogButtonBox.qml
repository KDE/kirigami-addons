// SPDX-FileCopyrightText: 2023 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.19 as Kirigami

QQC2.DialogButtonBox {
    id: root

    padding: 1
    spacing: 1

    background: Kirigami.ShadowedRectangle {
        color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.3);

        corners {
            topLeftRadius: 0
            bottomLeftRadius: Kirigami.Units.mediumSpacing + 1

            bottomRightRadius: Kirigami.Units.mediumSpacing + 1
            topRightRadius: 0
        }
    }

    delegate: MessageDialogButton {
        buttonBox: root
    }
}
