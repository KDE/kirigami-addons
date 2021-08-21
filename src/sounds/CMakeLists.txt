set(sounds_SRCS
    lib/plugin.cpp
    lib/soundspickermodel.cpp
    )

add_definitions(-DTRANSLATION_DOMAIN=\"kirigami_sounds\")

add_library(soundsplugin SHARED ${sounds_SRCS})
target_link_libraries(soundsplugin
        Qt5::Quick
        Qt5::Qml
        KF5::I18n
)

install(TARGETS soundsplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigamiaddons/sounds)
install(FILES
        qmldir
        SoundsPicker.qml
        DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigamiaddons/sounds)
