// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "actioncontext.h"

ActionContext::ActionContext(QObject *parent)
    : QObject(parent)
{
    updateContextActive(false);
}

bool ActionContext::active() const
{
    return m_active;
}

void ActionContext::setActive(bool active)
{
    if (m_active == active) {
        return;
    }
    m_active = active;
    Q_EMIT activeChanged();
    updateContextActive(true);
}

bool ActionContext::contextActive() const
{
    return m_contextActive;
}

int ActionContext::priority() const
{
    return m_priority;
}

void ActionContext::setPriority(int priority)
{
    if (m_priority == priority) {
        return;
    }
    m_priority = priority;
    Q_EMIT priorityChanged();
}

ActionContext *ActionContext::parentContext() const
{
    return m_parentContext.data();
}

void ActionContext::setParentContext(ActionContext *parentContext)
{
    if (m_parentContext == parentContext) {
        return;
    }
    QObject::disconnect(m_parentContextConnection);
    m_parentContext = parentContext;
    if (m_parentContext) {
        m_parentContextConnection = connect(m_parentContext, &ActionContext::contextActiveChanged, this, [this]() {
            updateContextActive();
        });
    }
    Q_EMIT parentContextChanged();
    updateContextActive(true);
}

void ActionContext::updateContextActive()
{
    updateContextActive(true);
}

void ActionContext::updateContextActive(bool notify)
{
    const bool contextActive = m_active && (!m_parentContext || m_parentContext->contextActive());
    if (m_contextActive == contextActive) {
        return;
    }
    m_contextActive = contextActive;
    if (notify) {
        Q_EMIT contextActiveChanged();
    }
}
