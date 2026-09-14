// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QObject>
#include <QPointer>
#include <qqmlregistration.h>

/*! \qmltype ActionContext
 * \inqmlmodule org.kde.kirigamiaddons.actions
 * \brief An activation scope for declarative actions.
 *
 * Action contexts allow actions declared in a global ActionCollection to be
 * active only while a page, document, or tool is active.
 */
class ActionContext : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(bool active READ active WRITE setActive NOTIFY activeChanged FINAL)
    Q_PROPERTY(bool contextActive READ contextActive NOTIFY contextActiveChanged FINAL)
    Q_PROPERTY(int priority READ priority WRITE setPriority NOTIFY priorityChanged FINAL)
    Q_PROPERTY(ActionContext *parentContext READ parentContext WRITE setParentContext NOTIFY parentContextChanged FINAL)

public:
    explicit ActionContext(QObject *parent = nullptr);

    bool active() const;
    void setActive(bool active);
    bool contextActive() const;
    int priority() const;
    void setPriority(int priority);
    ActionContext *parentContext() const;
    void setParentContext(ActionContext *parentContext);

Q_SIGNALS:
    void activeChanged();
    void contextActiveChanged();
    void priorityChanged();
    void parentContextChanged();

private Q_SLOTS:
    void updateContextActive();

private:
    void updateContextActive(bool notify);

    bool m_active = true;
    bool m_contextActive = true;
    int m_priority = 0;
    QPointer<ActionContext> m_parentContext;
    QMetaObject::Connection m_parentContextConnection;
};
