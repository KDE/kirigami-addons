# SPDX-License-Identifier: BSD-2-Clause
# SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

add_subdirectory(settings)

qt_add_library(%{APPNAMELC}_static STATIC)
ecm_add_qml_module(%{APPNAMELC}_static
    URI org.kde.%{APPNAMELC}
    GENERATE_PLUGIN_SOURCE
    QML_FILES
        qml/Main.qml
        qml/LibraryPage.qml
        qml/GridBrowserDelegate.qml
        qml/Sidebar.qml
    DEPENDENCIES
        org.kde.kirigamiaddons.formcard
        org.kde.kirigamiaddons.statefulapp
        org.kde.kirigami
        org.kde.%{APPNAMELC}.settings
)

target_sources(%{APPNAMELC}_static PRIVATE
    %{APPNAMELC}application.cpp
    %{APPNAMELC}application.h
)

target_link_libraries(%{APPNAMELC}_static PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Svg
    KF6::I18n
    KF6::I18nQml
    KF6::IconThemes
    KF6::CoreAddons
    KF6::ConfigCore
    KF6::ConfigGui
    KirigamiAddonsStatefulApp
)
target_include_directories(%{APPNAMELC}_static PUBLIC ${CMAKE_BINARY_DIR})

if (ANDROID)
    kirigami_package_breeze_icons(ICONS
        list-add
        help-about
        application-exit
        applications-graphics
    )
else()
    target_link_libraries(%{APPNAMELC}_static PUBLIC Qt::Widgets)
endif()

kconfig_add_kcfg_files(%{APPNAMELC}_static GENERATE_MOC %{APPNAMELC}config.kcfgc)

add_executable(%{APPNAMELC} main.cpp)
target_link_libraries(%{APPNAMELC} PUBLIC
    %{APPNAMELC}_static
    %{APPNAMELC}_staticplugin
    %{APPNAMELC}_settings
    %{APPNAMELC}_settingsplugin
)
install(TARGETS %{APPNAMELC} ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
ecm_add_android_apk(%{APPNAMELC} ANDROID_DIR ${CMAKE_SOURCE_DIR}/android)
