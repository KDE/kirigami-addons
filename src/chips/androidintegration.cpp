/*
​ *  SPDX-FileCopyrightText: 2020 Nicolas Fella <nicolas.fella@gmx.de>
​ *  SPDX-FileCopyrightText: 2022 Volker Krause <vkrause@kde.org>
​ *
​ *  SPDX-License-Identifier: LGPL-2.0-or-later
​ */

#include "androidintegration.h"

#include <QCoreApplication>
#include <QJniObject>
#include <QDebug>

using namespace KirigamiAddonsDateAndTime;

AndroidIntegration &AndroidIntegration::instance()
{
    static AndroidIntegration instance;
    return instance;
}

static void dateSelected(JNIEnv *env, jobject that, jint day, jint month, jint year)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    Q_EMIT AndroidIntegration::instance().datePickerFinished(true, QDate(year, month, day).startOfDay());
}

static void dateCancelled(JNIEnv *env, jobject that)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    Q_EMIT AndroidIntegration::instance().datePickerFinished(false, {});
}

static void timeSelected(JNIEnv *env, jobject that, jint hours, jint minutes)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    Q_EMIT AndroidIntegration::instance().timePickerFinished(true, QDateTime(QDate::currentDate(), QTime(hours, minutes)));
}

static void timeCancelled(JNIEnv *env, jobject that)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    Q_EMIT AndroidIntegration::instance().timePickerFinished(false, {});
}

static void dateReset(JNIEnv *env, jobject that)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    Q_EMIT AndroidIntegration::instance().datePickerReset();
}

static void timeReset(JNIEnv *env, jobject that)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    Q_EMIT AndroidIntegration::instance().timePickerReset();
}

static const JNINativeMethod dateMethods[] = {
    {"dateSelected", "(III)V", (void *)dateSelected},
    {"cancelled", "()V", (void *)dateCancelled},
    {"reset", "()V", (void *)dateReset}
};

static const JNINativeMethod timeMethods[] = {
    {"timeSelected", "(II)V", (void *)timeSelected},
    {"cancelled", "()V", (void *)timeCancelled},
    {"reset", "()V", (void *)timeReset}
};

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

void AndroidIntegration::showDatePicker(qint64 initialDate, bool resettable, const QString &resetLabel)
{
    const QJniObject label = QJniObject::fromString(resetLabel);
    QJniObject picker("org/kde/kirigamiaddons/dateandtime/DatePicker",
                      "(Landroid/app/Activity;JZLjava/lang/String;)V",
                      QNativeInterface::QAndroidApplication::context().object<jobject>(),
                      initialDate,
                      jboolean(resettable),
                      label.object<jstring>());
    picker.callMethod<void>("doShow");
}

void AndroidIntegration::showTimePicker(qint64 initialTime, bool resettable, const QString &resetLabel)
{
    const QJniObject label = QJniObject::fromString(resetLabel);
    QJniObject picker("org/kde/kirigamiaddons/dateandtime/TimePicker",
                      "(Landroid/app/Activity;JZLjava/lang/String;)V",
                      QNativeInterface::QAndroidApplication::context().object<jobject>(),
                      initialTime,
                      jboolean(resettable),
                      label.object<jstring>());
    picker.callMethod<void>("doShow");
}

#include "moc_androidintegration.cpp"
