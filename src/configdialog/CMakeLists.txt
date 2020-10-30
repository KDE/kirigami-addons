set(configdialog_SRCS
    configdialogplugin.cpp
    )

add_library(configdialogplugin ${configdialog_SRCS})

target_link_libraries(configdialogplugin
        PUBLIC
            Qt5::Core
        PRIVATE
            ${Kirigami_EXTRA_LIBS} Qt5::Qml Qt5::Quick
    )

install(DIRECTORY qml/ DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigamiaddons/configdialog)
install(TARGETS configdialogplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigamiaddons/configdialog)
