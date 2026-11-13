# SPDX-FileCopyrightText: 2026 Kai Uwe Broulik <kde@broulik.de><
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(chipsplugin
    URI "org.kde.kirigamiaddons.chips"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
        org.kde.kirigamiaddons.private
        org.kde.kirigami
        # TODO clean up
        org.kde.kirigamiaddons.components
        org.kde.kirigamiaddons.delegates
)

# TODO ecm_generate_qdoc

# TODO should we use a different one for eventual move to kirigami?
target_compile_definitions(chipsplugin PRIVATE -DTRANSLATION_DOMAIN=\"kirigami-addons6\")

target_sources(chipsplugin PRIVATE
    chipstextdocument.cpp
    chipstextdocument.h
    chipgroup.cpp
    chipgroup.h
    chipobject.cpp
    chipobject.h
    chipsmodel.cpp
    chipsmodel.h
    suggestionsproxymodel.cpp
    suggestionsproxymodel.h
)

ecm_target_qml_sources(chipsplugin SOURCES
    ChipsTextArea.qml
)

target_link_libraries(chipsplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    KF6::I18n
)

ecm_finalize_qml_module(chipsplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
