# SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: LGPL-2.0-or-later

# StatefulApp module

add_library(KirigamiAddonsStatefulApp
    abstractkirigamiapplication.cpp
    abstractkirigamiapplication.h
    kirigamiactioncollection.cpp
    kirigamiactioncollection.h
    actionsmodel.cpp
    actionsmodel_p.h
    commandbarfiltermodel.cpp
    commandbarfiltermodel_p.h
    shortcutsmodel.cpp
    shortcutsmodel_p.h
)

if (TARGET Qt6::qdoc AND TARGET Qt6::qhelpgenerator)
    ecm_generate_qdoc(KirigamiAddonsStatefulApp kirigamiaddonsstatefulapplication.qdocconf)
endif()

set_target_properties(KirigamiAddonsStatefulApp PROPERTIES
    VERSION     ${PROJECT_VERSION}
    SOVERSION   6
    EXPORT_NAME "KirigamiAddonsStatefulApp"
)

ecm_setup_version(PROJECT
    VARIABLE_PREFIX KIRIGAMIADDONSBASEAPP
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KirigamiAddonsStatefulAppConfigVersion.cmake"
    SOVERSION 6
)

ecm_generate_export_header(KirigamiAddonsStatefulApp
    VERSION ${PROJECT_VERSION}
    BASE_NAME KirigamiAddonsStatefulApp
    DEPRECATION_VERSIONS
)

ecm_qt_declare_logging_category(KirigamiAddonsStatefulApp
    HEADER debug.h
    IDENTIFIER BASEAPP_LOG
    CATEGORY_NAME org.kde.kirigamiaddons.statefulapp
    DESCRIPTION "Base App"
    EXPORT KIRIGAMI_ADDONS
)

ecm_generate_headers(KirigamiAddonsStatefulApp_HEADERS
    HEADER_NAMES
        KirigamiActionCollection
        AbstractKirigamiApplication
    REQUIRED_HEADERS
        KirigamiAddonsStatefulApp_HEADERS
)

target_link_libraries(KirigamiAddonsStatefulApp
    PUBLIC
        Qt6::Core
        Qt6::Qml
        Qt6::Quick
        KF6::ConfigGui
    PRIVATE
        KF6::I18n
        KF6::CoreAddons
)

target_include_directories(KirigamiAddonsStatefulApp
    INTERFACE
        "$<INSTALL_INTERFACE:${KDE_INSTALL_INCLUDEDIR}/KirigamiAddonsStatefulApp>"
)

target_compile_definitions(KirigamiAddonsStatefulApp PRIVATE -DTRANSLATION_DOMAIN=\"kirigami-addons6\")

# Qml plugin

ecm_add_qml_module(KirigamiAddonsStatefulApp
    URI "org.kde.kirigamiaddons.statefulapp"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES QtQuick
    IMPORTS
        "org.kde.kirigamiaddons.statefulapp.private"
        "org.kde.config"
)

ecm_target_qml_sources(KirigamiAddonsStatefulApp SOURCES
    StatefulWindow.qml
)

ecm_finalize_qml_module(KirigamiAddonsStatefulApp DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)

# Install files

install(TARGETS KirigamiAddonsStatefulApp EXPORT KirigamiAddonsTargets ${KF_INSTALL_TARGETS_DEFAULT_ARGS})

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/kirigamiaddonsstatefulapp_export.h"
    DESTINATION "${KDE_INSTALL_INCLUDEDIR}/KirigamiAddonsStatefulApp"
    COMPONENT Devel
)

install(FILES
    ${KirigamiAddonsStatefulApp_HEADERS}
    DESTINATION "${KDE_INSTALL_INCLUDEDIR}/KirigamiAddonsStatefulApp"
    COMPONENT Devel
)

add_subdirectory(private)
add_subdirectory(labs)

