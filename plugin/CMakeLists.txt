project(qqc2desktopstyle)

set(qqc2desktopstyle_SRCS
    qqc2desktopstyleplugin.cpp
    kquickstyleitem.cpp
    kpropertywriter.cpp
    )

add_library(qqc2desktopstyleplugin SHARED ${qqc2desktopstyle_SRCS})
target_link_libraries(qqc2desktopstyleplugin Qt6::Core Qt6::Qml Qt6::Quick Qt6::Gui Qt6::Widgets KF6::ConfigCore KF6::Kirigami2)

if(WIN32 AND BUILD_SHARED_LIBS)
    set_target_properties(qqc2desktopstyleplugin PROPERTIES PREFIX "")
endif()

install(TARGETS qqc2desktopstyleplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/qqc2desktopstyle/private)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/qqc2desktopstyle/private)
