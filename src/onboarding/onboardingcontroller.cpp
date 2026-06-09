// SPDX-FileCopyrightText: 2026 Sandro Andrade <sandroandrade@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

#include "onboardingcontroller_p.h"
#include "onboarding_p.h"

#include <QDebug>
#include <QTimer>
#include <QQmlComponent>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQmlProperty>
#include <algorithm>

OnboardingController *OnboardingController::self()
{
    static OnboardingController instance;
    return &instance;
}

OnboardingController::OnboardingController(QObject *parent)
    : QObject(parent)
{
}

bool OnboardingController::isActive() const
{
    return m_active;
}

QQuickItem *OnboardingController::source() const
{
    return m_source;
}

int OnboardingController::currentIndex() const
{
    return m_currentIndex;
}

Onboarding *OnboardingController::currentItem() const
{
    return m_currentItem;
}

QString OnboardingController::currentText() const
{
    return m_currentItem ? m_currentItem->textForGroup(m_group) : QString();
}

QQmlComponent *OnboardingController::additionalDataComponent() const
{
    return m_additionalDataComponent;
}

void OnboardingController::setAdditionalDataComponent(QQmlComponent *additionalDataComponent)
{
    if (m_additionalDataComponent == additionalDataComponent) {
        return;
    }
    m_additionalDataComponent = additionalDataComponent;
    Q_EMIT additionalDataComponentChanged();
}

qreal OnboardingController::x() const
{
    return m_x;
}

qreal OnboardingController::y() const
{
    return m_y;
}

qreal OnboardingController::width() const
{
    return m_width;
}

qreal OnboardingController::height() const
{
    return m_height;
}

qreal OnboardingController::padding() const
{
    return m_padding;
}

void OnboardingController::setPadding(qreal padding)
{
    if (qFuzzyCompare(m_padding, padding)) {
        return;
    }
    m_padding = padding;
    Q_EMIT paddingChanged();
    updateGeometry();
}

bool OnboardingController::hasNextItem() const
{
    return nextEnabledItemIndex(1) != -1;
}

bool OnboardingController::hasPreviousItem() const
{
    return nextEnabledItemIndex(-1) != -1;
}

void OnboardingController::start(const QString &group)
{
    start(resolveSource(group), group);
}

void OnboardingController::start(QQuickItem *source, const QString &group)
{
    if (!source) {
        return;
    }

    const QList<Onboarding *> items = collectItems(source, group);
    if (items.isEmpty()) {
        qWarning() << "Onboarding: no enabled steps declare content for group" << group;
        return;
    }

    const bool activeSourceChanged = m_source != source;
    const bool activeGroupDidChange = m_group != group;
    if (m_active) {
        setCurrentItem(nullptr);
    }
    clearEffect();
    if (activeSourceChanged) {
        setSourceLayerEnabled(false);
        clearVisuals();
    }

    m_source = source;
    m_group = group;
    m_items = items;
    if (activeSourceChanged) {
        Q_EMIT sourceChanged();
    }
    if (activeGroupDidChange) {
        Q_EMIT activeGroupChanged();
        Q_EMIT currentTextChanged();
    }

    Q_EMIT aboutToStart();
    setSourceLayerEnabled(true);
    ensureVisuals();
    if (!m_active) {
        m_active = true;
        Q_EMIT activeChanged();
    }

    m_currentIndex = -1;
    Q_EMIT currentIndexChanged();
    Q_EMIT navigationChanged();
    updateCurrentItem(1);
}

void OnboardingController::stop()
{
    if (!m_active && !m_currentItem && m_currentIndex == -1) {
        return;
    }

    m_active = false;
    m_currentIndex = -1;
    setCurrentItem(nullptr);
    clearGeometryConnections();
    clearEffect();
    updateGeometry();
    setSourceLayerEnabled(false);

    Q_EMIT activeChanged();
    Q_EMIT currentIndexChanged();
    Q_EMIT navigationChanged();
    Q_EMIT finished();
}

void OnboardingController::next()
{
    updateCurrentItem(1);
}

void OnboardingController::previous()
{
    updateCurrentItem(-1);
}

void OnboardingController::registerAttached(Onboarding *attached)
{
    m_attachedItems.append(attached);
}

void OnboardingController::unregisterAttached(Onboarding *attached)
{
    m_attachedItems.removeAll(attached);
    m_items.removeAll(attached);
    if (m_currentItem == attached) {
        setCurrentItem(nullptr, false);
    }
    if (attached && attached->target() == m_source) {
        stop();
        m_source.clear();
        clearVisuals();
        Q_EMIT sourceChanged();
    }
}

void OnboardingController::emitNavigationChanged()
{
    Q_EMIT navigationChanged();
}

QList<Onboarding *> OnboardingController::collectItems(QQuickItem *source, const QString &group) const
{
    QList<Onboarding *> items;
    for (Onboarding *attached : std::as_const(m_attachedItems)) {
        if (!attached || !attached->hasStep() || !attached->target() || !isDescendantOf(attached->target(), source)) {
            continue;
        }
        if (!attached->groups().contains(group)) {
            continue;
        }
        if (!attached->hasContentForGroup(group)) {
            qWarning() << "Onboarding: step declares group" << group << "but has no matching text";
            continue;
        }
        items.append(attached);
    }

    std::sort(items.begin(), items.end(), [](Onboarding *left, Onboarding *right) {
        return left->sequence() < right->sequence();
    });

    return items;
}

QQuickItem *OnboardingController::resolveSource(const QString &group) const
{
    QList<QQuickItem *> sources;
    for (Onboarding *attached : std::as_const(m_attachedItems)) {
        if (!attached || !attached->isSource() || !attached->target()) {
            continue;
        }
        if (attached->sourceGroups().contains(group)) {
            sources.append(attached->target());
        }
    }

    if (sources.isEmpty()) {
        qWarning() << "Onboarding: no source declares group" << group;
        return nullptr;
    }
    if (sources.size() > 1) {
        qWarning() << "Onboarding: multiple sources declare group" << group;
        return nullptr;
    }
    return sources.constFirst();
}

void OnboardingController::updateCurrentItem(int delta)
{
    if (!m_active) {
        return;
    }

    const int nextIndex = nextEnabledItemIndex(delta);
    if (nextIndex == -1) {
        return;
    }

    m_currentIndex = nextIndex;
    Q_EMIT currentIndexChanged();
    Q_EMIT navigationChanged();

    auto *attached = m_items.at(m_currentIndex);
    Q_EMIT attached->aboutToShow();
    QTimer::singleShot(0, this, [this, attached]() {
        if (!m_active || !m_items.contains(attached)) {
            return;
        }
        setCurrentItem(attached);
    });
}

int OnboardingController::nextEnabledItemIndex(int delta) const
{
    int nextIndex = m_currentIndex + delta;
    while (nextIndex >= 0 && nextIndex < m_items.size()) {
        Onboarding *attached = m_items.at(nextIndex);
        if (attached && attached->isEnabled() && attached->target()) {
            return nextIndex;
        }
        nextIndex += delta;
    }
    return -1;
}

void OnboardingController::setCurrentItem(Onboarding *attached, bool emitHide)
{
    if (m_currentItem == attached) {
        updateGeometry();
        return;
    }

    if (emitHide && m_currentItem) {
        Q_EMIT m_currentItem->hide();
    }

    clearGeometryConnections();
    m_currentItem = attached;
    Q_EMIT currentItemChanged();
    Q_EMIT currentTextChanged();

    if (attached && attached->target()) {
        for (auto *item = attached->target(); item; item = item->parentItem()) {
            m_geometryConnections.append(connect(item, &QQuickItem::xChanged, this, &OnboardingController::updateGeometry));
            m_geometryConnections.append(connect(item, &QQuickItem::yChanged, this, &OnboardingController::updateGeometry));
            if (item == attached->target()) {
                m_geometryConnections.append(connect(item, &QQuickItem::widthChanged, this, &OnboardingController::updateGeometry));
                m_geometryConnections.append(connect(item, &QQuickItem::heightChanged, this, &OnboardingController::updateGeometry));
            }
            if (item == m_source) {
                break;
            }
        }
    }

    updateGeometry();
}

void OnboardingController::updateGeometry()
{
    qreal newX = 0;
    qreal newY = 0;
    qreal newWidth = 0;
    qreal newHeight = 0;

    if (m_currentItem && m_currentItem->target() && m_source) {
        const QPointF mappedPosition = m_currentItem->target()->mapToItem(m_source, QPointF(0, 0));
        newX = mappedPosition.x() - m_padding;
        newY = mappedPosition.y() - m_padding;
        newWidth = m_currentItem->target()->width() + 2 * m_padding;
        newHeight = m_currentItem->target()->height() + 2 * m_padding;
    }

    const bool changed = !qFuzzyCompare(m_x, newX) || !qFuzzyCompare(m_y, newY) || !qFuzzyCompare(m_width, newWidth) || !qFuzzyCompare(m_height, newHeight);
    m_x = newX;
    m_y = newY;
    m_width = newWidth;
    m_height = newHeight;
    if (changed) {
        Q_EMIT geometryChanged();
    }
}

void OnboardingController::clearGeometryConnections()
{
    for (const auto &connection : std::as_const(m_geometryConnections)) {
        disconnect(connection);
    }
    m_geometryConnections.clear();
}

void OnboardingController::clearEffect()
{
    delete m_effect;
    m_effect.clear();
}

void OnboardingController::ensureVisuals()
{
    if (!m_source) {
        return;
    }

    QQmlContext *context = QQmlEngine::contextForObject(m_source);
    QQmlEngine *engine = context ? context->engine() : qmlEngine(m_source);
    if (!engine) {
        return;
    }

    if (!m_effect) {
        QQmlComponent component(engine, QUrl(QStringLiteral("qrc:/qt/qml/org/kde/kirigamiaddons/onboarding/private/OnboardingEffect.qml")), m_source);
        QObject *createdObject = component.createWithInitialProperties({{QStringLiteral("sourceItem"), QVariant::fromValue(m_source.data())}}, context);
        auto *effect = qobject_cast<QQuickItem *>(createdObject);
        if (!effect) {
            delete createdObject;
        } else {
            effect->setParent(m_source);
            effect->setParentItem(m_source->parentItem() ? m_source->parentItem() : m_source.data());
            m_effect = effect;
        }
    }

    if (!m_overlay) {
        QQmlComponent component(engine, QUrl(QStringLiteral("qrc:/qt/qml/org/kde/kirigamiaddons/onboarding/private/OnboardingOverlay.qml")), m_source);
        QObject *createdObject = component.createWithInitialProperties({{QStringLiteral("sourceItem"), QVariant::fromValue(m_source.data())}}, context);
        auto *overlay = qobject_cast<QQuickItem *>(createdObject);
        if (!overlay) {
            delete createdObject;
            return;
        }

        overlay->setParent(m_source);
        overlay->setParentItem(m_source->parentItem() ? m_source->parentItem() : m_source.data());
        m_overlay = overlay;
    }
}

void OnboardingController::clearVisuals()
{
    delete m_overlay;
    delete m_effect;
    m_overlay.clear();
    m_effect.clear();
}

void OnboardingController::setSourceLayerEnabled(bool enabled)
{
    if (!m_source) {
        return;
    }

    QQmlProperty layerEnabled(m_source, QStringLiteral("layer.enabled"));
    if (!layerEnabled.isValid() || !layerEnabled.isWritable()) {
        return;
    }

    if (enabled) {
        if (!m_hasSourceLayerState) {
            m_sourceLayerWasEnabled = layerEnabled.read().toBool();
            m_hasSourceLayerState = true;
        }
        layerEnabled.write(true);
        return;
    }

    if (m_hasSourceLayerState) {
        layerEnabled.write(m_sourceLayerWasEnabled);
        m_hasSourceLayerState = false;
        m_sourceLayerWasEnabled = false;
    }
}

bool OnboardingController::isDescendantOf(QQuickItem *item, QQuickItem *ancestor)
{
    for (QQuickItem *candidate = item; candidate; candidate = candidate->parentItem()) {
        if (candidate == ancestor) {
            return true;
        }
    }
    return false;
}
