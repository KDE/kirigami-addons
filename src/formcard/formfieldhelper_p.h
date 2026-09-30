// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QObject>
#include <QVariant>
#include <qqmlregistration.h>

// Internal helper for updating delegate properties without removing bindings
// supplied by their callers.
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
        setPropertyValue(field, QStringLiteral("text"), text);
    }

    Q_INVOKABLE void setPropertyValue(QObject *field, const QString &property, const QVariant &value)
    {
        if (field) {
            field->setProperty(property.toUtf8().constData(), value);
        }
    }
};
