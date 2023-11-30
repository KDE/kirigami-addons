# SPDX-FileCopyrightText: 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
# SPDX-License-Identifier: GPL-2.0-or-later

cmake_minimum_required(VERSION 3.20)

project(TableViewTutorial)

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECompilerSettings)
include(KDECMakeSettings)

find_package(Qt${QT_MAJOR_VERSION} REQUIRED COMPONENTS
    Widgets        # For QApplication
    Quick          # For QML
    QuickControls2 # For QQuickStyle
)
find_package(KF${QT_MAJOR_VERSION} REQUIRED COMPONENTS
    CoreAddons # For KAboutData
    I18n       # For KLocalizedContext
)

add_executable(tableviewexample)

target_sources(tableviewexample PRIVATE
    main.cpp
    book.h book.cpp
    booklistmodel.h booklistmodel.cpp
    booktablemodel.h booktablemodel.cpp
    resources.qrc
)

target_link_libraries(tableviewexample PRIVATE
    Qt::Widgets
    Qt::Quick
    Qt::QuickControls2
    KF${QT_MAJOR_VERSION}::CoreAddons
    KF${QT_MAJOR_VERSION}::I18n
)

install(TARGETS addonsexample DESTINATION ${KDE_INSTALL_BINDIR})
