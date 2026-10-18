/*
 * SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard.templates as T

import "private" as Private

/*!
   \qmltype FormCard
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A single card that follows a form style.

   This is the entrypoint component for FormCard.

   A FormCard consists of a container that can be used to create your
   own Settings pages. It has a different color than the background.

   Each FormCard can contain one or more Form delegates in its contentItem.
   To add more than one Form delegate to a FormCard, use a
   ColumnLayout to group them.

   Multiple FormCards can be grouped with a ColumnLayout to
   represent different Settings sections.

   Each section is expected to contain a FormHeader as the first
   delegate, which serves the role of a section title.

   The height of the FormCard matches the implicit height of the
   contentItem and does not need to be set, while the width is expected
   to be given by the parent, for example, via a \l {Layout::fillWidth} {Layout.fillWidth}.

   \since 0.11.0
 */
T.FormCard {
    id: root

    borderWidth: 1
    cornerRadius: cardWidthRestricted ? Kirigami.Units.cornerRadius : 0

    background: Private.FormCardBackground {
        rounded: root.cardWidthRestricted
        radius: root.cornerRadius
        border.width: root.borderWidth
    }
}
