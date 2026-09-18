// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include "datetime.h"

#include <QDateTime>
#include <QObject>

namespace KirigamiAddonsDateAndTime
{

/*!
 * \qmltype DateTimeFactory
 * \inqmlmodule org.kde.kirigamiaddons.dateandtime
 *
 * \brief Creates DateTime values from QML.
 *
 * DateTime is a value type and cannot be instantiated directly from QML (there is
 * no \c{DateTime {}} declarative syntax), so this singleton provides the ways QML
 * code needs to obtain one instead of falling back to JavaScript's \c Date.
 *
 * \internal This is QML-only; C++ code can just construct a DateTime directly.
 */
class DateTimeFactory : public QObject
{
    Q_OBJECT

public:
    explicit DateTimeFactory(QObject *parent = nullptr);

    /*!
     * \brief Returns the current date and time.
     */
    Q_INVOKABLE KirigamiAddonsDateAndTime::DateTime now() const;

    /*!
     * \brief Returns dateTime wrapped in a DateTime.
     */
    Q_INVOKABLE KirigamiAddonsDateAndTime::DateTime fromDateTime(const QDateTime &dateTime) const;

    /*!
     * \brief Returns an invalid DateTime, for example to clear a bound.
     */
    Q_INVOKABLE KirigamiAddonsDateAndTime::DateTime invalid() const;
};

}
