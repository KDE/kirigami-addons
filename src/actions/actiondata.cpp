// SPDX-FileCopyrightText: 2025 Marco Martin <notmart@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "actiondata.h"
#include "actioncontext.h"
#include "kirigamiactioncollection.h"

#include <QKeySequence>
#include <QQmlProperty>

static QKeySequence variantToKeySequence(const QVariant &variant)
{
    if (variant.metaType().id() == QMetaType::Int) {
        return QKeySequence(static_cast<QKeySequence::StandardKey>(variant.toInt()));
    }
    if (variant.metaType().id() == QMetaType::QKeySequence) {
        return variant.value<QKeySequence>();
    }
    return QKeySequence::fromString(variant.toString());
}

ActionGroup::ActionGroup(QObject *parent)
    : QActionGroup(parent)
{
}

class IconGroupPrivate
{
public:
    ActionData *m_actionData = nullptr;
    QString m_name;
    QString m_source;
    qreal m_width = -1;
    qreal m_height = -1;
    QColor m_color = Qt::transparent;
    bool m_cache = true;
};

IconGroup::IconGroup(ActionData *parent)
    : QObject(parent)
    , d(std::make_unique<IconGroupPrivate>())
{
    d->m_actionData = parent;
}

IconGroup::~IconGroup()
{
}

QString IconGroup::name() const
{
    return d->m_name;
}

void IconGroup::setName(const QString &name)
{
    if (d->m_name == name) {
        return;
    }
    d->m_name = name;
    if (d->m_actionData) {
        d->m_actionData->setIcon(QIcon::fromTheme(name));
    }
    if (d->m_actionData && d->m_actionData->action()) {
        QQmlProperty property(d->m_actionData->action(), QStringLiteral("icon.name"));
        property.write(name);
    }
    Q_EMIT nameChanged();
}

QString IconGroup::source() const
{
    return d->m_source;
}

void IconGroup::setSource(const QString &source)
{
    if (d->m_source == source) {
        return;
    }
    d->m_source = source;
    if (d->m_actionData && d->m_actionData->action()) {
        QQmlProperty property(d->m_actionData->action(), QStringLiteral("icon.source"));
        property.write(source);
    }
    Q_EMIT sourceChanged();
}

qreal IconGroup::width() const
{
    return d->m_width;
}

void IconGroup::setWidth(qreal width)
{
    if (qFuzzyCompare(d->m_width, width)) {
        return;
    }
    d->m_width = width;
    if (d->m_actionData && d->m_actionData->action()) {
        QQmlProperty property(d->m_actionData->action(), QStringLiteral("icon.width"));
        property.write(width);
    }
    Q_EMIT widthChanged();
}

qreal IconGroup::height() const
{
    return d->m_height;
}

void IconGroup::setHeight(qreal height)
{
    if (qFuzzyCompare(d->m_height, height)) {
        return;
    }
    d->m_height = height;
    if (d->m_actionData && d->m_actionData->action()) {
        QQmlProperty property(d->m_actionData->action(), QStringLiteral("icon.height"));
        property.write(height);
    }
    Q_EMIT heightChanged();
}

QColor IconGroup::color() const
{
    return d->m_color;
}

void IconGroup::setColor(const QColor &color)
{
    if (d->m_color == color) {
        return;
    }
    d->m_color = color;
    if (d->m_actionData && d->m_actionData->action()) {
        QQmlProperty property(d->m_actionData->action(), QStringLiteral("icon.color"));
        property.write(color);
    }
    Q_EMIT colorChanged();
}

bool IconGroup::cache() const
{
    return d->m_cache;
}

void IconGroup::setCache(bool cache)
{
    if (d->m_cache == cache) {
        return;
    }
    d->m_cache = cache;
    if (d->m_actionData && d->m_actionData->action()) {
        QQmlProperty property(d->m_actionData->action(), QStringLiteral("icon.cache"));
        property.write(cache);
    }
    Q_EMIT cacheChanged();
}

ActionData::ActionData(QObject *parent)
    : QAction(parent)
    , m_icon(new IconGroup(this))
{
    connect(this, &QAction::changed, this, [this]() {
        if (m_icon->name().isEmpty() && !QAction::icon().name().isEmpty()) {
            m_icon->setName(QAction::icon().name());
        }
        syncAction();
    });
    connect(this, &QAction::checkableChanged, this, &ActionData::syncAction);
    connect(this, &QAction::toggled, this, &ActionData::syncAction);
    connect(this, &QAction::enabledChanged, this, [this]() {
        if (!m_contextStateUpdating) {
            m_baseEnabled = isEnabled();
        }
    });
    connect(this, &QAction::visibleChanged, this, [this]() {
        if (!m_contextStateUpdating) {
            m_baseVisible = isVisible();
        }
    });
    connect(this, &QAction::triggered, this, [this]() {
        if (m_forwardingTrigger || !m_primaryAction) {
            return;
        }
        m_forwardingTrigger = true;

        QQmlProperty primaryFromQAction(m_primaryAction, QStringLiteral("fromQAction"));
        const bool hasPrimaryBridge = primaryFromQAction.isValid() && primaryFromQAction.isWritable();
        const QVariant primaryBridge = hasPrimaryBridge ? primaryFromQAction.read() : QVariant();
        if (hasPrimaryBridge) {
            primaryFromQAction.write(QVariant());
        }

        QMetaObject::invokeMethod(m_primaryAction, "trigger");

        if (hasPrimaryBridge) {
            primaryFromQAction.write(primaryBridge);
        }
        m_forwardingTrigger = false;
    });
}

QString ActionData::name() const
{
    return m_name;
}

void ActionData::setName(const QString &name)
{
    if (m_name == name) {
        return;
    }
    m_name = name;
    setObjectName(name);
    Q_EMIT nameChanged();
}

IconGroup *ActionData::icon() const
{
    return m_icon;
}

QActionGroup *ActionData::actionGroup() const
{
    return m_actionGroup;
}

void ActionData::setActionGroup(QActionGroup *group)
{
    if (m_actionGroup == group) {
        return;
    }
    m_actionGroup = group;
    QAction::setActionGroup(group);
    Q_EMIT actionGroupChanged();
}

QObject *ActionData::action() const
{
    return m_primaryAction.data();
}

void ActionData::setAction(QObject *action)
{
    if (this->action() == action) {
        return;
    }

    if (m_primaryAction) {
        m_actionInstances.removeAll(m_primaryAction);
        disconnect(m_primaryAction, nullptr, this, nullptr);
    }

    m_primaryAction = action;
    if (action) {
        addActionInstance(action);
    }
    updateContextState();
    Q_EMIT actionChanged();
}

QQmlListProperty<ActionContext> ActionData::contexts()
{
    return QQmlListProperty<ActionContext>(this, nullptr, &ActionData::appendContext, &ActionData::contextCount, &ActionData::contextAt, &ActionData::clearContexts);
}

bool ActionData::contextActive() const
{
    return m_contexts.isEmpty() || activeContext();
}

ActionContext *ActionData::activeContext() const
{
    ActionContext *activeContext = nullptr;
    for (const auto &context : m_contexts) {
        if (!context || !context->contextActive()) {
            continue;
        }
        if (!activeContext || context->priority() > activeContext->priority()) {
            activeContext = context;
        }
    }
    return activeContext;
}

bool ActionData::contextEnabled() const
{
    return m_contextEnabled;
}

void ActionData::setContextEnabled(bool enabled)
{
    if (m_contextEnabled == enabled) {
        return;
    }
    m_contextEnabled = enabled;
    Q_EMIT contextEnabledChanged();
    updateContextState();
}

bool ActionData::contextVisible() const
{
    return m_contextVisible;
}

void ActionData::setContextVisible(bool visible)
{
    if (m_contextVisible == visible) {
        return;
    }
    m_contextVisible = visible;
    Q_EMIT contextVisibleChanged();
    updateContextState();
}

void ActionData::appendContext(QQmlListProperty<ActionContext> *property, ActionContext *context)
{
    static_cast<ActionData *>(property->object)->addContext(context);
}

qsizetype ActionData::contextCount(QQmlListProperty<ActionContext> *property)
{
    return static_cast<ActionData *>(property->object)->m_contexts.size();
}

ActionContext *ActionData::contextAt(QQmlListProperty<ActionContext> *property, qsizetype index)
{
    const auto contexts = static_cast<ActionData *>(property->object)->m_contexts;
    return index >= 0 && index < contexts.size() ? contexts.at(index).data() : nullptr;
}

void ActionData::clearContexts(QQmlListProperty<ActionContext> *property)
{
    auto action = static_cast<ActionData *>(property->object);
    action->clearContextList();
    action->updateContextState();
}

void ActionData::addContext(ActionContext *context)
{
    if (!context || m_contexts.contains(context)) {
        return;
    }
    m_contexts.append(context);
    m_contextConnections.append(connect(context, &ActionContext::contextActiveChanged, this, &ActionData::updateContextState));
    m_contextConnections.append(connect(context, &ActionContext::priorityChanged, this, &ActionData::updateContextState));
    m_contextConnections.append(connect(context, &QObject::destroyed, this, [this, context]() {
        m_contexts.removeAll(context);
        updateContextState();
    }));
    updateContextState();
}

void ActionData::clearContextList()
{
    if (m_contexts.isEmpty()) {
        return;
    }
    for (const auto &connection : std::as_const(m_contextConnections)) {
        QObject::disconnect(connection);
    }
    m_contextConnections.clear();
    m_contexts.clear();
    updateContextState();
}

void ActionData::addActionInstance(QObject *action)
{
    if (!action || m_actionInstances.contains(action)) {
        return;
    }
    m_actionInstances.append(action);
    connect(action, &QObject::destroyed, this, [this, action]() {
        m_actionInstances.removeAll(action);
        if (m_primaryAction == action) {
            m_primaryAction.clear();
        }
    }, Qt::SingleShotConnection);

    if (action != m_primaryAction) {
        QQmlProperty(action, QStringLiteral("visible")).connectNotifySignal(this, SLOT(syncPrimaryAction()));
        QQmlProperty(action, QStringLiteral("enabled")).connectNotifySignal(this, SLOT(syncPrimaryAction()));
    }
    syncAction();
}

void ActionData::syncPrimaryAction()
{
    if (m_forwardingTrigger) {
        return;
    }
    auto action = sender();
    if (!action) {
        action = m_primaryAction;
    }
    if (action != m_primaryAction) {
        return;
    }
    m_baseVisible = action->property("visible").toBool();
    m_baseEnabled = action->property("enabled").toBool();
    updateContextState();
}

void ActionData::updateContextState()
{
    const bool active = contextActive();
    const auto selectedContext = activeContext();
    const bool activeChanged = m_effectiveContextActive != active;
    const bool selectedContextChanged = m_effectiveActiveContext != selectedContext;
    m_effectiveContextActive = active;
    m_effectiveActiveContext = selectedContext;
    if (activeChanged) {
        Q_EMIT contextActiveChanged();
    }
    if (selectedContextChanged) {
        Q_EMIT activeContextChanged();
    }
    m_contextStateUpdating = true;
    setVisible(m_baseVisible && (active || !m_contextVisible));
    setEnabled(m_baseEnabled && (active || !m_contextEnabled));
    m_contextStateUpdating = false;
    syncAction();
}

void ActionData::forwardTriggered()
{
    if (sender() == m_primaryAction || !m_primaryAction) {
        return;
    }
    QMetaObject::invokeMethod(m_primaryAction, "trigger");
}

void ActionData::removeActionInstance(QObject *action)
{
    if (!action || action == m_primaryAction) {
        return;
    }
    m_actionInstances.removeAll(action);
    disconnect(action, nullptr, this, nullptr);
}

void ActionData::syncAction()
{
    if (m_actionInstances.isEmpty()) {
        return;
    }

    for (const auto &action : std::as_const(m_actionInstances)) {
        const auto syncProperty = [action](const char *name, const QVariant &value) {
            QQmlProperty property(action, QString::fromLatin1(name));
            if (property.isValid() && property.isWritable()) {
                property.write(value);
            }
        };

        QQmlProperty fromQAction(action, QStringLiteral("fromQAction"));
        if (fromQAction.isValid() && fromQAction.isWritable()) {
            fromQAction.write(QVariant::fromValue(this));
            continue;
        }

        syncProperty("text", text());
        syncProperty("icon.name", icon()->name());
        syncProperty("icon.source", icon()->source());
        syncProperty("icon.width", icon()->width());
        syncProperty("icon.height", icon()->height());
        syncProperty("icon.color", icon()->color());
        syncProperty("icon.cache", icon()->cache());
        syncProperty("shortcut", shortcut());
        syncProperty("checkable", isCheckable());
        syncProperty("checked", isChecked());
        syncProperty("enabled", isEnabled());
        syncProperty("data", data());
        syncProperty("alternateShortcut", QVariant::fromValue(m_defaultAlternateShortcut));
    }
}

QVariant ActionData::defaultShortcut() const
{
    return m_defaultShortcut;
}

void ActionData::setDefaultShortcut(const QVariant &shortcut)
{
    if (m_defaultShortcut == shortcut) {
        return;
    }
    const auto sequence = variantToKeySequence(shortcut);
    m_defaultShortcut = sequence;
    KirigamiActionCollection::setDefaultShortcuts(this, {sequence, m_defaultAlternateShortcut.value<QKeySequence>()});
    Q_EMIT defaultShortcutChanged();
}

QVariant ActionData::defaultAlternateShortcut() const
{
    return m_defaultAlternateShortcut;
}

void ActionData::setDefaultAlternateShortcut(const QVariant &shortcut)
{
    if (m_defaultAlternateShortcut == shortcut) {
        return;
    }
    const auto sequence = variantToKeySequence(shortcut);
    m_defaultAlternateShortcut = sequence;
    KirigamiActionCollection::setDefaultShortcuts(this, {m_defaultShortcut.value<QKeySequence>(), sequence});
    Q_EMIT defaultAlternateShortcutChanged();
}

void ActionData::classBegin()
{
}

void ActionData::componentComplete()
{
    if (auto collection = qobject_cast<KirigamiActionCollection *>(parent())) {
        collection->insertAction(this);
    }
}

#include "moc_actiondata.cpp"
