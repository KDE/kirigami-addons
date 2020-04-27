#pragma once

#include <QObject>

class Q_DECL_EXPORT Fuck : public QObject
{
    Q_OBJECT
public:
    Fuck(QObject *parent=nullptr);
public Q_SLOTS:
    void slotFuck();

Q_SIGNALS:
    void foo();
};

