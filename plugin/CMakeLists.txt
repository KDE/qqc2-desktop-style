project(qqc2desktopstyle)

set(qqc2desktopstyle_SRCS
    qqc2desktopstyleplugin.cpp
    kquickstyleitem.cpp
    )

if(Qt5_VERSION VERSION_LESS "5.8.0")
set(qqc2desktopstyle_SRCS
    ${qqc2desktopstyle_SRCS}
    #FIXME: remove when we can depend from Qt 5.8+
    qsgninepatchnode.cpp
    qsgdefaultninepatchnode.cpp
    )
endif()

if (STATIC_PLUGIN)
    qt5_add_resources(RESOURCES ${CMAKE_CURRENT_SOURCE_DIR}/../style.qrc)
endif()

add_library(qqc2desktopstyleplugin ${qqc2desktopstyle_SRCS} ${RESOURCES})
target_link_libraries(qqc2desktopstyleplugin Qt5::Core  Qt5::Qml Qt5::Quick Qt5::Gui Qt5::Widgets KF5::Kirigami2)

if (STATIC_PLUGIN)
    set_target_properties(qqc2desktopstyleplugin PROPERTIES
        AUTOMOC_MOC_OPTIONS -Muri=org.kde.desktop)
endif()

if(KF5ConfigWidgets_FOUND)
    target_link_libraries(qqc2desktopstyleplugin
        KF5::ConfigWidgets
    )
endif()

install(TARGETS qqc2desktopstyleplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/qqc2desktopstyle/private)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/qqc2desktopstyle/private)
