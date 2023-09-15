# SPDX-FileCopyrightText: 2019 David Edmundson <kde@davidedmundson.co.uk>
# SPDX-License-Identifier: BSD-2-Clause

cmake_minimum_required(VERSION 3.16)

project(kirigami-addons VERSION 0.11.40)

include(FeatureSummary)

set(AUTOMOC_MOC_OPTIONS -Muri=org.kde.kirigami)

# QT_MAJOR_VERSION is defined automatically by QtVersionOption (since ECM 5.82)
# which is included by KDEInstallDirs;
# This variables are updated below if Qt6 is found by ECM
set(QT_REQUIRED_VERSION "5.15.2")
set(KF_MIN_VERSION "5.91.0")
set(KF_MAJOR_VERSION "5")

find_package(ECM ${KF_MIN_VERSION} NO_MODULE)
set_package_properties(ECM PROPERTIES TYPE REQUIRED DESCRIPTION "Extra CMake Modules." URL "https://projects.kde.org/projects/kdesupport/extra-cmake-modules")

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)

include(GenerateExportHeader)
include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(CMakePackageConfigHelpers)
include(ECMQtDeclareLoggingCategory)
include(ECMAddQch)
include(ECMQmlModule)

if (QT_MAJOR_VERSION STREQUAL "6")
    set(QT_REQUIRED_VERSION "6.4")
    set(KF_MIN_VERSION "5.240.0")
    set(KF_MAJOR_VERSION "6")

    find_package(KSvg CONFIG)
    set_package_properties(KSvg PROPERTIES
        DESCRIPTION "Svg rendering library with theme support"
        PURPOSE "Required at runtime for rendering Svg items in some controls"
        TYPE RUNTIME
    )

endif()

find_package(Qt${QT_MAJOR_VERSION} ${QT_REQUIRED_VERSION} REQUIRED NO_MODULE COMPONENTS Core Quick QuickControls2)

find_package(KF${KF_MAJOR_VERSION} ${KF_MIN_VERSION} REQUIRED COMPONENTS Kirigami2 I18n)
if (BUILD_TESTING)
    find_package(Qt${QT_MAJOR_VERSION}QuickTest ${QT_REQUIRED_VERSION} CONFIG QUIET)
endif()
if (ANDROID)
    find_package(Gradle REQUIRED)
    if (QT_MAJOR_VERSION EQUAL "5")
        find_package(Qt${QT_MAJOR_VERSION} ${QT_REQUIRED_VERSION} REQUIRED CONFIG COMPONENTS AndroidExtras)
    endif()
endif()

set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/KF${KF_MAJOR_VERSION}KirigamiAddons")

option(BUILD_QCH "Build API documentation in QCH format (for e.g. Qt Assistant, Qt Creator & KDevelop)" OFF)
add_feature_info(QCH ${BUILD_QCH} "API documentation in QCH format (for e.g. Qt Assistant, Qt Creator & KDevelop)")

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/KFKirigamiAddonsConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/KF${KF_MAJOR_VERSION}KirigamiAddonsConfig.cmake"
    INSTALL_DESTINATION  ${CMAKECONFIG_INSTALL_DIR}
    PATH_VARS CMAKE_INSTALL_PREFIX
)
ecm_setup_version(${PROJECT_VERSION}
    VARIABLE_PREFIX KIRIGAMIADDONS
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/kirigamiaddons_version.h"
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KF${KF_MAJOR_VERSION}KirigamiAddonsConfigVersion.cmake"
)


if(QT_MAJOR_VERSION STREQUAL "6")
    set(QTGRAPHICALEFFECTS_MODULE "Qt5Compat.GraphicalEffects")
else()
    set(QTGRAPHICALEFFECTS_MODULE "QtGraphicalEffects 1.0")
endif()

add_subdirectory(src)

if (BUILD_TESTING AND BUILD_SHARED_LIBS)
    add_subdirectory(autotests)
endif()

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/KF${KF_MAJOR_VERSION}KirigamiAddonsConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/KF${KF_MAJOR_VERSION}KirigamiAddonsConfigVersion.cmake"
    DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
    COMPONENT Devel
)

ki18n_install(po)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
