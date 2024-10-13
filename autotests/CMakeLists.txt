# SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
# SPDX-License-Identifier: BSD-2-Clause

add_definitions(-DDATA_DIR="${CMAKE_CURRENT_SOURCE_DIR}/data")

if(NOT Qt6QuickTest_FOUND)
    message(STATUS "QtQuickTest not found, autotests will not be built.")
    return()
endif()

add_library(test-artefacts STATIC
    example_albummodel.cpp
)

target_link_libraries(test-artefacts
    Qt6::Core
    Qt6::Gui
)

add_executable(qmltest qmltests.cpp)
ecm_add_qml_module(qmltest URI "org.kde.kirigami.addons.test")
if (NOT QT6_IS_SHARED_LIBS_BUILD)
    qt6_import_qml_plugins(qmltest)
endif()

target_link_libraries(qmltest PRIVATE
    test-artefacts
    Qt6::QuickTest
    Qt6::Qml
    KF6::I18n
)

macro(kirigami_add_tests)
    if (WIN32)
        set(_extra_args -platform offscreen)
    endif()

    foreach(test ${ARGV})
        add_test(NAME ${test}
                 COMMAND qmltest
                        ${_extra_args}
                        -import ${CMAKE_BINARY_DIR}/bin
                        -input ${test}
                 WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        )
    endforeach()
endmacro()

kirigami_add_tests(
    tst_avatar.qml
    tst_sounds.qml
    tst_album_qmllistmodel.qml
    tst_album_abstractlistmodel.qml
    tst_album_qmlqobjectmodel.qml
)
