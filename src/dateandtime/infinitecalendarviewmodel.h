// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QAbstractItemModel>
#include <QCalendar>
#include <QDateTime>
#include <QLocale>
#include <QQmlParserStatus>
#include <qqmlregistration.h>

#include "datetime.h"

class InfiniteCalendarViewModel : public QAbstractListModel, public QQmlParserStatus
{
    Q_OBJECT
    QML_ELEMENT

    Q_INTERFACES(QQmlParserStatus)

    // Amount of dates to add each time the model adds more dates
    Q_PROPERTY(int datesToAdd READ datesToAdd WRITE setDatesToAdd NOTIFY datesToAddChanged)
    Q_PROPERTY(int scale READ scale WRITE setScale NOTIFY scaleChanged)
    Q_PROPERTY(KirigamiAddonsDateAndTime::DateTime currentDate READ currentDate WRITE setCurrentDate NOTIFY currentDateChanged)
    Q_PROPERTY(KirigamiAddonsDateAndTime::DateTime minimumDate READ minimumDate WRITE setMinimumDate NOTIFY minimumDateChanged)
    Q_PROPERTY(KirigamiAddonsDateAndTime::DateTime maximumDate READ maximumDate WRITE setMaximumDate NOTIFY maximumDateChanged)

public:
    // The decade scale is designed to be used in a 4x3 grid, so shows 12 years at a time
    enum Scale { WeekScale, MonthScale, YearScale, DecadeScale };
    Q_ENUM(Scale);

    enum Roles {
        StartDateRole = Qt::UserRole + 1,
        FirstDayOfMonthRole,
        SelectedMonthRole,
        SelectedYearRole,
    };
    Q_ENUM(Roles);

    explicit InfiniteCalendarViewModel(QObject *parent = nullptr);
    ~InfiniteCalendarViewModel() = default;

    void setup();
    QVariant data(const QModelIndex &idx, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent = {}) const override;

    void classBegin() override;
    void componentComplete() override;

    KirigamiAddonsDateAndTime::DateTime currentDate() const;
    void setCurrentDate(const KirigamiAddonsDateAndTime::DateTime &currentDate);

    KirigamiAddonsDateAndTime::DateTime minimumDate() const;
    void setMinimumDate(const KirigamiAddonsDateAndTime::DateTime &minimumDate);

    KirigamiAddonsDateAndTime::DateTime maximumDate() const;
    void setMaximumDate(const KirigamiAddonsDateAndTime::DateTime &maximumDate);

    Q_INVOKABLE void addDates(bool atEnd, const KirigamiAddonsDateAndTime::DateTime &startFrom = KirigamiAddonsDateAndTime::DateTime());

    int datesToAdd() const;
    void setDatesToAdd(int datesToAdd);

    int scale();
    void setScale(int scale);

Q_SIGNALS:
    void datesToAddChanged();
    void scaleChanged();
    void currentDateChanged();
    void minimumDateChanged();
    void maximumDateChanged();

private:
    void addWeekDates(bool atEnd, const QDateTime &startFrom);
    void addMonthDates(bool atEnd, const QDateTime &startFrom);
    void addYearDates(bool atEnd, const QDateTime &startFrom);
    void addDecadeDates(bool atEnd, const QDateTime &startFrom);

    KirigamiAddonsDateAndTime::DateTime m_currentDate;
    KirigamiAddonsDateAndTime::DateTime m_minimumDate;
    KirigamiAddonsDateAndTime::DateTime m_maximumDate;
    QVector<QDateTime> m_startDates;
    QVector<QDateTime> m_firstDayOfMonthDates;
    QLocale m_locale;
    int m_datesToAdd = 10;
    int m_scale = MonthScale;
    bool m_isCompleted = false;
};
