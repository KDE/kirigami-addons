#pragma once

#include <QAbstractListModel>

class MonthModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit MonthModel(QObject *parent = nullptr);

public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
};
