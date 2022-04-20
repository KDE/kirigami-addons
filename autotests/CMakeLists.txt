# SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
# SPDX-License-Identifier: BSD-2-Clause

if(NOT Qt${QT_MAJOR_VERSION}QuickTest_FOUND)
    message(STATUS "QtQuickTest not found, autotests will not be built.")
    return()
endif()

add_executable(qmltest qmltests.cpp)
target_link_libraries(qmltest Qt${QT_MAJOR_VERSION}::QuickTest)

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
    tst_sounds.qml
)

