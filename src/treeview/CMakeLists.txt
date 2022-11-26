# SPDX-FileCopyrightText: 2020 Marco Martin <notmart@gmail.com>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(treeviewplugin URI "org.kde.kirigamiaddons.treeview" VERSION 1.0)

target_sources(treeviewplugin PRIVATE
    treeviewplugin.cpp
)

ecm_target_qml_sources(treeviewplugin SOURCES
    qml/BasicTreeItem.qml
    qml/TreeTableView.qml
    qml/TreeViewDecoration.qml
    qml/TreeListView.qml
    qml/AbstractTreeItem.qml
)

ecm_target_qml_sources(treeviewplugin
    PRIVATE PATH
    styles/org.kde.desktop
    SOURCES
    qml/styles/org.kde.desktop/TreeViewDecoration.qml
)

ecm_target_qml_sources(treeviewplugin
    PRIVATE PATH
    private
    SOURCES
    qml/private/InternalTreeListView.qml
    qml/private/InternalTreeTableView.qml
)

target_link_libraries(treeviewplugin
    Qt${QT_MAJOR_VERSION}::Quick
    Qt${QT_MAJOR_VERSION}::Qml
    Qt${QT_MAJOR_VERSION}::QuickControls2
)

ecm_finalize_qml_module(treeviewplugin DESTINATION ${KDE_INSTALL_QMLDIR})
