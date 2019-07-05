#pragma once

#include <QTime>
#include <QValidator>

class TimeInputValidator: public QValidator
{
    Q_OBJECT


public:
    TimeInputValidator(QObject *parent = nullptr);
    void fixup(QString &input) const override;
    QValidator::State validate(QString &input, int &pos) const override;

private:
    QTime m_time;
};
