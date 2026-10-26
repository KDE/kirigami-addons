/*
 * SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "materialtheme.h"

#include <Kirigami/Platform/PlatformPluginFactory>
#include <Kirigami/Platform/Units>
#include <QQmlEngine>

class MaterialUnits : public Kirigami::Platform::Units
{
public:
    explicit MaterialUnits(QObject *parent)
        : Units(parent)
    {
    }
};

class KirigamiMaterialFactory : public Kirigami::Platform::PlatformPluginFactory
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID PlatformPluginFactory_iid)
    Q_INTERFACES(Kirigami::Platform::PlatformPluginFactory)

public:
    using PlatformPluginFactory::PlatformPluginFactory;

    Kirigami::Platform::PlatformTheme *createPlatformTheme(QObject *parent) override
    {
        auto definition = MaterialTheme::themeDefinition(qmlEngine(parent));
        return definition ? new MaterialTheme(parent, definition) : nullptr;
    }

    Kirigami::Platform::Units *createUnits(QObject *parent) override
    {
        return new MaterialUnits(parent);
    }
};

#include "materialfactory.moc"
