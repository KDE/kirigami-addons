/*
 *   Copyright 2019 David Edmundson <davidedmundson@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#include "monthmodel.h"

#include <QLocale>

MonthModel::MonthModel(QObject *parent):
    QAbstractListModel(parent)
{

}

int MonthModel::rowCount(const QModelIndex &parent) const
{
    if (!parent.isValid()) {
        return 12;
    }
    return 0;
}

QVariant MonthModel::data(const QModelIndex &index, int role) const
{
    if (!checkIndex(index, CheckIndexOption::IndexIsValid)) {
        return QVariant();
    }
    if (role == Qt::DisplayRole) {
        //model indexes 0-11, months are 1-12
        return QLocale().monthName(index.row()+1, QLocale::ShortFormat);
    }
    return QVariant();
}

