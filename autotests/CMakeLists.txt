# SPDX-FileCopyrightText: 2026 Tobias Fella <tobias.fella@kde.org>
# SPDX-License-Identifier: BSD-2-Clause

add_executable(qmltest qmltest.cpp)
target_link_libraries(qmltest PRIVATE Qt6::Qml Qt6::QuickTest)

macro(qqc2desktopstyle_add_tests)
    foreach(test ${ARGV})
        add_test(NAME ${test}
                 COMMAND qmltest
                        -import ${CMAKE_BINARY_DIR}/bin
                        -input ${test}
                 WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        )
        set_tests_properties(${test} PROPERTIES ENVIRONMENT "QT_QPA_PLATFORM=offscreen")
    endforeach()
endmacro()

qqc2desktopstyle_add_tests(
    tst_tooltip.qml
)
