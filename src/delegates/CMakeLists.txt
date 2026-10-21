# SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(delegatesplugin
    URI "org.kde.kirigamiaddons.delegates"
    VERSION 1.0
    CLASS_NAME DelegatesPlugin
    DEPENDENCIES
        org.kde.kirigami
        org.kde.kirigamiaddons.treeview
        org.kde.kitemmodels
)

ecm_generate_qdoc(delegatesplugin kirigamiaddonsdelegates.qdocconf)

ecm_target_qml_sources(delegatesplugin SOURCES
    RoundedItemDelegate.qml
    RoundedTreeDelegate.qml
    CheckDelegate.qml
    RadioDelegate.qml
    IndicatorItemDelegate.qml
    DefaultContentItem.qml
    SubtitleContentItem.qml
)

target_sources(delegatesplugin PRIVATE
    delegatesplugin.cpp
    delegatesplugin.h
)

qt_target_qml_sources(delegatesplugin RESOURCES
    styles/Material/RoundedItemDelegate.qml
    styles/Material/CheckDelegate.qml
    styles/Material/RadioDelegate.qml
    styles/Material/IndicatorItemDelegate.qml
    OUTPUT_TARGETS _delegates_style_targets
)

if(_delegates_style_targets)
    install(TARGETS ${_delegates_style_targets} EXPORT KirigamiAddonsTargets ${KF_INSTALL_TARGETS_DEFAULT_ARGS})
endif()

target_link_libraries(delegatesplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    KF6::KirigamiPlatform
)

ecm_finalize_qml_module(delegatesplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
