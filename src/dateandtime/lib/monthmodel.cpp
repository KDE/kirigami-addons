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

