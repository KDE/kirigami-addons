# SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(settingsplugin URI "org.kde.kirigamiaddons.settings" VERSION 1.0)

target_sources(settingsplugin PRIVATE
    plugin.cpp
)

ecm_target_qml_sources(settingsplugin SOURCES
    SettingAction.qml
    CategorizedSettings.qml
)

target_link_libraries(settingsplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
)

ecm_finalize_qml_module(settingsplugin DESTINATION ${KDE_INSTALL_QMLDIR})
