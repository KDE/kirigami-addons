// SPDX-FileCopyrightText: 2025 Marco Martin <notmart@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "standardactiondata.h"

#include <KStandardShortcut>

StandardActionData::StandardActionData(QObject *parent)
    : ActionData(parent)
{
}

StandardActionData::StandardAction StandardActionData::standardAction() const
{
    return m_standardAction;
}

void StandardActionData::setStandardAction(StandardAction action)
{
    if (m_standardAction == action) {
        return;
    }
    m_standardAction = action;
    const auto standard = static_cast<KStandardActions::StandardAction>(action);
    setName(KStandardActions::name(standard));
    auto source = KStandardActions::_kgui_createInternal(standard, this);
    if (source) {
        setText(source->text());
        setToolTip(source->toolTip());
        setIcon(source->icon());
        setDefaultShortcut(source->shortcut());
        delete source;
    }
    Q_EMIT standardActionChanged();
}

#include "moc_standardactiondata.cpp"
