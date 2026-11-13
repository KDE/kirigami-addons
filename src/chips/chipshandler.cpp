/*
 * SPDX-FileCopyrightText: 2026 Kai Uwe Broulik <kde@broulik.de>
 *
 * SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL
 */

#include "chipstextdocument.h"

#include <QQmlEngine>

using namespace Qt::StringLiterals;

ChipsTextDocument::ChipsTextDocument(QObject *parent)
    : QTextDocument(parent)
{
}

ChipsTextDocument::~ChipsTextDocument() = default;

void ChipsTextDocument::install(QQuickTextDocument *document)
{
    if (!document) {
        qmlEngine(this)->throwError(QJSValue::TypeError, u"Cannot install on a null document"_s);
        return;
    }

    document->setTextDocument(this);
}

#include "moc_chipstextdocument.cpp"
