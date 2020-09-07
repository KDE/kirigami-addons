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
