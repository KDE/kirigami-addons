// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include <QMetaEnum>
#include <QVariant>
#include <cmath>
#include "infinitecalendarviewmodel.h"

using namespace KirigamiAddonsDateAndTime;

InfiniteCalendarViewModel::InfiniteCalendarViewModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

void InfiniteCalendarViewModel::classBegin()
{

}

void InfiniteCalendarViewModel::componentComplete()
{
    m_isCompleted = true;
    setup();
}

void InfiniteCalendarViewModel::setup()
{
    if (!m_isCompleted) {
        return;
    }

    if (!m_currentDate.isValid()) {
        return;
    }

    const QDateTime currentDate = m_currentDate.dateTime();

    switch (m_scale) {
    case WeekScale: {
        QDateTime firstDay = currentDate.addDays(-currentDate.date().dayOfWeek() + m_locale.firstDayOfWeek());
        // We create dates before and after where our view will start from (which is m_currentDate)
        firstDay = firstDay.addDays((-m_datesToAdd * 7) / 2);

        addWeekDates(true, firstDay);
        break;
    }
    case MonthScale: {
        QDateTime firstDay(QDate(currentDate.date().year(), currentDate.date().month(), 1), {});
        firstDay = firstDay.addMonths(-m_datesToAdd / 2);

        addMonthDates(true, firstDay);
        break;
    }
    case YearScale: {
        QDateTime firstDay(QDate(currentDate.date().year(), currentDate.date().month(), 1), {});
        firstDay = firstDay.addYears(-m_datesToAdd / 2);

        addYearDates(true, firstDay);
        break;
    }
    case DecadeScale: {
        const int firstYear = ((floor(currentDate.date().year() / 10)) * 10) - 1; // E.g. For 2020 have view start at 2019...
        QDateTime firstDay(QDate(firstYear, currentDate.date().month(), 1), {});
        firstDay = firstDay.addYears(((-m_datesToAdd * 12) / 2) + 10); // 3 * 4 grid so 12 years, end at 2030, and align for mid index to be current decade

        addDecadeDates(true, firstDay);
        break;
    }
    }
}

QVariant InfiniteCalendarViewModel::data(const QModelIndex &idx, int role) const
{
    if (!hasIndex(idx.row(), idx.column())) {
        return {};
    }

    if (m_scale == MonthScale && role != StartDateRole) {
        const DateTime firstDay(m_firstDayOfMonthDates[idx.row()]);

        switch (role) {
        case FirstDayOfMonthRole:
            return QVariant::fromValue(firstDay.startOfDay());
        case SelectedMonthRole:
            return firstDay.month();
        case SelectedYearRole:
            return firstDay.year();
        default:
            qWarning() << "Unknown role for firstDay:" << QMetaEnum::fromType<Roles>().valueToKey(role);
            return {};
        }
    }

    const DateTime startDate(m_startDates[idx.row()]);

    switch (role) {
    case FirstDayOfMonthRole: {
        DateTime firstOfMonth = startDate;
        firstOfMonth.setDay(1);
        return QVariant::fromValue(firstOfMonth.startOfDay());
    }
    case StartDateRole:
        return QVariant::fromValue(startDate.startOfDay());
    case SelectedMonthRole:
        return startDate.month();
    case SelectedYearRole:
        return startDate.year();
    default:
        qWarning() << "Unknown role for startdate:" << QMetaEnum::fromType<Roles>().valueToKey(role);
        return {};
    }
}

int InfiniteCalendarViewModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_startDates.length();
}

QHash<int, QByteArray> InfiniteCalendarViewModel::roleNames() const
{
    return {
        {StartDateRole, QByteArrayLiteral("startDate")},
        {FirstDayOfMonthRole, QByteArrayLiteral("firstDay")},
        {SelectedMonthRole, QByteArrayLiteral("selectedMonth")},
        {SelectedYearRole, QByteArrayLiteral("selectedYear")},
    };
}

DateTime InfiniteCalendarViewModel::currentDate() const
{
    return m_currentDate;
}

void InfiniteCalendarViewModel::setCurrentDate(const DateTime &currentDate)
{
    m_currentDate = currentDate;
}

DateTime InfiniteCalendarViewModel::minimumDate() const
{
    return m_minimumDate;
}

void InfiniteCalendarViewModel::setMinimumDate(const DateTime &minimumDate)
{
    if (m_minimumDate == minimumDate) {
        return;
    }
    m_minimumDate = minimumDate;
    Q_EMIT minimumDateChanged();
}

DateTime InfiniteCalendarViewModel::maximumDate() const
{
    return m_maximumDate;
}

void InfiniteCalendarViewModel::setMaximumDate(const DateTime &maximumDate)
{
    if (m_maximumDate == maximumDate) {
        return;
    }
    m_maximumDate = maximumDate;
    Q_EMIT maximumDateChanged();
}

void InfiniteCalendarViewModel::addDates(bool atEnd, const DateTime &startFrom)
{
    const QDateTime start = startFrom.dateTime();
    switch (m_scale) {
    case WeekScale:
        addWeekDates(atEnd, start);
        break;
    case MonthScale:
        addMonthDates(atEnd, start);
        break;
    case YearScale:
        addYearDates(atEnd, start);
        break;
    case DecadeScale:
        addDecadeDates(atEnd, start);
        break;
    }
}

void InfiniteCalendarViewModel::addWeekDates(bool atEnd, const QDateTime &startFrom)
{
    const int newRow = atEnd ? rowCount() : 0;

    beginInsertRows(QModelIndex(), newRow, newRow + m_datesToAdd - 1);

    for (int i = 0; i < m_datesToAdd; i++) {
        QDateTime startDate = startFrom.isValid() && i == 0 ? startFrom : atEnd ? m_startDates[rowCount() - 1].addDays(7) : m_startDates[0].addDays(-7);

        if (startDate.date().dayOfWeek() != m_locale.firstDayOfWeek()) {
            startDate = startDate.addDays(-startDate.date().dayOfWeek() + m_locale.firstDayOfWeek());
        }

        if (atEnd) {
            m_startDates.append(startDate);
        } else {
            m_startDates.insert(0, startDate);
        }
    }

    endInsertRows();
}

void InfiniteCalendarViewModel::addMonthDates(bool atEnd, const QDateTime &startFrom)
{
    QVector<QDateTime> startDates;

    const int newRow = atEnd ? rowCount() : 0;

    for (int i = 0; i < m_datesToAdd; i++) {
        QDateTime firstDay;

        if (startFrom.isValid() && i == 0) {
            firstDay = startFrom;
        } else if (atEnd) {
            firstDay = m_firstDayOfMonthDates[newRow + startDates.length() - 1].addMonths(1);
        } else {
            firstDay = m_firstDayOfMonthDates[0].addMonths(-1);
        }

        QDateTime startDate = firstDay;

        startDate = startDate.addDays(-startDate.date().dayOfWeek() + m_locale.firstDayOfWeek());
        if (startDate >= firstDay) {
            startDate = startDate.addDays(-7);
        }

        if (atEnd) {
            if (m_maximumDate.isValid() && m_maximumDate < startDate) {
                break;
            }
            m_firstDayOfMonthDates.append(firstDay);
            startDates.append(startDate);
        } else {
            m_firstDayOfMonthDates.insert(0, firstDay);
            startDates.insert(0, startDate);
        }
    }

    beginInsertRows({}, newRow, newRow + startDates.length() - 1);

    if (atEnd) {
        m_startDates = m_startDates + startDates;
    } else {
        m_startDates = startDates + m_startDates;
    }

    endInsertRows();
}

void InfiniteCalendarViewModel::addYearDates(bool atEnd, const QDateTime &startFrom)
{
    const int newRow = atEnd ? rowCount() : 0;

    beginInsertRows(QModelIndex(), newRow, newRow + m_datesToAdd - 1);

    for (int i = 0; i < m_datesToAdd; i++) {
        QDateTime startDate = startFrom.isValid() && i == 0 ? startFrom : atEnd ? m_startDates[rowCount() - 1].addYears(1) : m_startDates[0].addYears(-1);

        if (atEnd) {
            m_startDates.append(startDate);
        } else {
            m_startDates.insert(0, startDate);
        }
    }

    endInsertRows();
}

void InfiniteCalendarViewModel::addDecadeDates(bool atEnd, const QDateTime &startFrom)
{
    const int newRow = atEnd ? rowCount() : 0;

    beginInsertRows(QModelIndex(), newRow, newRow + m_datesToAdd - 1);

    for (int i = 0; i < m_datesToAdd; i++) {
        QDateTime startDate = startFrom.isValid() && i == 0 ? startFrom : atEnd ? m_startDates[rowCount() - 1].addYears(10) : m_startDates[0].addYears(-10);

        if (atEnd) {
            m_startDates.append(startDate);
        } else {
            m_startDates.insert(0, startDate);
        }
    }

    endInsertRows();
}

int InfiniteCalendarViewModel::datesToAdd() const
{
    return m_datesToAdd;
}

void InfiniteCalendarViewModel::setDatesToAdd(int datesToAdd)
{
    m_datesToAdd = datesToAdd;
    Q_EMIT datesToAddChanged();
}

int InfiniteCalendarViewModel::scale()
{
    return m_scale;
}

void InfiniteCalendarViewModel::setScale(int scale)
{
    beginResetModel();

    m_startDates.clear();
    m_firstDayOfMonthDates.clear();
    m_scale = scale;
    setup();
    Q_EMIT scaleChanged();

    endResetModel();
}

#include "moc_infinitecalendarviewmodel.cpp"
