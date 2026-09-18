// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "datetime.h"

#include <QLocale>
#include <QRegularExpression>

using namespace KirigamiAddonsDateAndTime;

DateTime::DateTime(QDateTime dateTime)
    : m_dateTime(std::move(dateTime))
{
}

QDateTime DateTime::dateTime() const
{
    return m_dateTime;
}

void DateTime::setDateTime(const QDateTime &dateTime)
{
    m_dateTime = dateTime;
}

QDate DateTime::date() const
{
    return m_dateTime.date();
}

void DateTime::setDate(const QDate &date)
{
    m_dateTime.setDate(date);
}

QTime DateTime::time() const
{
    return m_dateTime.time();
}

void DateTime::setTime(const QTime &time)
{
    m_dateTime.setTime(time);
}

int DateTime::year() const
{
    return m_dateTime.date().year();
}

void DateTime::setYear(int year)
{
    const auto date = m_dateTime.date();
    m_dateTime.setDate(QDate(year, date.month(), date.day()));
}

int DateTime::month() const
{
    return m_dateTime.date().month();
}

void DateTime::setMonth(int month)
{
    const auto date = m_dateTime.date();
    m_dateTime.setDate(QDate(date.year(), month, date.day()));
}

int DateTime::day() const
{
    return m_dateTime.date().day();
}

void DateTime::setDay(int day)
{
    const auto date = m_dateTime.date();
    m_dateTime.setDate(QDate(date.year(), date.month(), day));
}

int DateTime::hour() const
{
    return m_dateTime.time().hour();
}

void DateTime::setHour(int hour)
{
    const auto time = m_dateTime.time();
    m_dateTime.setTime(QTime(hour, time.minute(), time.second(), time.msec()));
}

int DateTime::minute() const
{
    return m_dateTime.time().minute();
}

void DateTime::setMinute(int minute)
{
    const auto time = m_dateTime.time();
    m_dateTime.setTime(QTime(time.hour(), minute, time.second(), time.msec()));
}

int DateTime::second() const
{
    return m_dateTime.time().second();
}

void DateTime::setSecond(int second)
{
    const auto time = m_dateTime.time();
    m_dateTime.setTime(QTime(time.hour(), time.minute(), second, time.msec()));
}

QTimeZone DateTime::timeZone() const
{
    return m_dateTime.timeZone();
}

void DateTime::setTimeZone(const QTimeZone &timeZone)
{
    m_dateTime.setTimeZone(timeZone);
}

bool DateTime::isValid() const
{
    return m_dateTime.isValid();
}

bool DateTime::isToday() const
{
    return m_dateTime.toLocalTime().date() == QDate::currentDate();
}

bool DateTime::isCurrentMonth() const
{
    const auto date = m_dateTime.toLocalTime().date();
    const auto today = QDate::currentDate();
    return date.year() == today.year() && date.month() == today.month();
}

bool DateTime::isCurrentYear() const
{
    return m_dateTime.toLocalTime().date().year() == QDate::currentDate().year();
}

QString DateTime::shortDate() const
{
    static const QRegularExpression yearToken(QStringLiteral("y+"));
    static const QRegularExpression edgeSeparators(QStringLiteral("^[\\s\\-./,]+|[\\s\\-./,]+$"));

    QString format = QLocale().dateFormat(QLocale::ShortFormat);
    format.remove(yearToken);
    format.remove(edgeSeparators);

    return QLocale().toString(m_dateTime.toLocalTime().date(), format);
}

QString DateTime::toLocaleDateString(const QString &format) const
{
    return QLocale().toString(m_dateTime.toLocalTime(), format);
}

QString DateTime::toLocaleDateString() const
{
    return QLocale().toString(m_dateTime.toLocalTime(), QLocale::ShortFormat);
}

DateTime DateTime::addDays(int days) const
{
    return DateTime(m_dateTime.addDays(days));
}

DateTime DateTime::addMonths(int months) const
{
    return DateTime(m_dateTime.addMonths(months));
}

DateTime DateTime::addYears(int years) const
{
    return DateTime(m_dateTime.addYears(years));
}

DateTime DateTime::addSecs(qint64 secs) const
{
    return DateTime(m_dateTime.addSecs(secs));
}

DateTime DateTime::startOfDay() const
{
    return DateTime(m_dateTime.date().startOfDay(m_dateTime.timeZone()));
}

DateTime DateTime::startOfMonth() const
{
    const QDate date = m_dateTime.date();
    return DateTime(QDate(date.year(), date.month(), 1).startOfDay(m_dateTime.timeZone()));
}

DateTime DateTime::endOfMonth() const
{
    const QDate date = m_dateTime.date();
    return DateTime(QDate(date.year(), date.month(), date.daysInMonth()).startOfDay(m_dateTime.timeZone()));
}

DateTime DateTime::endOfYear() const
{
    return DateTime(QDate(m_dateTime.date().year(), 12, 31).startOfDay(m_dateTime.timeZone()));
}

bool DateTime::operator==(const QDateTime &right) const
{
    return m_dateTime == right;
}

bool DateTime::operator==(const DateTime &right) const
{
    return m_dateTime == right.m_dateTime;
}

bool DateTime::operator<(const QDateTime &right) const
{
    return m_dateTime < right;
}

bool DateTime::operator<(const DateTime &right) const
{
    return m_dateTime < right.m_dateTime;
}

bool DateTime::operator<=(const QDateTime &right) const
{
    return m_dateTime <= right;
}

bool DateTime::operator<=(const DateTime &right) const
{
    return m_dateTime <= right.m_dateTime;
}

bool DateTime::operator>(const QDateTime &right) const
{
    return m_dateTime > right;
}

bool DateTime::operator>(const DateTime &right) const
{
    return m_dateTime > right.m_dateTime;
}

bool DateTime::operator>=(const QDateTime &right) const
{
    return m_dateTime >= right;
}

bool DateTime::operator>=(const DateTime &right) const
{
    return m_dateTime >= right.m_dateTime;
}
