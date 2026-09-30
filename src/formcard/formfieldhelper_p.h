// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QObject>
#include <qqmlregistration.h>

// Internal helper for updating a delegate's inherited text property without
// removing a binding supplied by its caller.
class FormFieldHelper : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit FormFieldHelper(QObject *parent = nullptr)
        : QObject(parent)
    {
    }

    Q_INVOKABLE void setText(QObject *field, const QString &text)
    {
        if (field) {
            field->setProperty("text", text);
        }
    }
};
