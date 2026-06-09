// SPDX-FileCopyrightText: 2026 Sandro Andrade <sandroandrade@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

#pragma once

#include <QObject>
#include <QPointer>
#include <QQuickItem>
#include <QQmlComponent>
#include <QString>

class Onboarding;

class OnboardingController : public QObject
{
    Q_OBJECT

public:
    static OnboardingController *self();

    bool isActive() const;
    QQuickItem *source() const;
    int currentIndex() const;
    Onboarding *currentItem() const;
    QString currentText() const;

    QQmlComponent *additionalDataComponent() const;
    void setAdditionalDataComponent(QQmlComponent *additionalDataComponent);

    qreal x() const;
    qreal y() const;
    qreal width() const;
    qreal height() const;

    qreal padding() const;
    void setPadding(qreal padding);

    bool hasNextItem() const;
    bool hasPreviousItem() const;

    void start(const QString &group);
    void stop();
    void next();
    void previous();

    void registerAttached(Onboarding *attached);
    void unregisterAttached(Onboarding *attached);
    void emitNavigationChanged();

Q_SIGNALS:
    void activeChanged();
    void sourceChanged();
    void activeGroupChanged();
    void currentIndexChanged();
    void currentItemChanged();
    void currentTextChanged();
    void additionalDataComponentChanged();
    void geometryChanged();
    void paddingChanged();
    void navigationChanged();
    void aboutToStart();
    void finished();

private:
    explicit OnboardingController(QObject *parent = nullptr);

    QList<Onboarding *> collectItems(QQuickItem *source, const QString &group) const;
    QQuickItem *resolveSource(const QString &group) const;
    void start(QQuickItem *source, const QString &group);
    void updateCurrentItem(int delta);
    int nextEnabledItemIndex(int delta) const;
    void setCurrentItem(Onboarding *attached, bool emitHide = true);
    void updateGeometry();
    void clearGeometryConnections();
    void clearEffect();
    void ensureVisuals();
    void clearVisuals();
    void setSourceLayerEnabled(bool enabled);
    static bool isDescendantOf(QQuickItem *item, QQuickItem *ancestor);

    QPointer<QQuickItem> m_source;
    QPointer<QQuickItem> m_overlay;
    QPointer<QQuickItem> m_effect;
    QList<QPointer<Onboarding>> m_attachedItems;
    QList<Onboarding *> m_items;
    QList<QMetaObject::Connection> m_geometryConnections;
    QPointer<Onboarding> m_currentItem;
    QPointer<QQmlComponent> m_additionalDataComponent;
    QString m_group;
    bool m_active = false;
    bool m_hasSourceLayerState = false;
    bool m_sourceLayerWasEnabled = false;
    int m_currentIndex = -1;
    qreal m_x = 0;
    qreal m_y = 0;
    qreal m_width = 0;
    qreal m_height = 0;
    qreal m_padding = 0;
};
