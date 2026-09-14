# SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(statefulapplabsplugin
    URI "org.kde.kirigamiaddons.statefulapp.labs"
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
        "org.kde.kirigamiaddons.statefulapp"
        "org.kde.kirigamiaddons.statefulapp.private"
)

ecm_generate_qdoc(statefulapplabsplugin kirigamiaddonsstatefulapplicationlabs.qdocconf)

ecm_target_qml_sources(statefulapplabsplugin SOURCES
    NativeMenuItem.qml
    NativeMenuBar.qml
)

target_link_libraries(statefulapplabsplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
)

ecm_finalize_qml_module(statefulapplabsplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)

ecm_add_qml_module(actionslabsplugin
    URI "org.kde.kirigamiaddons.actions.labs"
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
        "org.kde.kirigamiaddons.actions"
        "org.kde.kirigamiaddons.statefulapp.private"
)

ecm_target_qml_sources(actionslabsplugin SOURCES
    NativeMenuItem.qml
    NativeMenuBar.qml
)

target_link_libraries(actionslabsplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
)

ecm_finalize_qml_module(actionslabsplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
