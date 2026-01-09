# SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

# C++ Library

add_library(KirigamiAddonsComponents SHARED)

target_sources(KirigamiAddonsComponents PRIVATE nameutils.cpp nameutils.h)

target_link_libraries(KirigamiAddonsComponents PRIVATE
        Qt6::QuickControls2
        Qt6::Qml
)

target_include_directories(KirigamiAddonsComponents
        PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>"
        "$<INSTALL_INTERFACE:${KDE_INSTALL_INCLUDEDIR}>"
        "$<INSTALL_INTERFACE:${KDE_INSTALL_INCLUDEDIR}/KirigamiAddons/Components>"
)

ecm_generate_export_header(KirigamiAddonsComponents
        VERSION ${PROJECT_VERSION}
        BASE_NAME KirigamiAddonsComponents
        USE_VERSION_HEADER
        DEPRECATION_VERSIONS
)

ecm_setup_version(PROJECT
        VARIABLE_PREFIX KIRIGAMIADDONSCOMPONENTS
        VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/kirigamiaddonscomponents_version.h"
        PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KF6KirigamiAddonsComponentsConfigVersion.cmake"
        SOVERSION 6
)

ecm_generate_headers(KirigamiAddonsComponents_CamelCase_HEADERS
        HEADER_NAMES
        NameUtils
        REQUIRED_HEADERS KirigamiAddonsComponents_HEADERS
)

set_target_properties(KirigamiAddonsComponents PROPERTIES
        VERSION     ${PROJECT_VERSION}
        SOVERSION   6
        EXPORT_NAME "KirigamiAddonsComponents"
)

install(TARGETS KirigamiAddonsComponents EXPORT KirigamiAddonsTargets ${KF_INSTALL_TARGETS_DEFAULT_ARGS})

install(FILES
        ${KirigamiAddonsComponents_HEADERS}
        ${KirigamiAddonsComponents_CamelCase_HEADERS}
        ${CMAKE_CURRENT_BINARY_DIR}/kirigamiaddonscomponents_export.h
        ${CMAKE_CURRENT_BINARY_DIR}/kirigamiaddonscomponents_version.h
        DESTINATION ${KDE_INSTALL_INCLUDEDIR}/KirigamiAddons/Components
        COMPONENT Devel
)

# Labs module

ecm_add_qml_module(componentslabsplugin
    URI "org.kde.kirigamiaddons.labs.components"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES org.kde.kirigamiaddons.components QtMultimedia
)

ecm_generate_qdoc(componentslabsplugin kirigamiaddonscomponents.qdocconf)

ecm_target_qml_sources(componentslabsplugin SOURCES
    Avatar.qml
    AbstractMaximizeComponent.qml
    AlbumMaximizeComponent.qml
    ImageMaximizeDelegate.qml
    VideoMaximizeDelegate.qml
    AlbumModelItem.qml
    Banner.qml
    DownloadAction.qml
    SearchPopupField.qml
    DialogRoundedBackground.qml
)

target_link_libraries(componentslabsplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    Qt6::QuickControls2
    KirigamiAddonsComponents
)

ecm_finalize_qml_module(componentslabsplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)

# Non labs module

ecm_add_qml_module(componentsplugin
    URI "org.kde.kirigamiaddons.components"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
        org.kde.kirigami
)

target_sources(componentsplugin PRIVATE
    nameutilselement.h
    nameutilselement.cpp
    messagedialoghelper.h
    messagedialoghelper.cpp
)

ecm_target_qml_sources(componentsplugin SOURCES
    Avatar.qml
    AvatarButton.qml
    DoubleFloatingButton.qml
    Banner.qml
    BottomDrawer.qml
    DialogRoundedBackground.qml
    FloatingButton.qml
    FloatingToolBar.qml

    MessageDialog.qml
    SearchPopupField.qml
    SegmentedButton.qml
    RadioSelector.qml
    ConvergentContextMenu.qml
)

ecm_target_qml_sources(componentsplugin PRIVATE PATH private SOURCES
    private/ContextMenuPage.qml
    private/ActionsMenu.qml
    private/ActionMenuItem.qml
)

target_link_libraries(componentsplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    KF6::ConfigCore
    Qt6::QuickControls2
    KirigamiAddonsComponents
)

ecm_finalize_qml_module(componentsplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
