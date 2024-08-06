cmake_minimum_required(VERSION 3.20)

project(FormCardTutorial)

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECompilerSettings)
include(KDECMakeSettings)
include(ECMQmlModule)

find_package(Qt6 REQUIRED COMPONENTS
    Widgets        # For QApplication
    Quick          # For QML
    QuickControls2 # For QQuickStyle
)
find_package(KF6 REQUIRED COMPONENTS
    CoreAddons # For KAboutData
    I18n       # For KLocalizedContext
)
qt_policy(SET QTP0001 NEW)

add_executable(addonsexample)

target_sources(addonsexample PRIVATE main.cpp)

ecm_add_qml_module(addonsexample
    GENERATE_PLUGIN_SOURCE
    URI org.kde.addonsexample
)

ecm_target_qml_sources(addonsexample SOURCES
    Main.qml
    SettingsPage.qml
    JsonAboutPage.qml
)

target_link_libraries(addonsexample PRIVATE
    Qt::Widgets
    Qt::Quick
    Qt::QuickControls2
    KF6::CoreAddons
    KF6::I18n
)

install(TARGETS addonsexample DESTINATION ${KDE_INSTALL_BINDIR})
