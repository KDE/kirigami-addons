# SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: LGPL-2.0-or-later

# BaseApp module

add_library(KirigamiAddonsBaseApp SHARED
    kirigamiactioncollection.cpp
    kirigamiactioncollection.h
    kirigamitoggleaction.cpp
    kirigamitoggleaction.h
    kirigamiguiitem.cpp
    kirigamiguiitem.h
    kirigamiabstractapplication.cpp
    kirigamiabstractapplication.h
    actionsmodel.cpp
    actionsmodel_p.h
    commandbarfiltermodel.cpp
    commandbarfiltermodel_p.h
    shortcutsmodel.cpp
    shortcutsmodel_p.h
)

set_target_properties(KirigamiAddonsBaseApp PROPERTIES
    VERSION     ${PROJECT_VERSION}
    SOVERSION   6
    EXPORT_NAME "KirigamiAddonsBaseApp"
)

ecm_setup_version(PROJECT
    VARIABLE_PREFIX KIRIGAMIADDONSBASEAPP
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/../kirigamiaddons_version.h"
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KirigamiAddonsBaseAppConfigVersion.cmake"
    SOVERSION 6
)

ecm_generate_export_header(KirigamiAddonsBaseApp
    VERSION ${PROJECT_VERSION}
    BASE_NAME KirigamiAddonsBaseApp
    USE_VERSION_HEADER
    DEPRECATION_VERSIONS
)

ecm_qt_declare_logging_category(KirigamiAddonsBaseApp
    HEADER debug.h
    IDENTIFIER BASEAPP_LOG
    CATEGORY_NAME org.kde.kirigamiaddons.baseapp
    DESCRIPTION "Base App"
    EXPORT KIRIGAMI_ADDONS
)

ecm_generate_headers(KirigamiAddonsBaseApp_HEADERS
    HEADER_NAMES
    KirigamiToggleAction
    KirigamiActionCollection
    KirigamiGuiItem
    KirigamiAbstractApplication
    REQUIRED_HEADERS KirigamiAddonsBaseApp_HEADERS
)

target_link_libraries(KirigamiAddonsBaseApp
    PUBLIC
        Qt6::Core
        Qt6::Qml
        Qt6::Quick
        KF6::ConfigGui
    PRIVATE
        KF6::I18n
        KF6::CoreAddons
)

target_include_directories(KirigamiAddonsBaseApp
    INTERFACE
        "$<INSTALL_INTERFACE:${KDE_INSTALL_INCLUDEDIR}/KirigamiAddonsBaseApp>"
)

# Qml plugin

ecm_add_qml_module(KirigamiAddonsBaseApp
    URI "org.kde.kirigamiaddons.baseapp"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES QtQuick
)

ecm_target_qml_sources(KirigamiAddonsBaseApp SOURCES
    ManagedWindow.qml
    Action.qml
)

ecm_target_qml_sources(KirigamiAddonsBaseApp PATH private SOURCES
    private/KQuickCommandBarPage.qml
    private/ShortcutsEditor.qml
)

ecm_finalize_qml_module(KirigamiAddonsBaseApp DESTINATION ${KDE_INSTALL_QMLDIR})

# Install files

install(TARGETS KirigamiAddonsBaseApp EXPORT KirigamiAddonsTargets ${KF_INSTALL_TARGETS_DEFAULT_ARGS})

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/kirigamiaddonsbaseapp_export.h"
    "${CMAKE_CURRENT_BINARY_DIR}/kirigamiaddonsbaseapp_version.h"
    DESTINATION "${KDE_INSTALL_INCLUDEDIR}/KirigamiAddonsBaseApp"
    COMPONENT Devel
)

install(FILES
    ${KirigamiAddonsBaseApp_HEADERS}
    DESTINATION "${KDE_INSTALL_INCLUDEDIR}/KirigamiAddonsBaseApp"
    COMPONENT Devel
)
