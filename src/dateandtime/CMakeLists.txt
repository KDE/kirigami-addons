# SPDX-FileCopyrightText: 2019 David Edmundson <kde@davidedmundson.co.uk>
# SPDX-License-Identifier: BSD-2-Clause

if (ANDROID)
    add_library(KF${KF_MAJOR_VERSION}KirigamiDateAndTime)
    add_library(KF${KF_MAJOR_VERSION}::KirigamiDateAndTime ALIAS KF${KF_MAJOR_VERSION}KirigamiDateAndTime)
    target_sources(KF${KF_MAJOR_VERSION}KirigamiDateAndTime PRIVATE
        lib/androidintegration.cpp
    )
    generate_export_header(KF${KF_MAJOR_VERSION}KirigamiDateAndTime BASE_NAME KirigamiDateAndTime)
    target_link_libraries(KF${KF_MAJOR_VERSION}KirigamiDateAndTime PUBLIC Qt${QT_MAJOR_VERSION}::Core)
    if (QT_MAJOR_VERSION EQUAL "5")
        target_link_libraries(KF${KF_MAJOR_VERSION}KirigamiDateAndTime PUBLIC Qt5::AndroidExtras)
    endif()
    add_subdirectory(android)
    install(TARGETS KF${KF_MAJOR_VERSION}KirigamiDateAndTime ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
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
    private/DatePicker.qml
    private/DatePickerDelegate.qml
    private/TumblerTimePicker.qml
)

target_link_libraries(dateandtimeplugin PRIVATE
    Qt${QT_MAJOR_VERSION}::Quick
    Qt${QT_MAJOR_VERSION}::Qml
    KF${KF_MAJOR_VERSION}::I18n
)
if (TARGET KF${KF_MAJOR_VERSION}KirigamiDateAndTime)
    target_link_libraries(dateandtimeplugin PRIVATE KF${KF_MAJOR_VERSION}KirigamiDateAndTime)
endif()

ecm_finalize_qml_module(dateandtimeplugin DESTINATION ${KDE_INSTALL_QMLDIR})
