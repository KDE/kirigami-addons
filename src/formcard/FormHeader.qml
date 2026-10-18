/*
 * SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
 * SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard.templates as T

/*!
   \qmltype FormHeader
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A header item for a form card.

   \note The header should be placed above the card in a layout not as a child.
 */
T.FormHeader {
    topPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    bottomPadding: Kirigami.Units.smallSpacing
    leftPadding: cardWidthRestricted ? Kirigami.Units.smallSpacing : Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    rightPadding: cardWidthRestricted ? Kirigami.Units.smallSpacing : Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
}
