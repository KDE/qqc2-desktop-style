

set(org.kde.desktop_SRCS
    plasmadesktoptheme.cpp
    kirigamiplasmafactory.cpp
    plasmadesktopunits.cpp
)


add_library(org.kde.desktop MODULE ${org.kde.desktop_SRCS})

target_link_libraries(org.kde.desktop
    PUBLIC
        Qt${QT_MAJOR_VERSION}::Core
        KF6::Kirigami2
    PRIVATE
        Qt${QT_MAJOR_VERSION}::DBus
        Qt${QT_MAJOR_VERSION}::Qml
        Qt${QT_MAJOR_VERSION}::Quick
        KF6::ConfigWidgets
        KF6::IconThemes
)

install(TARGETS org.kde.desktop DESTINATION ${KDE_INSTALL_PLUGINDIR}/kf${QT_MAJOR_VERSION}/kirigami)

