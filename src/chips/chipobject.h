/*
 * SPDX-FileCopyrightText: 2026 Kai Uwe Broulik <kde@broulik.de>
 *
 * SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL
 */

#pragma once

#include <QColor>
#include <QFont>
#include <QObject>
#include <QVariant>

#include <qqmlregistration.h>

class ChipObject : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString label READ label WRITE setLabel NOTIFY labelChanged)
    Q_PROPERTY(QVariant value READ value WRITE setValue RESET value NOTIFY valueChanged)
    Q_PROPERTY(QString preview READ preview WRITE setPreview NOTIFY previewChanged)

    // Q_PROPERTY(QFont font READ font WRITE setFont NOTIFY fontChanged)
    Q_PROPERTY(QColor foregroundColor READ foregroundColor WRITE setForegroundColor RESET resetForegroundColor NOTIFY foregroundColorChanged)
    Q_PROPERTY(QColor backgroundColor READ backgroundColor WRITE setBackgroundColor RESET resetBackgroundColor NOTIFY backgroundColorChanged)

public:
    explicit ChipObject(QObject *parent = nullptr);
    ~ChipObject() override;

    QString label() const;
    void setLabel(const QString &label);
    Q_SIGNAL void labelChanged(const QString &label);

    QVariant value() const;
    void setValue(const QVariant &value);
    void resetValue();
    Q_SIGNAL void valueChanged(const QVariant &value);

    QString preview() const;
    void setPreview(const QString &preview);
    Q_SIGNAL void previewChanged(const QString &preview);

    QColor foregroundColor() const;
    void setForegroundColor(const QColor &color);
    void resetForegroundColor();
    Q_SIGNAL void foregroundColorChanged(const QColor &color);

    QColor backgroundColor() const;
    void setBackgroundColor(const QColor &color);
    void resetBackgroundColor();
    Q_SIGNAL void backgroundColorChanged(const QColor &color);

    // TODO also changes console.log, so maybe remove again
    Q_INVOKABLE QString toString() const;

    static QString displayText(ChipObject *chip);

private:
    QString m_label;
    QVariant m_value;
    QString m_preview;
    //    QFont m_font;
    QColor m_foregroundColor;
    QColor m_backgroundColor;
};
