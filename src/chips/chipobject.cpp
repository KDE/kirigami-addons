/*
 * SPDX-FileCopyrightText: 2026 Kai Uwe Broulik <kde@broulik.de>
 *
 * SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL
 */

#include "chipobject.h"
#include "chipgroup.h"

#include <KLocalizedString>

using namespace Qt::StringLiterals;

ChipObject::ChipObject(QObject *parent)
    : QObject(parent)
{
}

ChipObject::~ChipObject() = default;

QString ChipObject::label() const
{
    return m_label;
}

void ChipObject::setLabel(const QString &label)
{
    if (m_label != label) {
        m_label = label;
        Q_EMIT labelChanged(label);
    }
}

QVariant ChipObject::value() const
{
    return m_value;
}

void ChipObject::setValue(const QVariant &value)
{
    if (m_value != value) {
        m_value = value;
        Q_EMIT valueChanged(value);
    }
}

void ChipObject::resetValue()
{
    setValue(QVariant());
}

QString ChipObject::preview() const
{
    return m_preview;
}

void ChipObject::setPreview(const QString &preview)
{
    if (m_preview != preview) {
        m_preview = preview;
        Q_EMIT previewChanged(preview);
    }
}

QColor ChipObject::foregroundColor() const
{
    return m_foregroundColor;
}

void ChipObject::setForegroundColor(const QColor &color)
{
    if (m_foregroundColor == color) {
        return;
    }

    m_foregroundColor = color;
    Q_EMIT foregroundColorChanged(color);
}

void ChipObject::resetForegroundColor()
{
    setForegroundColor(QColor());
}

QColor ChipObject::backgroundColor() const
{
    return m_backgroundColor;
}

void ChipObject::setBackgroundColor(const QColor &color)
{
    if (m_backgroundColor == color) {
        return;
    }

    m_backgroundColor = color;
    Q_EMIT backgroundColorChanged(color);
}

void ChipObject::resetBackgroundColor()
{
    setBackgroundColor(QColor());
}

QString ChipObject::toString() const
{
    if (!m_value.isNull()) {
        return m_value.toString();
    } else {
        return m_label;
    }
}

QString ChipObject::displayText(ChipObject *chip)
{
    // TODO eww the layering
    if (auto *group = ChipGroup::groupForChip(chip)) {
        return i18nc("chip group: chip label", "%1: %2", group->label(), chip->label());
    } else {
        return chip->label();
    }
}

#include "moc_chipobject.cpp"
