# SPDX-FileCopyrightText: 2019 David Edmundson <kde@davidedmundson.co.uk>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(dateandtimeplugin URI "org.kde.kirigamiaddons.dateandtime" VERSION 0.1)

target_compile_definitions(dateandtimeplugin PRIVATE -DTRANSLATION_DOMAIN=\"kirigami_dateandtime\")

target_sources(dateandtimeplugin PRIVATE
    lib/yearmodel.cpp
    lib/monthmodel.cpp
    lib/plugin.cpp
    lib/timeinputvalidator.cpp
    lib/qdatetimeparser.cpp
)

ecm_target_qml_sources(dateandtimeplugin SOURCES
    ClockElement.qml
    ClockFace.qml
    DateInput.qml
    DatePicker.qml
    DatePopup.qml
    DesktopDateInput.qml
    MobileDateInput.qml
    Hand.qml
    TimeLabel.qml
    TimePicker.qml
    TimeInput.qml
)

target_link_libraries(dateandtimeplugin
    Qt5::Quick
    Qt5::Qml
    KF5::I18n
)

ecm_finalize_qml_module(dateandtimeplugin DESTINATION ${KDE_INSTALL_QMLDIR})
