project(qqc2desktopstyle)

set(qqc2desktopstyle_SRCS
    qqc2desktopstyleplugin.cpp
    kquickstyleitem.cpp
    kpropertywriter.cpp
    textrenderer.cpp
    )

add_library(qqc2desktopstyleplugin SHARED ${qqc2desktopstyle_SRCS})
target_link_libraries(qqc2desktopstyleplugin Qt${QT_MAJOR_VERSION}::Core Qt${QT_MAJOR_VERSION}::Qml Qt${QT_MAJOR_VERSION}::Quick Qt${QT_MAJOR_VERSION}::Gui Qt${QT_MAJOR_VERSION}::Widgets KF5::ConfigCore KF5::Kirigami2)

if(KF5ConfigWidgets_FOUND)
    target_link_libraries(qqc2desktopstyleplugin
        KF5::ConfigWidgets
    )
endif()

if(WIN32 AND BUILD_SHARED_LIBS)
    set_target_properties(qqc2desktopstyleplugin PROPERTIES PREFIX "")
endif()

install(TARGETS qqc2desktopstyleplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/qqc2desktopstyle/private)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/qqc2desktopstyle/private)
