# SPDX-FileCopyrightText: 2020 Marco Martin <notmart@gmail.com>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(treeviewplugin URI "org.kde.kirigamiaddons.treeview" VERSION 0.1)

target_sources(treeviewplugin PRIVATE
    treeviewplugin.cpp
)

ecm_target_qml_sources(treeviewplugin SOURCES
    qml/InternalTreeListView.qml
    qml/BasicTreeItem.qml
    qml/TreeTableView.qml
    qml/TreeViewDecoration.qml
    qml/TreeListView.qml
    qml/AbstractTreeItem.qml
    qml/InternalTreeTableView.qml
)

ecm_target_qml_sources(treeviewplugin
    PRIVATE PATH
    styles/org.kde.desktop
    SOURCES
    qml/styles/org.kde.desktop/TreeViewDecoration.qml
)

target_link_libraries(treeviewplugin
    Qt5::Quick
    Qt5::Qml
    Qt5::QuickControls2
)

ecm_finalize_qml_module(treeviewplugin DESTINATION ${KDE_INSTALL_QMLDIR})
