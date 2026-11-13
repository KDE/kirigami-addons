/*
 * SPDX-FileCopyrightText: 2026 Kai Uwe Broulik <kde@broulik.de>
 *
 * SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL
 */

#pragma once

#include <QColor>
#include <QFont>
#include <QQuickTextDocument>
#include <QTextDocument>
#include <QTextObjectInterface>

#include <qqmlregistration.h>

#include "chipobject.h"
#include "suggestionsproxymodel.h"

class ChipsModel;

class ChipsTextDocument : public QTextDocument, public QTextObjectInterface
{
    Q_OBJECT
    QML_ELEMENT
    Q_INTERFACES(QTextObjectInterface)

    Q_PROPERTY(QQmlListProperty<ChipObject> chips READ chipsProperty)

    Q_PROPERTY(SuggestionsProxyModel *suggestionsModel READ suggestionsModel CONSTANT)

    Q_PROPERTY(QVariantList segments READ segments NOTIFY textChanged)
    Q_PROPERTY(QString text READ text NOTIFY textChanged)

    // TODO max width of chip

    // TODO can we get this from platform directly?
    Q_PROPERTY(int spacing READ spacing WRITE setSpacing NOTIFY spacingChanged)
    Q_PROPERTY(int padding READ padding WRITE setPadding NOTIFY paddingChanged)
    Q_PROPERTY(int radius READ radius WRITE setRadius NOTIFY radiusChanged)
    Q_PROPERTY(int iconSize READ iconSize WRITE setIconSize NOTIFY iconSizeChanged)
    Q_PROPERTY(QFont font READ font WRITE setFont NOTIFY fontChanged)
    Q_PROPERTY(QColor foregroundColor READ foregroundColor WRITE setForegroundColor NOTIFY foregroundColorChanged)
    Q_PROPERTY(QColor backgroundColor READ backgroundColor WRITE setBackgroundColor NOTIFY backgroundColorChanged)

public:
    explicit ChipsTextDocument(QObject *parent = nullptr);
    ~ChipsTextDocument() override;

    using ChipsProperty = QQmlListProperty<ChipObject>;
    ChipsProperty chipsProperty();
    static void appendChip(ChipsProperty *prop, ChipObject *chip);
    static qsizetype chipCount(ChipsProperty *prop);
    static ChipObject *chipAt(ChipsProperty *prop, qsizetype index);
    static void clearChips(ChipsProperty *prop);

    SuggestionsProxyModel *suggestionsModel() const;

    QVariantList segments() const;

    QString text() const;
    Q_SIGNAL void textChanged();

    int spacing() const;
    void setSpacing(int spacing);
    Q_SIGNAL void spacingChanged(int spacing);

    int padding() const;
    void setPadding(int padding);
    Q_SIGNAL void paddingChanged(int padding);

    int radius() const;
    void setRadius(int radius);
    Q_SIGNAL void radiusChanged(int radius);

    int iconSize() const;
    void setIconSize(int iconSize);
    Q_SIGNAL void iconSizeChanged(int iconSize);

    QFont font() const;
    void setFont(const QFont &font);
    Q_SIGNAL void fontChanged(const QFont &font);

    QColor foregroundColor() const;
    void setForegroundColor(const QColor &color);
    Q_SIGNAL void foregroundColorChanged(const QColor &color);

    QColor backgroundColor() const;
    void setBackgroundColor(const QColor &color);
    Q_SIGNAL void backgroundColorChanged(const QColor &color);

    QSizeF intrinsicSize(QTextDocument *doc, int posInDocument, const QTextFormat &format) override;
    void drawObject(QPainter *painter, const QRectF &rect, QTextDocument *doc, int posInDocument, const QTextFormat &format) override;

    Q_INVOKABLE void install(QQuickTextDocument *document);

    Q_INVOKABLE void insertChipAt(ChipObject *chip, int start, int end = -1);
    Q_INVOKABLE void replaceChipAt(ChipObject *newChip, int cursorPos);
    Q_INVOKABLE void removeChipAt(int cursorPos);
    Q_INVOKABLE ChipObject *chipAt(int cursorPos);
    Q_INVOKABLE ChipObject *chipAt(qreal x, qreal y);
    Q_INVOKABLE int cursorPositionForChipPosition(qreal x, qreal y);
    // Problematic because you can add the same chip multiple times.
    // Q_INVOKABLE int cursorPositionForChip(ChipObject *chip);

private:
    ChipsModel *m_chipsModel;
    SuggestionsProxyModel *m_suggestionsModel;

    int m_spacing = 0;
    int m_padding = 0;
    int m_radius = 0;
    int m_iconSize = 16;
    QFont m_font;
    QColor m_foregroundColor;
    QColor m_backgroundColor;
};
