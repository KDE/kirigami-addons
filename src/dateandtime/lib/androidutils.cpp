/*
 *  SPDX-FileCopyrightText: 2020 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include "androidutils.h"
#include <QAndroidJniObject>
#include <QDateTime>
#include <QDebug>
#include <QtAndroid>
#include <QThread>

#define JSTRING(s) QAndroidJniObject::fromString(s).object<jstring>()

AndroidUtils *AndroidUtils::s_instance = nullptr;

AndroidUtils *AndroidUtils::instance()
{
    if (!s_instance) {
        s_instance = new AndroidUtils();
    }

    return s_instance;
}

static void dateSelected(JNIEnv *env, jobject that, jint day, jint month, jint year)
{
    Q_UNUSED(that);
    AndroidUtils::instance()->_dateSelected(static_cast<int>(day), month, year);
}

static void dateCancelled(JNIEnv *env, jobject that)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    AndroidUtils::instance()->_dateCancelled();
}

static void timeSelected(JNIEnv *env, jobject that, jstring data)
{
    Q_UNUSED(that);
    AndroidUtils::instance()->_timeSelected(QString::fromUtf8(env->GetStringUTFChars(data, nullptr)));
}

static void timeCancelled(JNIEnv *env, jobject that)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    AndroidUtils::instance()->_timeCancelled();
}
/*
extern "C" {
    Q_DECL_EXPORT void Java_org_kde_kirigamiaddons_dateandtime_DatePicker_cancelled(JNIEnv *, jobject)
    {
        qDebug() << "cancelled";
    }
}*/

static const JNINativeMethod methods[] = {{"dateSelected", "(III)V", (void *)dateSelected}, {"cancelled", "()V", (void *)dateCancelled}};

static const JNINativeMethod timeMethods[] = {{"timeSelected", "(Ljava/lang/String;)V", (void *)timeSelected}, {"cancelled", "()V", (void *)timeCancelled}};

Q_DECL_EXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *)
{
    static bool initialized = false;
    if (initialized)
        return JNI_VERSION_1_6;
    initialized = true;

    JNIEnv *env = nullptr;
    auto foo = vm->GetEnv((void **)&env, JNI_VERSION_1_4);

    if (foo != JNI_OK) {
        qWarning() << "Failed to get JNI environment. Fucking fuck." << foo << QThread::currentThreadId();
        return -1;
    }
    jclass theclass = env->FindClass("org/kde/kirigamiaddons/dateandtime/DatePicker");
    if (env->RegisterNatives(theclass, methods, sizeof(methods) / sizeof(JNINativeMethod)) < 0) {
        qWarning() << "Failed to register native functions.";
        return -1;
    }

    jclass timeclass = env->FindClass("org/kde/kirigamiaddons/dateandtime/TimePicker");
    if (env->RegisterNatives(timeclass, timeMethods, sizeof(timeMethods) / sizeof(JNINativeMethod)) < 0) {
        qWarning() << "Failed to register native functions.";
        return -1;
    }

    return JNI_VERSION_1_4;
}

void AndroidUtils::showDatePicker()
{
    QAndroidJniObject picker("org/kde/kirigamiaddons/dateandtime/DatePicker", "(Landroid/app/Activity;J)V", QtAndroid::androidActivity().object(), QDateTime::currentDateTime().toMSecsSinceEpoch());
    picker.callMethod<void>("doShow");
}

void AndroidUtils::_dateSelected(int days, int monts, int years)
{
    qDebug() << "Got dateipewckje   fkl" << days << monts << years;
    Q_EMIT foo();
    Q_EMIT datePickerFinished(true, QDate(years, monts, days));
}

void AndroidUtils::_dateCancelled()
{
    Q_EMIT datePickerFinished(false, QDate());
}

void AndroidUtils::showTimePicker()
{
    QAndroidJniObject picker("org/kde/kirigamiaddons/dateandtime/TimePicker", "(Landroid/app/Activity;J)V", QtAndroid::androidActivity().object(), QDateTime::currentDateTime().toMSecsSinceEpoch());
    picker.callMethod<void>("doShow");
}

void AndroidUtils::_timeSelected(const QString &data)
{
    Q_EMIT timePickerFinished(true, data);
}

void AndroidUtils::_timeCancelled()
{
    Q_EMIT timePickerFinished(false, QString());
}
