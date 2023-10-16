// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include <QMetaEnum>
#include <cmath>
#include "infinitecalendarviewmodel.h"

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

    switch (m_scale) {
    case WeekScale: {
        QDateTime firstDay = m_currentDate.addDays(-m_currentDate.date().dayOfWeek() + m_locale.firstDayOfWeek());
        // We create dates before and after where our view will start from (which is m_currentDate)
        firstDay = firstDay.addDays((-m_datesToAdd * 7) / 2);

        addWeekDates(true, firstDay);
        break;
    }
    case MonthScale: {
        QDateTime firstDay(QDate(m_currentDate.date().year(), m_currentDate.date().month(), 1), {});
        firstDay = firstDay.addMonths(-m_datesToAdd / 2);

        addMonthDates(true, firstDay);
        break;
    }
    case YearScale: {
        QDateTime firstDay(QDate(m_currentDate.date().year(), m_currentDate.date().month(), 1), {});
        firstDay = firstDay.addYears(-m_datesToAdd / 2);

        addYearDates(true, firstDay);
        break;
    }
    case DecadeScale: {
        const int firstYear = ((floor(m_currentDate.date().year() / 10)) * 10) - 1; // E.g. For 2020 have view start at 2019...
        QDateTime firstDay(QDate(firstYear, m_currentDate.date().month(), 1), {});
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

    const QDateTime startDate = m_startDates[idx.row()];

    if (m_scale == MonthScale && role != StartDateRole) {
        const QDateTime firstDay = m_firstDayOfMonthDates[idx.row()];

        switch (role) {
        case FirstDayOfMonthRole:
            return firstDay.date().startOfDay();
        case SelectedMonthRole:
            return firstDay.date().month();
        case SelectedYearRole:
            return firstDay.date().year();
        default:
            qWarning() << "Unknown role for startdate:" << QMetaEnum::fromType<Roles>().valueToKey(role);
            return {};
        }
    }

    switch (role) {
    case StartDateRole:
        return startDate.date().startOfDay();
    case SelectedMonthRole:
        return startDate.date().month();
    case SelectedYearRole:
        return startDate.date().year();
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

QDateTime InfiniteCalendarViewModel::currentDate() const
{
    return m_currentDate;
}

void InfiniteCalendarViewModel::setCurrentDate(const QDateTime &currentDate)
{
    m_currentDate = currentDate;
}

QDateTime InfiniteCalendarViewModel::minimumDate() const
{
    return m_minimumDate;
}

void InfiniteCalendarViewModel::setMinimumDate(const QDateTime &minimumDate)
{
    if (m_minimumDate == minimumDate) {
        return;
    }
    m_minimumDate = minimumDate;
    Q_EMIT minimumDateChanged();
}

QDateTime InfiniteCalendarViewModel::maximumDate() const
{
    return m_maximumDate;
}

void InfiniteCalendarViewModel::setMaximumDate(const QDateTime &maximumDate)
{
    if (m_maximumDate == maximumDate) {
        return;
    }
    m_maximumDate = maximumDate;
    Q_EMIT maximumDateChanged();
}

void InfiniteCalendarViewModel::addDates(bool atEnd, const QDateTime startFrom)
{
    switch (m_scale) {
    case WeekScale:
        addWeekDates(atEnd, startFrom);
        break;
    case MonthScale:
        addMonthDates(atEnd, startFrom);
        break;
    case YearScale:
        addYearDates(atEnd, startFrom);
        break;
    case DecadeScale:
        addDecadeDates(atEnd, startFrom);
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
            if (m_maximumDate.isValid() && startDate > m_maximumDate) {
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
