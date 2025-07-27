# SPDX-FileCopyrightText: 2020 Marco Martin <notmart@gmail.com>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(treeviewplugin URI "org.kde.kirigamiaddons.treeview" VERSION 1.0 CLASS_NAME TreeViewPlugin)

ecm_generate_qdoc(treeviewplugin kirigamiaddonstreeview.qdocconf)

target_sources(treeviewplugin PRIVATE
    treeviewplugin.cpp
)

ecm_target_qml_sources(treeviewplugin SOURCES
    qml/TreeViewDecoration.qml
)

ecm_target_qml_sources(treeviewplugin
    PRIVATE PATH
    styles/org.kde.desktop
    SOURCES
    qml/styles/org.kde.desktop/TreeViewDecoration.qml
)

target_link_libraries(treeviewplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    Qt6::QuickControls2
)

ecm_finalize_qml_module(treeviewplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
