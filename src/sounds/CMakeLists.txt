ecm_add_qml_module(soundsplugin URI "org.kde.kirigamiaddons.sounds" VERSION 0.1)

target_compile_definitions(soundsplugin PRIVATE -DTRANSLATION_DOMAIN=\"kirigami_sounds\")

target_sources(soundsplugin PRIVATE
    lib/plugin.cpp
    lib/soundspickermodel.cpp
)

ecm_target_qml_sources(soundsplugin SOURCES
    SoundsPicker.qml
)

target_link_libraries(soundsplugin
    Qt5::Quick
    Qt5::Qml
    KF5::I18n
)

ecm_finalize_qml_module(soundsplugin DESTINATION ${KDE_INSTALL_QMLDIR})
