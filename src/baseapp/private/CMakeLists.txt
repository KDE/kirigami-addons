# SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(baseappprivateplugin
    URI "org.kde.kirigamiaddons.baseapp.private"
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
        "org.kde.kirigami"
        "org.kde.kirigamiaddons.delegates"
        "org.kde.kirigamiaddons.components"
)

target_sources(baseappprivateplugin PRIVATE
    helper.cpp
    helper.h
    keysequencehelper.cpp
    keysequencehelper.h
)

ecm_target_qml_sources(baseappprivateplugin SOURCES
    KQuickCommandBarPage.qml
    ShortcutsEditor.qml
    KeySequenceItem.qml
)

target_link_libraries(baseappprivateplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    KF6::GuiAddons
    KF6::I18n
    KF6::ConfigGui
)

if (HAVE_KGLOBALACCEL)
    target_link_libraries(baseappprivateplugin PRIVATE KF6::GlobalAccel)
    target_compile_definitions(baseappprivateplugin PRIVATE -DHAVE_KGLOBALACCEL=\"true\")
endif()

ecm_finalize_qml_module(baseappprivateplugin DESTINATION ${KDE_INSTALL_QMLDIR})
