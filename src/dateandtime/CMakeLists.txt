set(dateandtime_SRCS
    lib/timezonemodel.cpp
    lib/timezonesi18n.cpp
    lib/monthmodel.cpp
    lib/plugin.cpp
    lib/timeinputvalidator.cpp
    lib/qdatetimeparser.cpp
    lib/fuck.cpp
    )

add_definitions(-DTRANSLATION_DOMAIN=\"kirigami_dateandtime\")

add_library(dateandtimeplugin MODULE ${dateandtime_SRCS})
target_link_libraries(dateandtimeplugin
        Qt5::Quick
        Qt5::Qml
        KF5::I18n
)

if(ANDROID)
    add_subdirectory(android)

    add_library(KF5KirigamiDateAndTimeAndroid lib/androidutils.cpp)
    add_library(KF5::KirigamiDateAndTimeAndroid ALIAS KF5KirigamiDateAndTimeAndroid)

    target_link_libraries(KF5KirigamiDateAndTimeAndroid Qt5::AndroidExtras)

    target_link_libraries(dateandtimeplugin KF5KirigamiDateAndTimeAndroid)

    set_target_properties(KF5KirigamiDateAndTimeAndroid PROPERTIES EXPORT_NAME KirigamiDateAndTimeAndroid)

    install(TARGETS KF5KirigamiDateAndTimeAndroid EXPORT KF5KirigamiAddonsTargets ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})

    if (Qt5Core_VERSION VERSION_LESS 5.14.0)
        install(FILES KF5KirigamiDateAndTimeAndroid-android-dependencies.xml DESTINATION ${KDE_INSTALL_LIBDIR})
    else()
        install(FILES KF5KirigamiDateAndTimeAndroid-android-dependencies.xml DESTINATION ${KDE_INSTALL_LIBDIR} RENAME KF5KirigamiDateAndTimeAndroid_${CMAKE_ANDROID_ARCH_ABI}-android-dependencies.xml)
    endif()
endif()

install(TARGETS dateandtimeplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigamiaddons/dateandtime)
install(FILES
        qmldir
        ClockElement.qml
        ClockFace.qml
        DateDialog.qml
        DateInput.qml
        DatePicker.qml
        DesktopDateInput.qml
        MobileDateInput.qml
        Hand.qml
        TimezoneTable.qml
        TimeLabel.qml
        TimePicker.qml
        TimeInput.qml
        DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigamiaddons/dateandtime)
