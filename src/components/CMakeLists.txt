# SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

# Labs module

ecm_add_qml_module(componentslabsplugin
    URI "org.kde.kirigamiaddons.labs.components"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES org.kde.kirigamiaddons.components
)

if (TARGET Qt6::qdoc AND TARGET Qt6::qhelpgenerator)
    ecm_generate_qdoc(componentslabsplugin kirigamiaddonscomponents.qdocconf)
endif()

target_sources(componentslabsplugin PRIVATE
    nameutils.h
    nameutils.cpp
)

ecm_target_qml_sources(componentslabsplugin SOURCES
    Avatar.qml
    AbstractMaximizeComponent.qml
    AlbumMaximizeComponent.qml
    ImageMaximizeDelegate.qml
    VideoMaximizeDelegate.qml
    AlbumModelItem.qml
    Banner.qml
    DownloadAction.qml
    SearchPopupField.qml
    DialogRoundedBackground.qml
)

target_link_libraries(componentslabsplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    Qt6::QuickControls2
)

ecm_finalize_qml_module(componentslabsplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)

# Non labs module

ecm_add_qml_module(componentsplugin
    URI "org.kde.kirigamiaddons.components"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
        org.kde.kirigami
)

target_sources(componentsplugin PRIVATE
    nameutils.h
    nameutils.cpp
    messagedialoghelper.h
    messagedialoghelper.cpp
)

ecm_target_qml_sources(componentsplugin SOURCES
    Avatar.qml
    AvatarButton.qml
    DoubleFloatingButton.qml
    Banner.qml
    BottomDrawer.qml
    DialogRoundedBackground.qml
    FloatingButton.qml
    FloatingToolBar.qml

    MessageDialog.qml
    SearchPopupField.qml
    SegmentedButton.qml
    RadioSelector.qml
    ConvergentContextMenu.qml
)

ecm_target_qml_sources(componentsplugin PRIVATE PATH private SOURCES
    private/ContextMenuPage.qml
    private/ActionsMenu.qml
    private/ActionMenuItem.qml
)

target_link_libraries(componentsplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    KF6::ConfigCore
    Qt6::QuickControls2
)

ecm_finalize_qml_module(componentsplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
