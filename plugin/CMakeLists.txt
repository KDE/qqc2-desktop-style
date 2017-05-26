project(qqc2desktopstyle)

set(qqc2desktopstyle_SRCS
    qqc2desktopstyleplugin.cpp
    qquickstyleitem.cpp
    )

add_library(qqc2desktopstyleplugin SHARED ${qqc2desktopstyle_SRCS})
target_link_libraries(qqc2desktopstyleplugin Qt5::Core  Qt5::Qml Qt5::Quick Qt5::Gui Qt5::Widgets)

install(TARGETS qqc2desktopstyleplugin DESTINATION ${KDE_INSTALL_QMLDIR}/QtQuick/Controls.2/org.kde.desktop)
