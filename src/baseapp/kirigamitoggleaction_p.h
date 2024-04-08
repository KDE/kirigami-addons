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

#ifndef KTOGGLEACTION_P_H
#define KTOGGLEACTION_P_H

#include "kirigamitoggleaction.h"

class KirigamiToggleActionPrivate
{
    Q_DECLARE_PUBLIC(KirigamiToggleAction)

public:
    explicit KirigamiToggleActionPrivate(KirigamiToggleAction *qq)
        : q_ptr(qq)
    {
    }

    virtual ~KirigamiToggleActionPrivate() = default;

    void init()
    {
        Q_Q(KirigamiToggleAction);

        q->setCheckable(true);
        QObject::connect(q, &QAction::toggled, q, &KirigamiToggleAction::slotToggled);
    }

    KirigamiToggleAction *const q_ptr;
    std::unique_ptr<KirigamiGuiItem> checkedGuiItem = nullptr;
};

#endif
