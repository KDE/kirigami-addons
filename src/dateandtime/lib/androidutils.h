/*
 *  SPDX-FileCopyrightText: 2020 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

#pragma once

#include <QObject>

class QTime;
class QDate;

class Q_DECL_EXPORT AndroidUtils : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void showDatePicker();
    Q_INVOKABLE void showTimePicker();

    void _dateSelected(int days, int months, int years);
    void _dateCancelled();

    void _timeSelected(int hours, int minutes);
    void _timeCancelled();

    static AndroidUtils &instance();

Q_SIGNALS:
    void datePickerFinished(bool accepted, const QDate &date);
    void timePickerFinished(bool accepted, const QTime &time);

private:
    static AndroidUtils *s_instance;
};

