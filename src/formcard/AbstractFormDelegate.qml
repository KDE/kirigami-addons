/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Templates as T
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import './private' as P

/*!
   \qmltype AbstractFormDelegate
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief A base item for delegates to be used in a FormCard.

   This component can be used to create your own custom FormCard delegates.

   By default, it includes a background with hover and click feedback.
   Set the \c background property to \c {Item {}} to remove it.

   \since 0.11.0

   \sa FormDelegateBackground
 */
T.ItemDelegate {
    id: root

    horizontalPadding: P.FormCardUnits.horizontalPadding
    verticalPadding: P.FormCardUnits.verticalPadding

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    focusPolicy: Qt.StrongFocus
    hoverEnabled: true
    // Todo change this to a property Item
    background: FormDelegateBackground { control: root }

    icon {
        width: Kirigami.Units.iconSizes.smallMedium
        height: Kirigami.Units.iconSizes.smallMedium
    }

    Layout.fillWidth: true
}

