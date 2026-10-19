/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard.templates as T

import "../../private" as Private

T.FormHeader {
    _horizontalInset: Kirigami.Units.largeSpacing

    topPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    bottomPadding: Kirigami.Units.smallSpacing
    leftPadding: Private.FormCardUnits.horizontalPadding
    rightPadding: Private.FormCardUnits.horizontalPadding
}
