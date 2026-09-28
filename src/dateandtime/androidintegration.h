/*
​ *  SPDX-FileCopyrightText: 2020 Nicolas Fella <nicolas.fella@gmx.de>
​ *  SPDX-FileCopyrightText: 2022 Volker Krause <vkrause@kde.org>
​ *
​ *  SPDX-License-Identifier: LGPL-2.0-or-later
​ */

#ifndef KIRIGAMIADDONSDATEANDTIME_ANDROIDINTEGRATION_H
#define KIRIGAMIADDONSDATEANDTIME_ANDROIDINTEGRATION_H

#include "kirigamidateandtime_export.h"

#include <QDateTime>
#include <QObject>

namespace KirigamiAddonsDateAndTime {

/** Interface to native Android date/time pickers.
 *  @internal
 */
class KIRIGAMIDATEANDTIME_EXPORT AndroidIntegration : public QObject
{
    Q_OBJECT

public:
    Q_INVOKABLE void showDatePicker(qint64 initialDate, bool resettable, const QString &resetLabel);
    Q_INVOKABLE void showTimePicker(qint64 initialTime, bool resettable, const QString &resetLabel);

    void _timeSelected(int hours, int minutes);
    void _timeCancelled();

    static AndroidIntegration &instance();

Q_SIGNALS:
    void datePickerFinished(bool accepted, const QDateTime &date);
    void timePickerFinished(bool accepted, const QDateTime &time);
    void datePickerReset();
    void timePickerReset();

private:
    static AndroidIntegration *s_instance;
};

}

#endif // KIRIGAMIADDONSDATEANDTIME_ANDROIDINTEGRATION_H
