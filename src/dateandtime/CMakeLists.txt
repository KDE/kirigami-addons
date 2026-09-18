# SPDX-FileCopyrightText: 2019 David Edmundson <kde@davidedmundson.co.uk>
# SPDX-License-Identifier: BSD-2-Clause

add_library(KF6KirigamiDateAndTime)
add_library(KF6::KirigamiDateAndTime ALIAS KF6KirigamiDateAndTime)
qt_extract_metatypes(KF6KirigamiDateAndTime)

target_sources(KF6KirigamiDateAndTime PRIVATE
    datetime.cpp
    datetime.h
)

generate_export_header(KF6KirigamiDateAndTime BASE_NAME KirigamiDateAndTime)

target_link_libraries(KF6KirigamiDateAndTime PUBLIC Qt6::Core)

target_include_directories(KF6KirigamiDateAndTime PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>"
    "$<INSTALL_INTERFACE:${KDE_INSTALL_INCLUDEDIR}/KF6KirigamiDateAndTime>"
)

install(TARGETS KF6KirigamiDateAndTime EXPORT KirigamiAddonsTargets ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

install(FILES
    datetime.h
    "${CMAKE_CURRENT_BINARY_DIR}/kirigamidateandtime_export.h"
    DESTINATION "${KDE_INSTALL_INCLUDEDIR}/KF6KirigamiDateAndTime"
    COMPONENT Devel
)

if (ANDROID)
    target_sources(KF6KirigamiDateAndTime PRIVATE
        androidintegration.cpp
        androidintegration.h
    )
    add_subdirectory(android)
endif()

ecm_add_qml_module(dateandtimeplugin
    URI "org.kde.kirigamiaddons.dateandtime"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
        org.kde.kirigami
        org.kde.kirigamiaddons.components
        org.kde.kirigamiaddons.delegates
)

ecm_generate_qdoc(dateandtimeplugin kirigamiaddonsdateandtime.qdocconf)

target_compile_definitions(dateandtimeplugin PRIVATE -DTRANSLATION_DOMAIN=\"kirigami-addons6\")

target_sources(dateandtimeplugin PRIVATE
    yearmodel.cpp
    monthmodel.cpp
    infinitecalendarviewmodel.cpp
    datetimefactory.cpp
    datetimefactory.h
    types.h
)

ecm_target_qml_sources(dateandtimeplugin SOURCES
    DatePopup.qml
    TimePopup.qml
    TimePicker.qml
)

ecm_target_qml_sources(dateandtimeplugin PATH private SOURCES
    private/DatePathView.qml
    private/DatePicker.qml
    private/DatePickerDelegate.qml
)

target_link_libraries(dateandtimeplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    KF6::I18n
    KF6KirigamiDateAndTime
)

ecm_finalize_qml_module(dateandtimeplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
