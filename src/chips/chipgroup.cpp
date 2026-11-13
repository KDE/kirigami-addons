/*
 * SPDX-FileCopyrightText: 2026 Kai Uwe Broulik <kde@broulik.de>
 *
 * SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL
 */

#include "chipgroup.h"

#include <QQmlEngine>

using namespace Qt::StringLiterals;

ChipGroup::ChipGroup(QObject *parent)
    : QObject(parent)
{
}

ChipGroup::~ChipGroup() = default;

QString ChipGroup::label() const
{
    return m_label;
}

void ChipGroup::setLabel(const QString &label)
{
    if (m_label == label) {
        return;
    }

    m_label = label;
    Q_EMIT labelChanged(label);
}

QString ChipGroup::prefix() const
{
    return m_prefix;
}

void ChipGroup::setPrefix(const QString &prefix)
{
    if (m_prefix == prefix) {
        return;
    }

    m_prefix = prefix;
    Q_EMIT prefixChanged(prefix);
}

QColor ChipGroup::foregroundColor() const
{
    return m_foregroundColor;
}

void ChipGroup::setForegroundColor(const QColor &color)
{
    if (m_foregroundColor == color) {
        return;
    }

    m_foregroundColor = color;
    Q_EMIT foregroundColorChanged(color);
}

void ChipGroup::resetForegroundColor()
{
    setForegroundColor(QColor());
}

QColor ChipGroup::backgroundColor() const
{
    return m_backgroundColor;
}

void ChipGroup::setBackgroundColor(const QColor &color)
{
    if (m_backgroundColor == color) {
        return;
    }

    m_backgroundColor = color;
    Q_EMIT backgroundColorChanged(color);
}

void ChipGroup::resetBackgroundColor()
{
    setBackgroundColor(QColor());
}

ChipGroupAttached *ChipGroup::qmlAttachedProperties(QObject *object)
{
    if (!qobject_cast<ChipObject *>(object)) {
        qWarning() << "ChipGroup can only be attached to ChipObject";
        return nullptr;
    }

    return new ChipGroupAttached(object);
}

ChipGroup *ChipGroup::groupForChip(ChipObject *chip)
{
    auto *groupAttached = qmlAttachedPropertiesObject<ChipGroup>(chip, false /*create*/);
    if (!groupAttached) {
        return nullptr;
    }

    return static_cast<ChipGroupAttached *>(groupAttached)->group();
}

ChipGroupAttached::ChipGroupAttached(QObject *parent)
    : QObject(parent)
{
}

ChipGroup *ChipGroupAttached::group() const
{
    return m_group;
}

void ChipGroupAttached::setGroup(ChipGroup *group)
{
    if (m_group != group) {
        m_group = group;
        Q_EMIT groupChanged(group);
    }
}

#include "moc_chipgroup.cpp"
