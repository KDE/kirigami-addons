# SPDX-FileCopyrightText: 2023 Marco MArtin <mart@kde.org>
# SPDX-License-Identifier: GPL-2.0-or-later


ecm_add_qml_module(ksvgcompatplugin URI "org.kde.ksvg" VERSION 1.0)

target_sources(ksvgcompatplugin PRIVATE
    ksvgcompatplugin.cpp
)

ecm_target_qml_sources(ksvgcompatplugin SOURCES
    Svg.qml
    SvgItem.qml
    FrameSvgItem.qml
)

target_link_libraries(ksvgcompatplugin
    Qt${QT_MAJOR_VERSION}::Quick
    Qt${QT_MAJOR_VERSION}::Qml
)

ecm_finalize_qml_module(ksvgcompatplugin DESTINATION ${KDE_INSTALL_QMLDIR})


