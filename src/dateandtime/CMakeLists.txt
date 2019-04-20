set(dateandtime_SRCS
    lib/timezonemodel.cpp
    lib/timezonesi18n.cpp
    lib/knumbermodel.cpp
    lib/plugin.cpp)

add_definitions(-DTRANSLATION_DOMAIN=\"kirigami_dateandtime\")

add_library(dateandtimeplugin SHARED ${dateandtime_SRCS})
target_link_libraries(dateandtimeplugin
        Qt5::Quick
        Qt5::Qml
        KF5::I18n
)

install(TARGETS dateandtimeplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigamiaddons/dateandtime)
install(FILES
        qmldir
        ClockElement.qml
        ClockFace.qml
        DateInput.qml
        Hand.qml
        TimezoneTable.qml
        TimePicker.qml
        DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigamiaddons/dateandtime)
