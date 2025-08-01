# SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(delegatesplugin
    URI "org.kde.kirigamiaddons.delegates"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
        org.kde.kirigami
        org.kde.kirigamiaddons.treeview
        org.kde.kitemmodels
)

if (TARGET Qt6::qdoc AND TARGET Qt6::qhelpgenerator)
    ecm_generate_qdoc(delegatesplugin kirigamiaddonsdelegates.qdocconf)
endif()

ecm_target_qml_sources(delegatesplugin SOURCES
    RoundedItemDelegate.qml
    RoundedTreeDelegate.qml
    CheckDelegate.qml
    RadioDelegate.qml
    IndicatorItemDelegate.qml
    DefaultContentItem.qml
    SubtitleContentItem.qml
)

target_link_libraries(delegatesplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
)

ecm_finalize_qml_module(delegatesplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
