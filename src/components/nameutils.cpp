// SPDX-FileCopyrightText: 2020 Carson Black <uhhadd@gmail.com>
//
// SPDX-License-Identifier: LGPL-2.0-or-later

#include "nameutils.h"
#include <QDebug>
#include <QMap>
#include <QQuickStyle>
#include <QTextBoundaryFinder>
#include <QVector>

#include <array>

bool contains(const QString &str, QChar::Script s)
{
    for (auto rune : str) {
        if (rune.script() == s) {
            return true;
        }
    }
    return false;
}

QString NameUtils::initialsFromString(const QString &string)
{
    // "" -> ""
    QString normalized = string.trimmed();
    if (normalized.isEmpty()) {
        return {};
    }

    normalized = string.normalized(QString::NormalizationForm_D);

    if (normalized.startsWith(QLatin1Char('#')) || normalized.startsWith(QLatin1Char('@'))) {
        normalized.remove(0, 1);
    }

    // Names written with Han and Hangul characters generally can be initialised by taking the
    // first character
    if (contains(normalized, QChar::Script_Han) || contains(normalized, QChar::Script_Hangul)) {
        return normalized.at(0);
    }

    // "FirstName Name Name LastName"
    normalized = normalized.trimmed();

    // Remove stuff inside parantheses
    normalized = normalized.split(QLatin1Char('('))[0];

    if (normalized.isEmpty()) {
        return {};
    }

    if (normalized.contains(QLatin1Char(' '))) {
        // "FirstName Name Name LastName" -> "FirstName" "Name" "Name" "LastName"
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
        const auto split = QStringView(normalized).split(QLatin1Char(' '));
#else
        const auto split = normalized.splitRef(QLatin1Char(' '));
#endif

        // "FirstName"
        auto first = split.first();
        // "LastName"
        auto last = split.last();
        if (first.isEmpty()) {
            // "" "LastName" -> "L"
            return QString(last.front()).toUpper();
        }
        if (last.isEmpty()) {
            // "FirstName" "" -> "F"
            return QString(first.front()).toUpper();
        }
        // "FirstName" "LastName" -> "FL"
        return (QString(first.front()) + last.front()).toUpper();
        // "OneName"
    } else {
        // "OneName" -> "O"
        return QString(normalized.front()).toUpper();
    }
}

/* clang-format off */
const QMap<QString,QList<QColor>> c_colors = {
    {
        QStringLiteral("default"),
        {
            QColor(0xe93a9a),
            QColor(0xe93d58),
            QColor(0xe9643a),
            QColor(0xef973c),
            QColor(0xe8cb2d),
            QColor(0xb6e521),
            QColor(0x3dd425),
            QColor(0x00d485),
            QColor(0x00d3b8),
            QColor(0x3daee9),
            QColor(0xb875dc),
            QColor(0x926ee4),
        }
    },
    {
        QStringLiteral("Material"),
        {
            QColor(0xf44336),
            QColor(0xe91e63),
            QColor(0x9c27b0),
            QColor(0x673ab7),
            QColor(0x3f51b5),
            QColor(0x2196f3),
            QColor(0x03a9f4),
            QColor(0x00bcd4),
            QColor(0x009688),
            QColor(0x4caf50),
            QColor(0x8bc34a),
            QColor(0xcddc39),
            QColor(0xffeb3b),
            QColor(0xffc107),
            QColor(0xff9800),
            QColor(0xff5722),
        }
    }
};
/* clang-format on */

QList<QColor> grabColors()
{
    if (c_colors.contains(QQuickStyle::name())) {
        return c_colors[QQuickStyle::name()];
    }
    return c_colors[QStringLiteral("default")];
}

auto NameUtils::colorsFromString(const QString &string) -> QColor
{
    // We use a hash to get a "random" number that's always the same for
    // a given string.
    auto hash = qHash(string);
    // hash modulo the length of the colors list minus one will always get us a valid
    // index
    const auto colors = grabColors();
    auto index = hash % (colors.length() - 1);
    // return a colour
    return colors[index];
}

auto NameUtils::isStringUnsuitableForInitials(const QString &string) -> bool
{
    if (string.isEmpty()) {
        return true;
    }

    bool isNumber;
    string.toFloat(&isNumber);
    if (isNumber) {
        return true;
    }

    static const std::array<QChar::Script, 6> scripts{
        QChar::Script_Common, QChar::Script_Inherited, QChar::Script_Latin,
        QChar::Script_Han,    QChar::Script_Hangul,    QChar::Script_Cyrillic};

    std::any_of(string.cbegin(), string.cend(), [](const QChar &character) {
        return std::find(scripts.begin(), scripts.end(), character.script()) == scripts.end();
    });

    return false;
}

#include "moc_nameutils.cpp"
