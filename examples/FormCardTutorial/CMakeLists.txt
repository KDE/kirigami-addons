cmake_minimum_required(VERSION 3.20)

project(MobileFormTutorial)

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECompilerSettings)
include(KDECMakeSettings)

find_package(Qt${QT_MAJOR_VERSION} REQUIRED COMPONENTS
    Widgets    # For QApplication
    Quick      # For QML
)
find_package(KF${QT_MAJOR_VERSION} REQUIRED COMPONENTS
    CoreAddons # For KAboutData
    I18n       # For KLocalizedContext
)

add_executable(addonsexample)

target_sources(addonsexample PRIVATE main.cpp resources.qrc)

target_link_libraries(addonsexample PRIVATE
    Qt::Widgets
    Qt::Quick
    KF${QT_MAJOR_VERSION}::CoreAddons
    KF${QT_MAJOR_VERSION}::I18n
)

install(TARGETS addonsexample DESTINATION ${KDE_INSTALL_BINDIR})
