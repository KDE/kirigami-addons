/*
    This file is part of the KDE libraries
    SPDX-FileCopyrightText: 1999 Reginald Stadlbauer <reggie@kde.org>
    SPDX-FileCopyrightText: 1999 Simon Hausmann <hausmann@kde.org>
    SPDX-FileCopyrightText: 2000 Nicolas Hadacek <haadcek@kde.org>
    SPDX-FileCopyrightText: 2000 Kurt Granroth <granroth@kde.org>
    SPDX-FileCopyrightText: 2000 Michael Koch <koch@kde.org>
    SPDX-FileCopyrightText: 2001 Holger Freyther <freyther@kde.org>
    SPDX-FileCopyrightText: 2002 Ellis Whitehead <ellis@kde.org>
    SPDX-FileCopyrightText: 2002 Joseph Wenninger <jowenn@kde.org>
    SPDX-FileCopyrightText: 2003 Andras Mantia <amantia@kde.org>
    SPDX-FileCopyrightText: 2005-2006 Hamish Rodda <rodda@kde.org>

    SPDX-License-Identifier: LGPL-2.0-only
*/

#include "kirigamitoggleaction.h"
#include "kirigamitoggleaction_p.h"
#include "kirigamiguiitem.h"

KirigamiToggleAction::KirigamiToggleAction(QObject *parent)
    : KirigamiToggleAction(*new KirigamiToggleActionPrivate(this), parent)
{
}

KirigamiToggleAction::KirigamiToggleAction(KirigamiToggleActionPrivate &dd, QObject *parent)
    : QAction(parent)
    , d_ptr(&dd)
{
    Q_D(KirigamiToggleAction);

    d->init();
}

KirigamiToggleAction::KirigamiToggleAction(const QString &text, QObject *parent)
    : QAction(parent)
    , d_ptr(new KirigamiToggleActionPrivate(this))
{
    Q_D(KirigamiToggleAction);

    setText(text);
    d->init();
}

KirigamiToggleAction::KirigamiToggleAction(const QIcon &icon, const QString &text, QObject *parent)
    : QAction(parent)
    , d_ptr(new KirigamiToggleActionPrivate(this))
{
    Q_D(KirigamiToggleAction);

    setIcon(icon);
    setText(text);
    d->init();
}

KirigamiToggleAction::~KirigamiToggleAction() = default;

void KirigamiToggleAction::setCheckedState(const KirigamiGuiItem &checkedItem)
{
    Q_D(KirigamiToggleAction);

    d->checkedGuiItem = std::make_unique<KirigamiGuiItem>(checkedItem);
}

void KirigamiToggleAction::slotToggled(bool)
{
    Q_D(KirigamiToggleAction);

    if (d->checkedGuiItem) {
        QString string = d->checkedGuiItem->text();
        d->checkedGuiItem->setText(text());
        setText(string);

        string = d->checkedGuiItem->toolTip();
        d->checkedGuiItem->setToolTip(toolTip());
        setToolTip(string);

        if (d->checkedGuiItem->hasIcon()) {
            QIcon icon = d->checkedGuiItem->icon();
            d->checkedGuiItem->setIcon(this->icon());
            QAction::setIcon(icon);
        }
    }
}

#include "moc_kirigamitoggleaction.cpp"
