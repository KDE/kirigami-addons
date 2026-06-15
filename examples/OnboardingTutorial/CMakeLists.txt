# SPDX-FileCopyrightText: 2026 Sandro Andrade <sandroandrade@kde.org>
# SPDX-License-Identifier: BSD-2-Clause

cmake_minimum_required(VERSION 3.20)

project(OnboardingTutorial)

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECompilerSettings)
include(KDECMakeSettings)
include(ECMQmlModule)

find_package(Qt6 REQUIRED COMPONENTS
    Gui
    Qml
    Quick
    QuickControls2
    QuickEffects
)
find_package(KF6 REQUIRED COMPONENTS
    I18n
    Kirigami
)

qt_policy(SET QTP0001 NEW)

add_executable(onboardingtutorial)

target_sources(onboardingtutorial PRIVATE main.cpp)

ecm_add_qml_module(onboardingtutorial
    GENERATE_PLUGIN_SOURCE
    URI org.kde.kirigamiaddons.examples.onboardingtutorial
)

ecm_target_qml_sources(onboardingtutorial SOURCES
    Main.qml
    Page1.qml
    Page2.qml
    Page3.qml
)

qt_target_qml_sources(onboardingtutorial RESOURCES
    onboarding-video.webp
)

target_link_libraries(onboardingtutorial PRIVATE
    Qt::Gui
    Qt::Qml
    Qt::Quick
    Qt::QuickControls2
    Qt6::QuickEffects
    KF6::I18n
    KF6::I18nQml
)

install(TARGETS onboardingtutorial DESTINATION ${KDE_INSTALL_BINDIR})
