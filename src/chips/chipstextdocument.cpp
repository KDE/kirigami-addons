/*
 * SPDX-FileCopyrightText: 2026 Kai Uwe Broulik <kde@broulik.de>
 *
 * SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL
 */

#include "chipstextdocument.h"

#include <QFontMetrics>
#include <QIcon>
#include <QPainter>
#include <QQmlEngine>
#include <QTextBlock>

#include "chipsmodel.h"

using namespace Qt::StringLiterals;

static constexpr int ChipObjectType = QTextFormat::UserObject + 1;
static constexpr int ChipObjectProperty = QTextFormat::UserProperty + 1;
static constexpr int ChipObjectIdProperty = QTextFormat::UserProperty + 2;

ChipObject *chipFromFormat(const QTextFormat &format)
{
    if (format.isValid() && format.objectType() == ChipObjectType) {
        return format.property(ChipObjectProperty).value<ChipObject *>();
    } else {
        return nullptr;
    }
}

ChipsTextDocument::ChipsTextDocument(QObject *parent)
    : QTextDocument(parent)
    , m_chipsModel(new ChipsModel(this))
    , m_suggestionsModel(new SuggestionsProxyModel(this))
{
    m_suggestionsModel->setSourceModel(m_chipsModel);
    connect(this, &QTextDocument::contentsChanged, this, &ChipsTextDocument::textChanged);

    // TODO we don't want line breaks, should be like a TextField
    // but maximumBlockCount also disables undo/redo...
    connect(this, &QTextDocument::blockCountChanged, this, [](int count) {
        if (count > 1) {
        }
    });

    documentLayout()->registerHandler(ChipObjectType, this);
}

ChipsTextDocument::~ChipsTextDocument() = default;

ChipsTextDocument::ChipsProperty ChipsTextDocument::chipsProperty()
{
    return ChipsProperty{this,
                         m_chipsModel,
                         &ChipsTextDocument::appendChip,
                         &ChipsTextDocument::chipCount,
                         &ChipsTextDocument::chipAt,
                         &ChipsTextDocument::clearChips};
}

void ChipsTextDocument::appendChip(ChipsTextDocument::ChipsProperty *prop, ChipObject *chip)
{
    return static_cast<ChipsModel *>(prop->data)->append(chip);
}

qsizetype ChipsTextDocument::chipCount(ChipsTextDocument::ChipsProperty *prop)
{
    return static_cast<ChipsModel *>(prop->data)->rowCount();
}

ChipObject *ChipsTextDocument::chipAt(ChipsTextDocument::ChipsProperty *prop, qsizetype index)
{
    return static_cast<ChipsModel *>(prop->data)->chipAt(index);
}

void ChipsTextDocument::clearChips(ChipsTextDocument::ChipsProperty *prop)
{
    return static_cast<ChipsModel *>(prop->data)->clear();
}

SuggestionsProxyModel *ChipsTextDocument::suggestionsModel() const
{
    return m_suggestionsModel;
}

QVariantList ChipsTextDocument::segments() const
{
    QVariantList result;
    for (auto block = begin(); block.isValid(); block = block.next()) {
        // TODO we only want a single block (no new lines) but maximumBlockCount also disables undo/redo...
        /*if (!result.isEmpty()) {
            result += '\n'_L1;
        }*/

        for (auto it = block.begin(); !it.atEnd(); ++it) {
            QTextFragment fragment = it.fragment();

            if (!fragment.isValid()) {
                continue;
            }

            auto *chip = chipFromFormat(fragment.charFormat());
            if (chip) {
                result.append(QVariant::fromValue(chip));
            } else {
                result.append(fragment.text());
            }
        }
    }

    return result;
}

QString ChipsTextDocument::text() const
{
    QString result;

    for (const auto &segment : segments()) {
        // TODO should we register a converter function so it calls our ChipObject.toString()?
        if (auto *chip = segment.value<ChipObject *>()) {
            result.append(chip->toString());
        } else {
            result.append(segment.toString());
        }
    }

    return result;
}

int ChipsTextDocument::spacing() const
{
    return m_spacing;
}

void ChipsTextDocument::setSpacing(int spacing)
{
    if (m_spacing == spacing) {
        return;
    }

    m_spacing = spacing;
    // TODO mark doc as dirty
    Q_EMIT spacingChanged(spacing);
}

int ChipsTextDocument::padding() const
{
    return m_padding;
}

void ChipsTextDocument::setPadding(int padding)
{
    if (m_padding == padding) {
        return;
    }

    m_padding = padding;
    // TODO mark doc as dirty
    Q_EMIT paddingChanged(padding);
}

int ChipsTextDocument::radius() const
{
    return m_radius;
}

void ChipsTextDocument::setRadius(int radius)
{
    if (m_radius == radius) {
        return;
    }

    m_radius = radius;
    // TODO mark doc as dirty
    Q_EMIT radiusChanged(radius);
}

int ChipsTextDocument::iconSize() const
{
    return m_iconSize;
}

void ChipsTextDocument::setIconSize(int iconSize)
{
    if (m_iconSize == iconSize || iconSize < 0) {
        return;
    }

    m_iconSize = iconSize;
    // TODO mark doc as dirty
    Q_EMIT iconSizeChanged(iconSize);
}

QFont ChipsTextDocument::font() const
{
    return m_font;
}

void ChipsTextDocument::setFont(const QFont &font)
{
    if (m_font == font) {
        return;
    }

    m_font = font;
    // TODO mark doc as dirty
    Q_EMIT fontChanged(font);
}

QColor ChipsTextDocument::foregroundColor() const
{
    return m_foregroundColor;
}

void ChipsTextDocument::setForegroundColor(const QColor &color)
{
    if (m_foregroundColor == color) {
        return;
    }

    m_foregroundColor = color;
    // TODO mark doc as dirty
    Q_EMIT foregroundColorChanged(color);
}

QColor ChipsTextDocument::backgroundColor() const
{
    return m_backgroundColor;
}

void ChipsTextDocument::setBackgroundColor(const QColor &color)
{
    if (m_backgroundColor == color) {
        return;
    }

    m_backgroundColor = color;
    // TODO mark doc as dirty
    Q_EMIT backgroundColorChanged(color);
}

void ChipsTextDocument::install(QQuickTextDocument *document)
{
    if (!document) {
        qmlEngine(this)->throwError(QJSValue::TypeError, u"Cannot install on a null document"_s);
        return;
    }

    document->setTextDocument(this);
}

void ChipsTextDocument::insertChipAt(ChipObject *chip, int start, int end)
{
    if (!chip) {
        qmlEngine(this)->throwError(QJSValue::TypeError);
        return;
    }

    /*if (cursorPos < 0 || cursorPos >= characterCount()) {
        qmlEngine(this)->throwError(QJSValue::RangeError);
        return;
    }*/

    if (!m_chipsModel->contains(chip)) {
        qmlEngine(this)->throwError(QJSValue::TypeError, u"Cannot insert ChipObject that has not been registered with this document first"_s);
        return;
    }

    QTextCursor cursor(this);
    cursor.setPosition(start);
    if (end != -1) {
        cursor.setPosition(end, QTextCursor::KeepAnchor);
    }

    QTextCharFormat format;
    format.setObjectType(ChipObjectType);
    format.setVerticalAlignment(QTextCharFormat::AlignTop);

    static int s_id = 0;
    // HACK When you add the same exact format in a row, Qt merges them
    // or at least doesn't render them the same ways as we expect.
    format.setProperty(ChipObjectIdProperty, ++s_id);
    // FIXME remove chip when it gets destroyed
    // FIXME update when chip changes
    format.setProperty(ChipObjectProperty, QVariant::fromValue(chip));

    cursor.insertText(QString(QChar::ObjectReplacementCharacter), format);
}

void ChipsTextDocument::replaceChipAt(ChipObject *newChip, int cursorPos)
{
    if (cursorPos < 0 || cursorPos >= characterCount()) {
        qmlEngine(this)->throwError(QJSValue::RangeError);
        return;
    }

    QTextCursor cursor(this);
    cursor.setPosition(cursorPos + 1);

    QTextCharFormat format = cursor.charFormat();

    if (!chipFromFormat(format)) {
        qmlEngine(this)->throwError(QJSValue::TypeError, u"No ChipObject at given position"_s);
        return;
    }

    cursor.movePosition(QTextCursor::PreviousCharacter, QTextCursor::KeepAnchor);

    format.setProperty(ChipObjectProperty, QVariant::fromValue(newChip));

    cursor.mergeCharFormat(format);
}

void ChipsTextDocument::removeChipAt(int cursorPos)
{
    if (cursorPos < 0 || cursorPos >= characterCount()) {
        qmlEngine(this)->throwError(QJSValue::RangeError);
        return;
    }

    QTextCursor cursor(this);
    cursor.setPosition(cursorPos + 1);

    QTextCharFormat format = cursor.charFormat();

    if (!chipFromFormat(format)) {
        qmlEngine(this)->throwError(QJSValue::TypeError, u"No ChipObject at given position"_s);
        return;
    }

    cursor.movePosition(QTextCursor::PreviousCharacter, QTextCursor::KeepAnchor);

    Q_ASSERT(cursor.selectedText().at(0) == QChar::ObjectReplacementCharacter);
    cursor.removeSelectedText();
}

ChipObject *ChipsTextDocument::chipAt(int cursorPos)
{
    QTextCursor cursor(this);
    cursor.setPosition(cursorPos);

    QTextCharFormat format = cursor.charFormat();
    return chipFromFormat(format);
}

ChipObject *ChipsTextDocument::chipAt(qreal x, qreal y)
{
    auto *layout = documentLayout();

    QTextFormat format = layout->formatAt(QPointF{x, y});

    return chipFromFormat(format);
}

int ChipsTextDocument::cursorPositionForChipPosition(qreal x, qreal y)
{
    auto *layout = documentLayout();

    const QPointF point{x, y};
    int pos = layout->hitTest(point, Qt::ExactHit);

    if (pos < 0) {
        return -1;
    }

    QTextFormat format = layout->formatAt(point);

    if (!chipFromFormat(format)) {
        return -1;
    }

    return pos;
}

/*int ChipsTextDocument::cursorPositionForChip(ChipObject *chip)
{
    for (QTextBlock block = begin(); block.isValid(); block = block.next()) {
        for (QTextBlock::Iterator it = block.begin(); !it.atEnd(); ++it) {
            QTextFragment fragment = it.fragment();

            if (!fragment.isValid()) {
                continue;
            }

            if (chipFromFormat(fragment.charFormat()) == chip) {
                return fragment.position();
            }
        }
    }

    return -1;
}*/

QSizeF ChipsTextDocument::intrinsicSize(QTextDocument *doc, int posInDocument, const QTextFormat &format)
{
    Q_ASSERT(doc == this);
    Q_UNUSED(posInDocument);
    Q_ASSERT(format.objectType() == ChipObjectType);

    auto *chip = chipFromFormat(format);
    Q_ASSERT(chip);
    if (!chip) {
        return {};
    }

    QFontMetricsF metrics{m_font};
    // FIXME code duplication.
    QString label;
    // TODO configurable whether to show the preview or not
    // or maybe add a callback valueToText style?
    if (const QString preview = chip->preview(); !preview.isEmpty()) {
        label = preview;
    } else {
        label = ChipObject::displayText(chip);
    }

    return QSizeF{metrics.horizontalAdvance(label) + 2 * m_padding, metrics.height() + 2 * m_padding};
}

void ChipsTextDocument::drawObject(QPainter *painter, const QRectF &rect, QTextDocument *doc, int posInDocument, const QTextFormat &format)
{
    Q_ASSERT(doc == this);
    Q_UNUSED(posInDocument);
    Q_ASSERT(format.objectType() == ChipObjectType);

    auto *chip = chipFromFormat(format);
    Q_ASSERT(chip);
    if (!chip) {
        return;
    }

    auto *group = ChipGroup::groupForChip(chip);

    QColor backgroundColor = chip->backgroundColor();
    if (!backgroundColor.isValid() && group) {
        backgroundColor = group->backgroundColor();
    }
    if (!backgroundColor.isValid()) {
        backgroundColor = m_backgroundColor;
    }

    QColor foregroundColor = chip->foregroundColor();
    if (!foregroundColor.isValid() && group) {
        foregroundColor = group->foregroundColor();
    }
    if (!foregroundColor.isValid()) {
        foregroundColor = m_foregroundColor;
    }

    painter->save();

    QRectF adjustedRect = rect;

    if (m_radius > 0) {
        painter->setRenderHint(QPainter::Antialiasing);
    }

    // TODO pen
    painter->setBrush(backgroundColor);
    painter->drawRoundedRect(adjustedRect.adjusted(+0.5, +0.5, -0.5, -0.5), m_radius, m_radius);

    painter->setFont(m_font);
    QString label;
    // TODO configurable whether to show the preview or not
    // or maybe add a callback valueToText style?
    if (const QString preview = chip->preview(); !preview.isEmpty()) {
        label = preview;
    } else {
        label = ChipObject::displayText(chip);
    }
    painter->drawText(adjustedRect, Qt::AlignCenter, label);

    painter->restore();
}

#include "moc_chipstextdocument.cpp"
