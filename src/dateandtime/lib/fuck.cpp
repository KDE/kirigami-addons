#include "fuck.h"

#include <QDebug>

#include "androidutils.h"

Fuck::Fuck(QObject* parent)
    : QObject(parent)
{
    qDebug() << "Connect";
    connect(AndroidUtils::instance(), &AndroidUtils::datePickerFinished, this, &Fuck::slotFuck);
}

void Fuck::slotFuck()
{
    qDebug() << "slotFuck";
    Q_EMIT foo();
}

