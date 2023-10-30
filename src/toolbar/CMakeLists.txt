# SPDX-FileCopyrightText: 2022 Tobias Fella <fella@posteo.de>
# SPDX-License-Identifier: LGPL-2.0-or-later

ecm_add_qml_module(toolbarplugin URI "org.kde.kirigamiaddons.labs.toolbar" VERSION 0.1)

target_compile_definitions(toolbarplugin PRIVATE -DTRANSLATION_DOMAIN=\"kirigami_toolbar\")

target_sources(toolbarplugin PRIVATE
    lib/plugin.cpp
    lib/toolbarstatemanager.cpp
)

ecm_target_qml_sources(toolbarplugin SOURCES
    ToolBar.qml
    ButtonEditDialog.qml
)

target_link_libraries(toolbarplugin PRIVATE
    Qt::Quick
    Qt::Qml
    Qt::QuickTemplates2Private
    KF6::I18n
    KF6::ConfigCore
)

ecm_finalize_qml_module(toolbarplugin DESTINATION ${KDE_INSTALL_QMLDIR})
