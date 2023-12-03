/*
 *  SPDX-FileCopyrightText: 2020 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "treeviewplugin.h"

#include <QFile>
#include <QQuickStyle>

#include <QQmlEngine>

static QString s_selectedStyle;

TreeViewPlugin::TreeViewPlugin(QObject *parent)
    : QQmlExtensionPlugin(parent)
{
    m_stylesFallbackChain << QString();
}

QUrl TreeViewPlugin::componentUrl(const QString &fileName) const
{
    for (const QString &style : std::as_const(m_stylesFallbackChain)) {
        const QString candidate = QStringLiteral("styles/") + style + QLatin1Char('/') + fileName;
        if (QFile::exists(resolveFilePath(candidate))) {
            return QUrl(resolveFileUrl(candidate));
        }
    }

    return QUrl(resolveFileUrl(fileName));
}

void TreeViewPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(QLatin1String(uri) == QLatin1String("org.kde.kirigamiaddons.treeview"));
    const QString style = QQuickStyle::name();


#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
    //org.kde.desktop.plasma is a couple of files that fall back to desktop by purpose
    if (style.isEmpty() && QFile::exists(resolveFilePath(QStringLiteral("/styles/org.kde.desktop")))) {
        m_stylesFallbackChain.prepend(QStringLiteral("org.kde.desktop"));
    }
#endif

    if (!style.isEmpty() && QFile::exists(resolveFilePath(QStringLiteral("/styles/") + style)) && !m_stylesFallbackChain.contains(style)) {
        m_stylesFallbackChain.prepend(style);
    }

    //At this point the fallback chain will be selected->org.kde.desktop->Fallback
    s_selectedStyle = m_stylesFallbackChain.first();

    qmlRegisterType(componentUrl(QStringLiteral("TreeViewDecoration.qml")), uri, 1, 0, "TreeViewDecoration");
    

    qmlProtectModule(uri, 2);
}

#include "treeviewplugin.moc"

#include "moc_treeviewplugin.cpp"
