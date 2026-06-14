// SPDX-FileCopyrightText: 2026 Sandro Andrade <sandroandrade@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

#pragma once

#include <QObject>
#include <QPointer>
#include <QQmlComponent>
#include <QQuickItem>
#include <QStringList>
#include <QVariantMap>
#include <qqmlregistration.h>

class Onboarding : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_ATTACHED(Onboarding)
    QML_UNCREATABLE("Attached Property")

    Q_PROPERTY(bool isSource READ isSource WRITE setIsSource NOTIFY isSourceChanged)
    Q_PROPERTY(QStringList sourceGroups READ sourceGroups WRITE setSourceGroups NOTIFY sourceGroupsChanged)
    Q_PROPERTY(QStringList groups READ groups WRITE setGroups NOTIFY groupsChanged)
    Q_PROPERTY(QStringList texts READ texts WRITE setTexts NOTIFY textsChanged)
    Q_PROPERTY(QVariantMap additionalData READ additionalData WRITE setAdditionalData NOTIFY additionalDataChanged)
    Q_PROPERTY(bool enabled READ isEnabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(QQuickItem *target READ target CONSTANT)
    Q_PROPERTY(int sequence READ sequence CONSTANT)

    Q_PROPERTY(bool active READ isActive NOTIFY activeChanged)
    Q_PROPERTY(QQuickItem *source READ source NOTIFY sourceChanged)
    Q_PROPERTY(int currentIndex READ currentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(Onboarding *currentItem READ currentItem NOTIFY currentItemChanged)
    Q_PROPERTY(QString currentText READ currentText NOTIFY currentTextChanged)
    Q_PROPERTY(QQmlComponent *additionalDataComponent READ additionalDataComponent WRITE setAdditionalDataComponent NOTIFY additionalDataComponentChanged)
    Q_PROPERTY(qreal x READ x NOTIFY geometryChanged)
    Q_PROPERTY(qreal y READ y NOTIFY geometryChanged)
    Q_PROPERTY(qreal width READ width NOTIFY geometryChanged)
    Q_PROPERTY(qreal height READ height NOTIFY geometryChanged)
    Q_PROPERTY(qreal padding READ padding WRITE setPadding NOTIFY paddingChanged)
    Q_PROPERTY(qreal blur READ blur WRITE setBlur NOTIFY blurChanged)
    Q_PROPERTY(int blurMax READ blurMax WRITE setBlurMax NOTIFY blurMaxChanged)
    Q_PROPERTY(bool hasNextItem READ hasNextItem NOTIFY navigationChanged)
    Q_PROPERTY(bool hasPreviousItem READ hasPreviousItem NOTIFY navigationChanged)

public:
    explicit Onboarding(QObject *target);
    ~Onboarding() override;

    static Onboarding *qmlAttachedProperties(QObject *object);

    bool isSource() const;
    void setIsSource(bool isSource);

    QStringList sourceGroups() const;
    void setSourceGroups(const QStringList &sourceGroups);

    QStringList groups() const;
    void setGroups(const QStringList &groups);

    QStringList texts() const;
    void setTexts(const QStringList &texts);

    QVariantMap additionalData() const;
    void setAdditionalData(const QVariantMap &additionalData);

    bool isEnabled() const;
    void setEnabled(bool enabled);

    QQuickItem *target() const;
    int sequence() const;
    bool hasStep() const;
    bool hasContentForGroup(const QString &group) const;
    QString textForGroup(const QString &group) const;

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

    qreal blur() const;
    void setBlur(qreal blur);

    int blurMax() const;
    void setBlurMax(int blurMax);

    bool hasNextItem() const;
    bool hasPreviousItem() const;

    Q_INVOKABLE void start();
    Q_INVOKABLE void start(const QString &group);
    Q_INVOKABLE void stop();
    Q_INVOKABLE void next();
    Q_INVOKABLE void previous();

Q_SIGNALS:
    void isSourceChanged();
    void sourceGroupsChanged();
    void groupsChanged();
    void textsChanged();
    void additionalDataChanged();
    void enabledChanged();
    void aboutToShow();
    void hide();

    void activeChanged();
    void sourceChanged();
    void currentIndexChanged();
    void currentItemChanged();
    void currentTextChanged();
    void additionalDataComponentChanged();
    void geometryChanged();
    void paddingChanged();
    void blurChanged();
    void blurMaxChanged();
    void navigationChanged();
    void aboutToStart();
    void finished();

private:
    void markAsStep();

    QPointer<QQuickItem> m_target;
    QStringList m_sourceGroups = {QString()};
    QStringList m_groups = {QString()};
    QStringList m_texts;
    QVariantMap m_additionalData;
    bool m_isSource = false;
    bool m_enabled = true;
    bool m_hasStep = false;
    int m_sequence = 0;
};

QML_DECLARE_TYPEINFO(Onboarding, QML_HAS_ATTACHED_PROPERTIES)
