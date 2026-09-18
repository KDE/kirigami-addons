/*
 * SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include <QLocale>
#include <QTest>
#include <QTimeZone>

#include "datetime.h"

using namespace KirigamiAddonsDateAndTime;

class DateTimeTest : public QObject
{
    Q_OBJECT

private Q_SLOTS:
    void testDefaultIsInvalid()
    {
        DateTime dt;
        QVERIFY(!dt.isValid());
    }

    void testRoundTripPreservesTimeZone()
    {
        const QDateTime source(QDate(2024, 3, 15), QTime(10, 30, 0), QTimeZone("America/New_York"));
        DateTime dt(source);

        QVERIFY(dt.isValid());
        QCOMPARE(dt.dateTime(), source);
        QCOMPARE(dt.timeZone(), QTimeZone("America/New_York"));
    }

    void testComponentAccessors()
    {
        const DateTime dt(QDateTime(QDate(2024, 3, 15), QTime(10, 30, 45)));

        QCOMPARE(dt.year(), 2024);
        QCOMPARE(dt.month(), 3);
        QCOMPARE(dt.day(), 15);
        QCOMPARE(dt.hour(), 10);
        QCOMPARE(dt.minute(), 30);
        QCOMPARE(dt.second(), 45);
    }

    void testComponentMutatorsPreserveOtherFields()
    {
        DateTime dt(QDateTime(QDate(2024, 3, 15), QTime(10, 30, 45), QTimeZone("Europe/Berlin")));

        dt.setYear(2025);
        QCOMPARE(dt.year(), 2025);
        QCOMPARE(dt.month(), 3);
        QCOMPARE(dt.day(), 15);
        QCOMPARE(dt.timeZone(), QTimeZone("Europe/Berlin"));

        dt.setMonth(11);
        QCOMPARE(dt.month(), 11);
        QCOMPARE(dt.day(), 15);

        dt.setDay(2);
        QCOMPARE(dt.day(), 2);

        dt.setHour(23);
        QCOMPARE(dt.hour(), 23);
        QCOMPARE(dt.minute(), 30);

        dt.setMinute(5);
        QCOMPARE(dt.minute(), 5);
        QCOMPARE(dt.second(), 45);

        dt.setSecond(1);
        QCOMPARE(dt.second(), 1);

        QCOMPARE(dt.timeZone(), QTimeZone("Europe/Berlin"));
    }

    void testAddHelpersReturnANewValue()
    {
        const DateTime dt(QDateTime(QDate(2024, 1, 31), QTime(0, 0)));

        QCOMPARE(dt.addDays(1).date(), QDate(2024, 2, 1));
        QCOMPARE(dt.addMonths(1).date(), QDate(2024, 2, 29));
        QCOMPARE(dt.addYears(1).date(), QDate(2025, 1, 31));
        QCOMPARE(dt.addSecs(3600).time(), QTime(1, 0));

        QCOMPARE(dt.date(), QDate(2024, 1, 31));
    }

    void testIsToday()
    {
        QVERIFY(DateTime(QDateTime::currentDateTime()).isToday());
        QVERIFY(!DateTime(QDateTime(QDate(2000, 1, 1), QTime(0, 0))).isToday());
        QVERIFY(!DateTime().isToday());
    }

    void testIsCurrentMonthAndYear()
    {
        const auto today = QDate::currentDate();
        QVERIFY(DateTime(QDateTime::currentDateTime()).isCurrentMonth());
        QVERIFY(DateTime(QDateTime::currentDateTime()).isCurrentYear());

        const DateTime lastYear(QDateTime(QDate(today.year() - 1, today.month(), 1), QTime(0, 0)));
        QVERIFY(!lastYear.isCurrentMonth());
        QVERIFY(!lastYear.isCurrentYear());

        QVERIFY(!DateTime().isCurrentMonth());
        QVERIFY(!DateTime().isCurrentYear());
    }

    void testShortDate()
    {
        const QLocale previousLocale;
        QLocale::setDefault(QLocale(QLocale::English, QLocale::UnitedStates));

        const QString result = DateTime(QDateTime(QDate(2024, 3, 15), QTime(0, 0))).shortDate();
        QVERIFY(!result.contains(QStringLiteral("2024")));
        QVERIFY(!result.contains(QStringLiteral("24")));
        QVERIFY(result.contains(QStringLiteral("3")));
        QVERIFY(result.contains(QStringLiteral("15")));

        QLocale::setDefault(previousLocale);
    }

    void testToLocaleDateString()
    {
        const QLocale previousLocale;
        QLocale::setDefault(QLocale(QLocale::English, QLocale::UnitedStates));

        const DateTime dt(QDateTime(QDate(2024, 3, 15), QTime(0, 0)));
        QCOMPARE(dt.toLocaleDateString(QStringLiteral("yyyy")), QStringLiteral("2024"));
        QCOMPARE(dt.toLocaleDateString(QStringLiteral("MMMM")), QStringLiteral("March"));
        QCOMPARE(dt.toLocaleDateString(QStringLiteral("d")), QStringLiteral("15"));

        QLocale::setDefault(previousLocale);
    }

    void testStartOfDay()
    {
        const DateTime dt(QDateTime(QDate(2024, 3, 15), QTime(14, 30, 15), QTimeZone("Europe/Berlin")));
        const DateTime startOfDay = dt.startOfDay();

        QCOMPARE(startOfDay.date(), dt.date());
        QCOMPARE(startOfDay.hour(), 0);
        QCOMPARE(startOfDay.minute(), 0);
        QCOMPARE(startOfDay.second(), 0);
        QCOMPARE(startOfDay.timeZone(), QTimeZone("Europe/Berlin"));

        QVERIFY(!DateTime().startOfDay().isValid());
    }

    void testStartOfEndOfMonthAndYear()
    {
        const DateTime dt(QDateTime(QDate(2024, 2, 15), QTime(14, 30), QTimeZone("Europe/Berlin")));

        QCOMPARE(dt.startOfMonth().date(), QDate(2024, 2, 1));
        QCOMPARE(dt.endOfMonth().date(), QDate(2024, 2, 29)); // 2024 is a leap year
        QCOMPARE(dt.endOfYear().date(), QDate(2024, 12, 31));

        QCOMPARE(dt.startOfMonth().timeZone(), QTimeZone("Europe/Berlin"));
    }

    void testEquality()
    {
        const QDateTime source(QDate(2024, 3, 15), QTime(10, 30));
        DateTime a(source);
        DateTime b(source);

        QVERIFY(a == b);
        QVERIFY(a == source);

        b.setMinute(31);
        QVERIFY(!(a == b));
    }

    void testOrdering()
    {
        const DateTime earlier(QDateTime(QDate(2024, 3, 15), QTime(10, 0)));
        const DateTime later(QDateTime(QDate(2024, 3, 15), QTime(11, 0)));

        QVERIFY(earlier < later);
        QVERIFY(earlier <= later);
        QVERIFY(earlier <= earlier);
        QVERIFY(later > earlier);
        QVERIFY(later >= earlier);
        QVERIFY(later >= later);
        QVERIFY(!(later < earlier));
        QVERIFY(!(earlier > later));

        QVERIFY(earlier < later.dateTime());
        QVERIFY(later > earlier.dateTime());
    }
};

QTEST_GUILESS_MAIN(DateTimeTest)

#include "tst_datetime.moc"
