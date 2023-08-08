# SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

# Labs module

ecm_add_qml_module(componentslabsplugin URI "org.kde.kirigamiaddons.labs.components" VERSION 1.0)

configure_file(AbstractMaximizeComponent.qml ${CMAKE_CURRENT_BINARY_DIR}/AbstractMaximizeComponent.qml)
configure_file(AlbumMaximizeComponent.qml ${CMAKE_CURRENT_BINARY_DIR}/AlbumMaximizeComponent.qml)
configure_file(Avatar.qml ${CMAKE_CURRENT_BINARY_DIR}/Avatar.qml)

target_sources(componentslabsplugin PRIVATE
    nameutils.h
    nameutils.cpp
    componentslabsplugin.cpp
)

ecm_target_qml_sources(componentslabsplugin SOURCES
    ${CMAKE_CURRENT_BINARY_DIR}/Avatar.qml
    ${CMAKE_CURRENT_BINARY_DIR}/AbstractMaximizeComponent.qml
    ${CMAKE_CURRENT_BINARY_DIR}/AlbumMaximizeComponent.qml
    ImageMaximizeDelegate.qml
    VideoMaximizeDelegate.qml
    AlbumModelItem.qml
    Banner.qml
    DownloadAction.qml
    SearchPopupField.qml
)

target_link_libraries(componentslabsplugin
    Qt${QT_MAJOR_VERSION}::Quick
    Qt${QT_MAJOR_VERSION}::Qml
    Qt${QT_MAJOR_VERSION}::QuickControls2
)

ecm_finalize_qml_module(componentslabsplugin DESTINATION ${KDE_INSTALL_QMLDIR})

# Non labs module

ecm_add_qml_module(componentsplugin URI "org.kde.kirigamiaddons.components" VERSION 1.0)

target_sources(componentsplugin PRIVATE
    nameutils.h
    nameutils.cpp
    componentsplugin.cpp
)

ecm_target_qml_sources(componentsplugin SOURCES
    ${CMAKE_CURRENT_BINARY_DIR}/Avatar.qml
    FloatingButton.qml
    DoubleFloatingButton.qml
    Banner.qml
)

target_link_libraries(componentsplugin
    Qt${QT_MAJOR_VERSION}::Quick
    Qt${QT_MAJOR_VERSION}::Qml
    Qt${QT_MAJOR_VERSION}::QuickControls2
)

ecm_finalize_qml_module(componentsplugin DESTINATION ${KDE_INSTALL_QMLDIR})
