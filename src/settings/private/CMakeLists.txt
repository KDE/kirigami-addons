# SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(settingsprivateplugin
    URI "org.kde.kirigamiaddons.settings.private"
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
        "org.kde.kirigami"
        "org.kde.kirigamiaddons.delegates"
)

target_sources(settingsprivateplugin PRIVATE
    helper.cpp
    helper.h
)

ecm_target_qml_sources(settingsprivateplugin SOURCES
    ConfigWindow.qml
    ConfigMobilePage.qml
    ActionIconGroup.qml
)

if (NOT ANDROID)
    ecm_target_qml_sources(settingsprivateplugin SOURCES
        SonnetConfigPage.qml
    )
endif()

target_link_libraries(settingsprivateplugin PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Qml
)

ecm_finalize_qml_module(settingsprivateplugin DESTINATION ${KDE_INSTALL_QMLDIR})
