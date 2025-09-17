# SPDX-FileCopyrightText: 2025 Aleix Pol Gonzalez <aleixpol@kde.org>
# SPDX-License-Identifier: BSD-2-Clause

add_library(KirigamiApp SHARED)

if (TARGET Qt6::qdoc AND TARGET Qt6::qhelpgenerator)
    ecm_generate_qdoc(KirigamiApp kirigamiapp.qdocconf)
endif()

target_compile_definitions(KirigamiApp PRIVATE -DTRANSLATION_DOMAIN=\"kirigami_app6\")

target_sources(KirigamiApp PRIVATE kirigamiapp.cpp)

target_link_libraries(KirigamiApp PRIVATE
    Qt6::QuickControls2
    Qt6::Qml
    KF6::CoreAddons
    KF6::I18n
    KF6::ColorScheme
)
if(NOT ANDROID)
    target_link_libraries(KirigamiApp PRIVATE KF6::Crash KF6::IconThemes)
endif()

target_include_directories(KirigamiApp
    PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>"
    "$<INSTALL_INTERFACE:${KDE_INSTALL_INCLUDEDIR}>"
    "$<INSTALL_INTERFACE:${KDE_INSTALL_INCLUDEDIR}/KirigamiAddons/App>"
)

ecm_generate_export_header(KirigamiApp
    VERSION ${PROJECT_VERSION}
    BASE_NAME KirigamiApp
    USE_VERSION_HEADER
    DEPRECATION_VERSIONS
)


ecm_setup_version(PROJECT
    VARIABLE_PREFIX KIRIGAMIAPP
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/kirigamiapp_version.h"
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KF6KirigamiAppConfigVersion.cmake"
    SOVERSION 6
)

ecm_generate_headers(KirigamiApp_CamelCase_HEADERS
    HEADER_NAMES
        KirigamiApp
    REQUIRED_HEADERS KirigamiApp_HEADERS
)

set_target_properties(KirigamiApp PROPERTIES
    VERSION     ${PROJECT_VERSION}
    SOVERSION   6
    EXPORT_NAME "KirigamiApp"
)

install(TARGETS KirigamiApp EXPORT KirigamiAddonsTargets ${KF_INSTALL_TARGETS_DEFAULT_ARGS})

install(FILES
    ${KirigamiApp_HEADERS}
    ${KirigamiApp_CamelCase_HEADERS}
    ${CMAKE_CURRENT_BINARY_DIR}/kirigamiapp_export.h
    ${CMAKE_CURRENT_BINARY_DIR}/kirigamiapp_version.h
    DESTINATION ${KDE_INSTALL_INCLUDEDIR}/KirigamiAddons/App
    COMPONENT Devel
)
