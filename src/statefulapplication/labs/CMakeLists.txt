# SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(statefulapplabsplugin
    URI "org.kde.kirigamiaddons.statefulapp.labs"
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
        "org.kde.kirigamiaddons.statefulapp"
        "org.kde.kirigamiaddons.statefulapp.private"
)

if (TARGET Qt6::qdoc AND TARGET Qt6::qhelpgenerator)
    ecm_generate_qdoc(statefulapplabsplugin statefulapplabs.qdocconf)
endif()

ecm_target_qml_sources(statefulapplabsplugin SOURCES
    NativeMenuItem.qml
)

target_link_libraries(statefulapplabsplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
)

ecm_finalize_qml_module(statefulapplabsplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
