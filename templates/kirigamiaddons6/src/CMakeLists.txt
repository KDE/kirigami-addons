# SPDX-License-Identifier: BSD-2-Clause
# SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

add_subdirectory(settings)

add_executable(%{APPNAMELC})
ecm_add_qml_module(%{APPNAMELC}
    URI org.kde.%{APPNAMELC}
    GENERATE_PLUGIN_SOURCE
    QML_FILES
        qml/Main.qml
    DEPENDENCIES
        org.kde.kirigamiaddons.formcard
        org.kde.kirigamiaddons.statefulapp
        org.kde.kirigami
        org.kde.%{APPNAMELC}.settings
)

target_sources(%{APPNAMELC} PRIVATE
    main.cpp
    %{APPNAMELC}application.cpp
    %{APPNAMELC}application.h
)

target_link_libraries(%{APPNAMELC} PUBLIC
    Qt6::Quick
    KF6::I18n
    KF6::CoreAddons
    KF6::ConfigGui
    %{APPNAMELC}_settings
    %{APPNAMELC}_settingsplugin
    KirigamiAddonsStatefulApp
    KirigamiApp
)

if (ANDROID)
    kirigami_package_breeze_icons(ICONS
        list-add
        help-about
        application-exit
        applications-graphics
    )
else()
    target_link_libraries(%{APPNAMELC} PUBLIC Qt::Widgets)
endif()

kconfig_add_kcfg_files(%{APPNAMELC} GENERATE_MOC %{APPNAMELC}config.kcfgc)

install(TARGETS %{APPNAMELC} ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
ecm_add_android_apk(%{APPNAMELC} ANDROID_DIR ${CMAKE_SOURCE_DIR}/android)
