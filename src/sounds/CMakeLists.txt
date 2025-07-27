# SPDX-FileCopyrightText: 2021 Han Young <hanyoung@protonmail.com>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(soundsplugin
    URI "org.kde.kirigamiaddons.sounds"
    VERSION 0.1
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
        org.kde.kirigami
        org.kde.kirigamiaddons.delegates
)

ecm_generate_qdoc(soundsplugin kirigamiaddonssounds.qdocconf)

target_compile_definitions(soundsplugin PRIVATE -DTRANSLATION_DOMAIN=\"kirigami_sounds6\")

target_sources(soundsplugin PRIVATE soundspickermodel.cpp)

ecm_target_qml_sources(soundsplugin SOURCES
    SoundsPicker.qml
)

target_link_libraries(soundsplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    KF6::I18n
)

ecm_finalize_qml_module(soundsplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
