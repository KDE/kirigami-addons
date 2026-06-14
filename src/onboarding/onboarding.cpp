// SPDX-FileCopyrightText: 2026 Sandro Andrade <sandroandrade@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

#include "onboarding_p.h"
#include "onboardingcontroller_p.h"

namespace
{
int s_nextSequence = 0;
}

Onboarding::Onboarding(QObject *target)
    : QObject(target)
    , m_target(qobject_cast<QQuickItem *>(target))
    , m_sequence(s_nextSequence++)
{
    OnboardingController::self()->registerAttached(this);

    auto *controller = OnboardingController::self();
    connect(controller, &OnboardingController::activeChanged, this, &Onboarding::activeChanged);
    connect(controller, &OnboardingController::sourceChanged, this, &Onboarding::sourceChanged);
    connect(controller, &OnboardingController::currentIndexChanged, this, &Onboarding::currentIndexChanged);
    connect(controller, &OnboardingController::currentItemChanged, this, &Onboarding::currentItemChanged);
    connect(controller, &OnboardingController::currentTextChanged, this, &Onboarding::currentTextChanged);
    connect(controller, &OnboardingController::additionalDataComponentChanged, this, &Onboarding::additionalDataComponentChanged);
    connect(controller, &OnboardingController::geometryChanged, this, &Onboarding::geometryChanged);
    connect(controller, &OnboardingController::paddingChanged, this, &Onboarding::paddingChanged);
    connect(controller, &OnboardingController::blurChanged, this, &Onboarding::blurChanged);
    connect(controller, &OnboardingController::blurMaxChanged, this, &Onboarding::blurMaxChanged);
    connect(controller, &OnboardingController::navigationChanged, this, &Onboarding::navigationChanged);
    connect(controller, &OnboardingController::aboutToStart, this, &Onboarding::aboutToStart);
    connect(controller, &OnboardingController::finished, this, &Onboarding::finished);
}

Onboarding::~Onboarding()
{
    OnboardingController::self()->unregisterAttached(this);
}

Onboarding *Onboarding::qmlAttachedProperties(QObject *object)
{
    return new Onboarding(object);
}

bool Onboarding::isSource() const
{
    return m_isSource;
}

void Onboarding::setIsSource(bool isSource)
{
    if (m_isSource == isSource) {
        return;
    }
    m_isSource = isSource;
    Q_EMIT isSourceChanged();
    OnboardingController::self()->emitNavigationChanged();
}

QStringList Onboarding::sourceGroups() const
{
    return m_sourceGroups;
}

void Onboarding::setSourceGroups(const QStringList &sourceGroups)
{
    if (m_sourceGroups == sourceGroups) {
        return;
    }
    m_sourceGroups = sourceGroups;
    Q_EMIT sourceGroupsChanged();
    OnboardingController::self()->emitNavigationChanged();
}

QStringList Onboarding::groups() const
{
    return m_groups;
}

void Onboarding::setGroups(const QStringList &groups)
{
    if (m_groups == groups) {
        return;
    }
    m_groups = groups;
    Q_EMIT groupsChanged();
    OnboardingController::self()->emitNavigationChanged();
}

QStringList Onboarding::texts() const
{
    return m_texts;
}

void Onboarding::setTexts(const QStringList &texts)
{
    if (m_texts == texts) {
        return;
    }
    m_texts = texts;
    markAsStep();
    Q_EMIT textsChanged();
    OnboardingController::self()->emitNavigationChanged();
}

QVariantMap Onboarding::additionalData() const
{
    return m_additionalData;
}

void Onboarding::setAdditionalData(const QVariantMap &additionalData)
{
    if (m_additionalData == additionalData) {
        return;
    }
    m_additionalData = additionalData;
    markAsStep();
    Q_EMIT additionalDataChanged();
    OnboardingController::self()->emitNavigationChanged();
}

bool Onboarding::isEnabled() const
{
    return m_enabled;
}

void Onboarding::setEnabled(bool enabled)
{
    if (m_enabled == enabled) {
        return;
    }
    m_enabled = enabled;
    Q_EMIT enabledChanged();
    OnboardingController::self()->emitNavigationChanged();
}

QQuickItem *Onboarding::target() const
{
    return m_target;
}

int Onboarding::sequence() const
{
    return m_sequence;
}

bool Onboarding::hasStep() const
{
    return m_hasStep;
}

bool Onboarding::hasContentForGroup(const QString &group) const
{
    return !textForGroup(group).isEmpty() || !m_additionalData.isEmpty();
}

QString Onboarding::textForGroup(const QString &group) const
{
    const qsizetype index = m_groups.indexOf(group);
    if (index == -1 || index >= m_texts.size()) {
        return {};
    }
    return m_texts.at(index);
}

bool Onboarding::isActive() const
{
    return OnboardingController::self()->isActive();
}

QQuickItem *Onboarding::source() const
{
    return OnboardingController::self()->source();
}

int Onboarding::currentIndex() const
{
    return OnboardingController::self()->currentIndex();
}

Onboarding *Onboarding::currentItem() const
{
    return OnboardingController::self()->currentItem();
}

QString Onboarding::currentText() const
{
    return OnboardingController::self()->currentText();
}

QQmlComponent *Onboarding::additionalDataComponent() const
{
    return OnboardingController::self()->additionalDataComponent();
}

void Onboarding::setAdditionalDataComponent(QQmlComponent *additionalDataComponent)
{
    OnboardingController::self()->setAdditionalDataComponent(additionalDataComponent);
}

qreal Onboarding::x() const
{
    return OnboardingController::self()->x();
}

qreal Onboarding::y() const
{
    return OnboardingController::self()->y();
}

qreal Onboarding::width() const
{
    return OnboardingController::self()->width();
}

qreal Onboarding::height() const
{
    return OnboardingController::self()->height();
}

qreal Onboarding::padding() const
{
    return OnboardingController::self()->padding();
}

void Onboarding::setPadding(qreal padding)
{
    OnboardingController::self()->setPadding(padding);
}

qreal Onboarding::blur() const
{
    return OnboardingController::self()->blur();
}

void Onboarding::setBlur(qreal blur)
{
    OnboardingController::self()->setBlur(blur);
}

int Onboarding::blurMax() const
{
    return OnboardingController::self()->blurMax();
}

void Onboarding::setBlurMax(int blurMax)
{
    OnboardingController::self()->setBlurMax(blurMax);
}

bool Onboarding::hasNextItem() const
{
    return OnboardingController::self()->hasNextItem();
}

bool Onboarding::hasPreviousItem() const
{
    return OnboardingController::self()->hasPreviousItem();
}

void Onboarding::start()
{
    OnboardingController::self()->start(QString());
}

void Onboarding::start(const QString &group)
{
    OnboardingController::self()->start(group);
}

void Onboarding::stop()
{
    OnboardingController::self()->stop();
}

void Onboarding::next()
{
    OnboardingController::self()->next();
}

void Onboarding::previous()
{
    OnboardingController::self()->previous();
}

void Onboarding::markAsStep()
{
    m_hasStep = true;
}
