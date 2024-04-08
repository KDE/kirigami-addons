/*
    This file is part of the KDE libraries
    SPDX-FileCopyrightText: 2001 Holger Freyther <freyher@yahoo.com>

    based on ideas from Martijn and Simon
    many thanks to Simon

    SPDX-License-Identifier: LGPL-2.0-only
*/

#include "kirigamiguiitem.h"

#include <QSharedData>

class KirigamiGuiItemPrivate : public QSharedData
{
public:
    KirigamiGuiItemPrivate()
    {
        m_enabled = true;
        m_hasIcon = false;
    }

    KirigamiGuiItemPrivate(const KirigamiGuiItemPrivate &other) = default;

    KirigamiGuiItemPrivate &operator=(const KirigamiGuiItemPrivate &other) = default;

    QString m_text;
    QString m_toolTip;
    QString m_whatsThis;
    QString m_statusText;
    QString m_iconName;
    QIcon m_icon;
    bool m_hasIcon : 1;
    bool m_enabled : 1;
};

KirigamiGuiItem::KirigamiGuiItem()
    : d(new KirigamiGuiItemPrivate)
{
}

KirigamiGuiItem::KirigamiGuiItem(const QString &text, const QString &iconName, const QString &toolTip, const QString &whatsThis)
    : d(new KirigamiGuiItemPrivate)
{
    d->m_text = text;
    d->m_toolTip = toolTip;
    d->m_whatsThis = whatsThis;
    setIconName(iconName);
}

KirigamiGuiItem::KirigamiGuiItem(const QString &text, const QIcon &icon, const QString &toolTip, const QString &whatsThis)
    : d(new KirigamiGuiItemPrivate)
{
    d->m_text = text;
    d->m_toolTip = toolTip;
    d->m_whatsThis = whatsThis;
    setIcon(icon);
}

KirigamiGuiItem::KirigamiGuiItem(const KirigamiGuiItem &rhs) = default;

KirigamiGuiItem &KirigamiGuiItem::operator=(const KirigamiGuiItem &rhs) = default;

KirigamiGuiItem::~KirigamiGuiItem() = default;

QString KirigamiGuiItem::text() const
{
    return d->m_text;
}

QString KirigamiGuiItem::plainText() const
{
    const int len = d->m_text.length();

    if (len == 0) {
        return d->m_text;
    }

    // Can assume len >= 1 from now on.
    QString stripped;

    int resultLength = 0;
    stripped.resize(len);

    const QChar *data = d->m_text.unicode();
    for (int pos = 0; pos < len; ++pos) {
        if (data[pos] != QLatin1Char('&')) {
            stripped[resultLength++] = data[pos];
        } else if (pos + 1 < len && data[pos + 1] == QLatin1Char('&')) {
            stripped[resultLength++] = data[pos++];
        }
    }

    stripped.truncate(resultLength);

    return stripped;
}

QIcon KirigamiGuiItem::icon() const
{
    if (d->m_hasIcon) {
        if (!d->m_iconName.isEmpty()) {
            return QIcon::fromTheme(d->m_iconName);
        } else {
            return d->m_icon;
        }
    }
    return QIcon();
}

QString KirigamiGuiItem::iconName() const
{
    return d->m_iconName;
}

QString KirigamiGuiItem::toolTip() const
{
    return d->m_toolTip;
}

QString KirigamiGuiItem::whatsThis() const
{
    return d->m_whatsThis;
}

bool KirigamiGuiItem::isEnabled() const
{
    return d->m_enabled;
}

bool KirigamiGuiItem::hasIcon() const
{
    return d->m_hasIcon;
}

void KirigamiGuiItem::setText(const QString &text)
{
    d->m_text = text;
}

void KirigamiGuiItem::setIcon(const QIcon &icon)
{
    d->m_icon = icon;
    d->m_iconName.clear();
    d->m_hasIcon = !icon.isNull();
}

void KirigamiGuiItem::setIconName(const QString &iconName)
{
    d->m_iconName = iconName;
    d->m_icon = QIcon();
    d->m_hasIcon = !iconName.isEmpty();
}

void KirigamiGuiItem::setToolTip(const QString &toolTip)
{
    d->m_toolTip = toolTip;
}

void KirigamiGuiItem::setWhatsThis(const QString &whatsThis)
{
    d->m_whatsThis = whatsThis;
}

void KirigamiGuiItem::setEnabled(bool enabled)
{
    d->m_enabled = enabled;
}
