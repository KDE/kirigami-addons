# SPDX-FileCopyrightText: 2022 Volker Krause <vkrause@kde.org>
# SPDX-License-Identifier: BSD-2-Clause

gradle_add_aar(datetime_aar BUILDFILE ${CMAKE_CURRENT_SOURCE_DIR}/build.gradle NAME KF6KirigamiDateAndTime)
gradle_install_aar(datetime_aar DESTINATION jar)

install(
    FILES KF6KirigamiDateAndTime-android-dependencies.xml
    DESTINATION ${KDE_INSTALL_LIBDIR}
    RENAME KF6KirigamiDateAndTime_${CMAKE_ANDROID_ARCH_ABI}-android-dependencies.xml
)
