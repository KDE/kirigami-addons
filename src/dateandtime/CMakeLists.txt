# SPDX-FileCopyrightText: 2019 David Edmundson <kde@davidedmundson.co.uk>
# SPDX-License-Identifier: BSD-2-Clause

if (ANDROID)
    add_library(KF6KirigamiDateAndTime)
    add_library(KF6::KirigamiDateAndTime ALIAS KF6KirigamiDateAndTime)
    target_sources(KF6KirigamiDateAndTime PRIVATE
        lib/androidintegration.cpp
    )
    generate_export_header(KF6KirigamiDateAndTime BASE_NAME KirigamiDateAndTime)
    target_link_libraries(KF6KirigamiDateAndTime PUBLIC Qt6::Core)
    add_subdirectory(android)
    install(TARGETS KF6KirigamiDateAndTime ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
endif()

ecm_add_qml_module(dateandtimeplugin URI "org.kde.kirigamiaddons.dateandtime" VERSION 1.0)

target_compile_definitions(dateandtimeplugin PRIVATE -DTRANSLATION_DOMAIN=\"kirigami-addons\")

target_sources(dateandtimeplugin PRIVATE
    lib/yearmodel.cpp
    lib/monthmodel.cpp
    lib/plugin.cpp
    lib/infinitecalendarviewmodel.cpp
)

ecm_target_qml_sources(dateandtimeplugin SOURCES
    DatePopup.qml
    TimePopup.qml
)
ecm_target_qml_sources(dateandtimeplugin PATH private SOURCES
    private/DatePathView.qml
    private/DatePicker.qml
    private/DatePickerDelegate.qml
    private/TumblerTimePicker.qml
)

target_link_libraries(dateandtimeplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    KF6::I18n
)
if (TARGET KF6KirigamiDateAndTime)
    target_link_libraries(dateandtimeplugin PRIVATE KF6KirigamiDateAndTime)
endif()

ecm_finalize_qml_module(dateandtimeplugin DESTINATION ${KDE_INSTALL_QMLDIR})
