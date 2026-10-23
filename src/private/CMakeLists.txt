# SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(kirigamiaddonsprivateplugin
    URI "org.kde.kirigamiaddons.private"
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES org.kde.ki18n
)

set_source_files_properties(I18n.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

ecm_target_qml_sources(kirigamiaddonsprivateplugin SOURCES I18n.qml)

target_link_libraries(kirigamiaddonsprivateplugin PRIVATE Qt6::Qml)

ecm_finalize_qml_module(kirigamiaddonsprivateplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
