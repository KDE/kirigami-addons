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

#define JSTRING(s) QAndroidJniObject::fromString(s).object<jstring>()


AndroidUtils &AndroidUtils::instance()
{
    static AndroidUtils instance;
    return instance;
}

static void dateSelected(JNIEnv *env, jobject that, jint day, jint month, jint year)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    AndroidUtils::instance()._dateSelected(day, month, year);
}

static void dateCancelled(JNIEnv *env, jobject that)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    AndroidUtils::instance()._dateCancelled();
}

static void timeSelected(JNIEnv *env, jobject that, jint hours, jint minutes)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    AndroidUtils::instance()._timeSelected(hours, minutes);
}

static void timeCancelled(JNIEnv *env, jobject that)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    AndroidUtils::instance()._timeCancelled();
}

static const JNINativeMethod dateMethods[] = {{"dateSelected", "(III)V", (void *)dateSelected}, {"cancelled", "()V", (void *)dateCancelled}};

static const JNINativeMethod timeMethods[] = {{"timeSelected", "(II)V", (void *)timeSelected}, {"cancelled", "()V", (void *)timeCancelled}};

Q_DECL_EXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *)
{
    static bool initialized = false;
    if (initialized) {
        return JNI_VERSION_1_6;
    }
    initialized = true;

    JNIEnv *env = nullptr;
    if (vm->GetEnv((void **)&env, JNI_VERSION_1_4) != JNI_OK) {
        qWarning() << "Failed to get JNI environment.";
        return -1;
    }
    jclass theclass = env->FindClass("org/kde/kirigamiaddons/dateandtime/DatePicker");
    if (env->RegisterNatives(theclass, dateMethods, sizeof(dateMethods) / sizeof(JNINativeMethod)) < 0) {
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
    QAndroidJniObject picker("org/kde/kirigamiaddons/dateandtime/DatePicker", "(Landroid/app/Activity;J)V", QtAndroid::androidActivity().object(), QDateTime::currentMSecsSinceEpoch());
    picker.callMethod<void>("doShow");
}

void AndroidUtils::_dateSelected(int days, int months, int years)
{
    Q_EMIT datePickerFinished(true, QDate(years, months, days));
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

void AndroidUtils::_timeSelected(int hours, int minutes)
{
    Q_EMIT timePickerFinished(true, QTime(hours, minutes));
}

void AndroidUtils::_timeCancelled()
{
    Q_EMIT timePickerFinished(false, QTime());
}
