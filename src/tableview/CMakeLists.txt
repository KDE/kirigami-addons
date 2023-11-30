# SPDX-FileCopyrightText: 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
# SPDX-License-Identifier: GPL-2.0-or-later

ecm_add_qml_module(tableviewplugin URI "org.kde.kirigamiaddons.tableview" VERSION 1.0)

target_sources(tableviewplugin PRIVATE
    tableviewplugin.cpp
)

ecm_target_qml_sources(tableviewplugin SOURCES
    qml/ListTableView.qml
    qml/KTableView.qml
    qml/HeaderComponent.qml
)

ecm_target_qml_sources(tableviewplugin PATH private SOURCES
    private/AbstractHeaderComponent.qml
    private/HeaderDelegate.qml
    private/AbstractTable.qml
    private/ListCellDelegate.qml
    private/ListRowDelegate.qml
    private/TableCellDelegate.qml
)

target_link_libraries(tableviewplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    Qt6::QuickControls2
)

ecm_finalize_qml_module(tableviewplugin DESTINATION ${KDE_INSTALL_QMLDIR})
