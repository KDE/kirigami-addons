# SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

# Labs module

ecm_add_qml_module(componentslabsplugin URI "org.kde.kirigamiaddons.labs.components" VERSION 1.0)

target_sources(componentslabsplugin PRIVATE
    nameutils.h
    nameutils.cpp
    componentslabsplugin.cpp
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
    Avatar.qml
    AvatarButton.qml
    FloatingButton.qml
    DoubleFloatingButton.qml
    Banner.qml
    DialogRoundedBackground.qml
    SegmentedButton.qml

    MessageDialog.qml
    MessageDialogButton.qml
    MessageDialogButtonBox.qml
)

target_link_libraries(componentsplugin PRIVATE
    Qt${QT_MAJOR_VERSION}::Quick
    Qt${QT_MAJOR_VERSION}::Qml
    Qt${QT_MAJOR_VERSION}::QuickControls2
)

ecm_finalize_qml_module(componentsplugin DESTINATION ${KDE_INSTALL_QMLDIR})
