# SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(componentsplugin URI "org.kde.kirigamiaddons.labs.components" VERSION 1.0)

target_sources(componentsplugin PRIVATE
    componentsplugin.cpp
)

ecm_target_qml_sources(componentsplugin SOURCES
    SearchPopupField.qml
    AbstractMaximizeComponent.qml
    AlbumMaximizeComponent.qml
    ImageMaximizeDelegate.qml
    VideoMaximizeDelegate.qml
    AlbumModelItem.qml
)

target_link_libraries(componentsplugin
    Qt${QT_MAJOR_VERSION}::Quick
    Qt${QT_MAJOR_VERSION}::Qml
    Qt${QT_MAJOR_VERSION}::QuickControls2
)

ecm_finalize_qml_module(componentsplugin DESTINATION ${KDE_INSTALL_QMLDIR})
