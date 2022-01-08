# SPDX-FileCopyrightText: 2020 Marco Martin <notmart@gmail.com>
# SPDX-License-Identifier: BSD-2-Clause
set(treeview_SRCS
    treeviewplugin.cpp
    )

add_library(treeviewplugin ${treeview_SRCS})

target_link_libraries(treeviewplugin
        PUBLIC
            Qt5::Core
        PRIVATE
            ${Kirigami_EXTRA_LIBS} Qt5::Qml Qt5::Quick Qt5::QuickControls2
    )

install(DIRECTORY qml/ DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigamiaddons/treeview)
install(TARGETS treeviewplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigamiaddons/treeview)
