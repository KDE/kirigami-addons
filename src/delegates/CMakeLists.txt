# SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(delegatesplugin URI "org.kde.kirigamiaddons.delegates" VERSION 1.0)

target_sources(delegatesplugin PRIVATE
    plugin.cpp
)

ecm_target_qml_sources(delegatesplugin SOURCES
    RoundedItemDelegate.qml
    IndicatorItemDelegate.qml
    DefaultContentItem.qml
    SubtitleContentItem.qml
)

target_link_libraries(delegatesplugin PRIVATE
    Qt${QT_MAJOR_VERSION}::Quick
    Qt${QT_MAJOR_VERSION}::Qml
)

ecm_finalize_qml_module(delegatesplugin DESTINATION ${KDE_INSTALL_QMLDIR})
