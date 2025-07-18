# SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

add_subdirectory(private)

ecm_add_qml_module(settingsplugin
    URI "org.kde.kirigamiaddons.settings"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES "org.kde.kirigamiaddons.settings.private"
)

if (TARGET Qt6::qdoc AND TARGET Qt6::qhelpgenerator)
    ecm_generate_qdoc(settingsplugin kirigamiaddonssettings.qdocconf)
endif()

ecm_target_qml_sources(settingsplugin SOURCES
    SettingAction.qml # deprecated
    CategorizedSettings.qml # deprecated

    ConfigurationView.qml
    ConfigurationModule.qml
    SpellcheckingConfigurationModule.qml
    ShortcutsConfigurationModule.qml
)

target_link_libraries(settingsplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
)

ecm_finalize_qml_module(settingsplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
