/*
 *  SPDX-FileCopyrightText: 2020 Arjen Hiemstra <ahiemstra@heimr.nl>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include <QtQuickTest>
#include <QQmlEngine>
#include <QQmlContext>

#include <KLocalizedContext>
#include <KLocalizedString>

#include "example_albummodel.h"

class KirigamiAddonsSetup : public QObject
{
    Q_OBJECT

public:
    KirigamiAddonsSetup()
    {
    }

public Q_SLOTS:
    void qmlEngineAvailable(QQmlEngine *engine)
    {
        KLocalizedString::setApplicationDomain("kirigami-addons");
        engine->rootContext()->setContextObject(new KLocalizedContext(engine));

        qmlRegisterType<ExampleAlbumModel>("test.artefacts", 1, 0, "ExampleAlbumModel");
    }
};

QUICK_TEST_MAIN_WITH_SETUP(KirigamiAddons, KirigamiAddonsSetup)

#include "qmltests.moc"
