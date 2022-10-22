# SPDX-FileCopyrightText: 2019 David Edmundson <kde@davidedmundson.co.uk>
# SPDX-License-Identifier: BSD-2-Clause

cmake_minimum_required(VERSION 3.16)

project(kirigami-addons VERSION 0.5)

set(REQUIRED_QT_VERSION 5.15.2)
set(KF5_DEP_VERSION "5.91.0")

include(FeatureSummary)

set(AUTOMOC_MOC_OPTIONS -Muri=org.kde.kirigami)

find_package(ECM ${KF5_DEP_VERSION} NO_MODULE)
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

find_package(Qt${QT_MAJOR_VERSION} ${REQUIRED_QT_VERSION} REQUIRED NO_MODULE COMPONENTS Core Quick QuickControls2)

find_package(KF5 ${KF5_DEP_VERSION} REQUIRED COMPONENTS Kirigami2 I18n)
if (BUILD_TESTING)
    find_package(Qt${QT_MAJOR_VERSION}QuickTest ${REQUIRED_QT_VERSION} CONFIG QUIET)
endif()
if (ANDROID)
    find_package(Gradle REQUIRED)
    if (QT_MAJOR_VERSION EQUAL "5")
        find_package(Qt${QT_MAJOR_VERSION} ${REQUIRED_QT_VERSION} REQUIRED CONFIG COMPONENTS AndroidExtras)
    endif()
endif()

set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/KF5KirigamiAddons")

option(BUILD_QCH "Build API documentation in QCH format (for e.g. Qt Assistant, Qt Creator & KDevelop)" OFF)
add_feature_info(QCH ${BUILD_QCH} "API documentation in QCH format (for e.g. Qt Assistant, Qt Creator & KDevelop)")

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/KF5KirigamiAddonsConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/KF5KirigamiAddonsConfig.cmake"
    INSTALL_DESTINATION  ${CMAKECONFIG_INSTALL_DIR}
    PATH_VARS CMAKE_INSTALL_PREFIX
)
ecm_setup_version(${PROJECT_VERSION}
    VARIABLE_PREFIX KIRIGAMIADDONS
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/kirigamiaddons_version.h"
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KF5KirigamiAddonsConfigVersion.cmake"
)

add_subdirectory(src)

if (BUILD_TESTING AND BUILD_SHARED_LIBS)
    add_subdirectory(autotests)
endif()

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/KF5KirigamiAddonsConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/KF5KirigamiAddonsConfigVersion.cmake"
    DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
    COMPONENT Devel
)

ki18n_install(po)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
