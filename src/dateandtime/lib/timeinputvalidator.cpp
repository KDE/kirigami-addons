#include "timeinputvalidator.h"

TimeInputValidator::TimeInputValidator(QObject *parent):
    QValidator(parent)
{}

void TimeInputValidator::fixup(QString &input) const
{

}

QValidator::State TimeInputValidator::validate(QString &input, int &pos) const
{
    QLocale::FormatType formats[] = { QLocale::LongFormat, QLocale::ShortFormat, QLocale::NarrowFormat };
    QLocale locale;

    for (int i = 0; i < 3; i++) {
        QTime tmp = locale.toTime(input, formats[i]);
        if (tmp.isValid()) {
            return QValidator::Acceptable;
        }
    }

    int hours = 0;
    int minutes = 0;


//     QStringList sections = input.split(":");
//     if (sections.length <

    return QValidator::Intermediate;
}
