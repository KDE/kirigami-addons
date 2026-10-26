/*
 * SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "materialtheme.h"

#include <KIconColors>
#include <KIconLoader>
#include <Kirigami/Platform/StyleSelector>
#include <QMetaMethod>
#include <QQmlComponent>
#include <QQmlEngine>
#include <QQuickItem>
#include <QScopedValueRollback>

#include <cctype>

using namespace Kirigami::Platform;
using namespace Qt::StringLiterals;

QObject *MaterialTheme::themeDefinition(QQmlEngine *engine)
{
    if (!engine) {
        return nullptr;
    }
    const auto name = u"_kirigamiAddonsMaterialThemeDefinition"_s;
    if (auto definition = engine->findChild<QObject *>(name, Qt::FindDirectChildrenOnly)) {
        return definition;
    }

    // Keep Kirigami's Material color mapping, including application overrides.
    const auto url = StyleSelector::componentUrlForModule(u"controls"_s, u"Theme.qml"_s);
    if (!url.isValid()) {
        return nullptr;
    }
    QQmlComponent component(engine, url);
    auto definition = component.create();
    if (!definition) {
        qWarning() << "Could not load the Material theme definition:" << component.errors();
        return nullptr;
    }
    if (definition->metaObject()->indexOfSignal("changed()") < 0 || definition->metaObject()->indexOfSignal("sync(QQuickItem*)") < 0) {
        qWarning() << "Invalid Material theme definition:" << url;
        delete definition;
        return nullptr;
    }
    definition->setObjectName(name);
    definition->setParent(engine);
    return definition;
}

MaterialTheme::MaterialTheme(QObject *parent, QObject *definition)
    : PlatformTheme(parent)
    , m_definition(definition)
{
    setSupportsIconColoring(true);
    const auto signal = definition->metaObject()->method(definition->metaObject()->indexOfSignal("changed()"));
    const auto slot = metaObject()->method(metaObject()->indexOfSlot("syncColors()"));
    connect(definition, signal, this, slot);
    if (auto item = qobject_cast<QQuickItem *>(parent)) {
        connect(item, &QQuickItem::enabledChanged, this, &MaterialTheme::syncColors);
    }
    syncColors();
}

QIcon MaterialTheme::iconFromTheme(const QString &name, const QColor &customColor)
{
    KIconColors colors(palette());
    if (customColor.isValid() && customColor != Qt::transparent) {
        colors.setText(customColor);
    }
    return KDE::icon(name, colors);
}

void MaterialTheme::syncColors()
{
    if (!m_definition || m_syncing) {
        return;
    }
    QScopedValueRollback guard(m_syncing, true);
    PlatformThemeChangeTracker tracker(this);
    const auto color = [this](const char *name) {
        return tint(m_definition->property(name).value<QColor>());
    };

    QByteArray prefix;
    switch (colorSet()) {
    case Button:
        prefix = "button";
        break;
    case View:
        prefix = "view";
        break;
    case Selection:
        prefix = "selection";
        break;
    case Tooltip:
        prefix = "tooltip";
        break;
    case Complementary:
        prefix = "complementary";
        break;
    case Header:
        prefix = "header";
        break;
    default:
        break;
    }
    const auto role = [&prefix](const char *name) {
        QByteArray result(name);
        if (!prefix.isEmpty()) {
            result[0] = char(std::toupper(static_cast<unsigned char>(result[0])));
            result.prepend(prefix);
        }
        return result;
    };
    setTextColor(color(role("textColor").constData()));
    setBackgroundColor(color(role("backgroundColor").constData()));
    setAlternateBackgroundColor(color(role("alternateBackgroundColor").constData()));
    setHoverColor(color(role("hoverColor").constData()));
    setFocusColor(color(role("focusColor").constData()));

    setDisabledTextColor(color("disabledTextColor"));
    setHighlightColor(color("highlightColor"));
    setHighlightedTextColor(color("highlightedTextColor"));
    setActiveTextColor(color("activeTextColor"));
    setActiveBackgroundColor(color("activeBackgroundColor"));
    setLinkColor(color("linkColor"));
    setLinkBackgroundColor(color("linkBackgroundColor"));
    setVisitedLinkColor(color("visitedLinkColor"));
    setVisitedLinkBackgroundColor(color("visitedLinkBackgroundColor"));
    setNegativeTextColor(color("negativeTextColor"));
    setNegativeBackgroundColor(color("negativeBackgroundColor"));
    setNeutralTextColor(color("neutralTextColor"));
    setNeutralBackgroundColor(color("neutralBackgroundColor"));
    setPositiveTextColor(color("positiveTextColor"));
    setPositiveBackgroundColor(color("positiveBackgroundColor"));
    setDefaultFont(m_definition->property("defaultFont").value<QFont>());
    setSmallFont(m_definition->property("smallFont").value<QFont>());
}

void MaterialTheme::syncToQml()
{
    auto item = qobject_cast<QQuickItem *>(parent());
    if (m_definition && item && qmlAttachedPropertiesObject<PlatformTheme>(item, false) == this) {
        QMetaObject::invokeMethod(m_definition, "sync", Qt::DirectConnection, Q_ARG(QQuickItem *, item));
    }
}

bool MaterialTheme::event(QEvent *event)
{
    if (event->type() == PlatformThemeEvents::DataChangedEvent::type
        || event->type() == PlatformThemeEvents::ColorSetChangedEvent::type
        || event->type() == PlatformThemeEvents::ColorGroupChangedEvent::type) {
        syncColors();
    }
    if (event->type() == PlatformThemeEvents::ColorChangedEvent::type
        || event->type() == PlatformThemeEvents::FontChangedEvent::type) {
        syncToQml();
    }
    return PlatformTheme::event(event);
}

QColor MaterialTheme::tint(const QColor &color) const
{
    const auto item = qobject_cast<QQuickItem *>(parent());
    if ((item && !item->isEnabled()) || colorGroup() == Disabled) {
        return QColor::fromHsvF(color.hueF(), color.saturationF() * 0.5, color.valueF() * 0.8, color.alphaF());
    }
    if (colorGroup() == Inactive) {
        return QColor::fromHsvF(color.hueF(), color.saturationF() * 0.5, color.valueF(), color.alphaF());
    }
    return color;
}

#include "moc_materialtheme.cpp"
