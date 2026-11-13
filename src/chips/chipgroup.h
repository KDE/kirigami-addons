/*
 * SPDX-FileCopyrightText: 2026 Kai Uwe Broulik <kde@broulik.de>
 *
 * SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL
 */

#pragma once

#include <QObject>

#include "chipobject.h"

#include <QString>

#include <qqmlregistration.h>

class ChipGroup;

class ChipGroupAttached : public QObject
{
    Q_OBJECT
    QML_ANONYMOUS // TODO needed?

    Q_PROPERTY(ChipGroup *group READ group WRITE setGroup NOTIFY groupChanged)

public:
    explicit ChipGroupAttached(QObject *group);

    ChipGroup *group() const;
    void setGroup(ChipGroup *group);
    Q_SIGNAL void groupChanged(ChipGroup *group);

private:
    ChipGroup *m_group = nullptr;
};

class ChipGroup : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_ATTACHED(ChipGroupAttached)

    Q_PROPERTY(QString label READ label WRITE setLabel NOTIFY labelChanged)
    Q_PROPERTY(QString prefix READ prefix WRITE setPrefix NOTIFY prefixChanged)

    // Q_PROPERTY(QFont font READ font WRITE setFont NOTIFY fontChanged)
    Q_PROPERTY(QColor foregroundColor READ foregroundColor WRITE setForegroundColor RESET resetForegroundColor NOTIFY foregroundColorChanged)
    Q_PROPERTY(QColor backgroundColor READ backgroundColor WRITE setBackgroundColor RESET resetBackgroundColor NOTIFY backgroundColorChanged)

public:
    explicit ChipGroup(QObject *parent = nullptr);
    ~ChipGroup() override;

    QString label() const;
    void setLabel(const QString &label);
    Q_SIGNAL void labelChanged(const QString &label);

    QString prefix() const;
    void setPrefix(const QString &prefix);
    Q_SIGNAL void prefixChanged(const QString &prefix);

    QColor foregroundColor() const;
    void setForegroundColor(const QColor &color);
    void resetForegroundColor();
    Q_SIGNAL void foregroundColorChanged(const QColor &color);

    QColor backgroundColor() const;
    void setBackgroundColor(const QColor &color);
    void resetBackgroundColor();
    Q_SIGNAL void backgroundColorChanged(const QColor &color);

    static ChipGroupAttached *qmlAttachedProperties(QObject *object);

    static ChipGroup *groupForChip(ChipObject *chip);

private:
    QString m_label;
    QString m_prefix;
    //    QFont m_font;
    QColor m_foregroundColor;
    QColor m_backgroundColor;
};

// QML_DECLARE_TYPEINFO(ChipGroup, QML_HAS_ATTACHED_PROPERTIES)
