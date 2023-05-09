

set(org.kde.desktop_SRCS
    plasmadesktoptheme.cpp
    kirigamiplasmafactory.cpp
    plasmadesktopunits.cpp
)


add_library(org.kde.desktop MODULE ${org.kde.desktop_SRCS})

target_link_libraries(org.kde.desktop
    PUBLIC
        Qt6::Core
        KF6::Kirigami2
    PRIVATE
        Qt6::DBus
        Qt6::Qml
        Qt6::Quick
        KF6::ConfigCore
        KF6::ColorScheme
        KF6::IconThemes
)

install(TARGETS org.kde.desktop DESTINATION ${KDE_INSTALL_PLUGINDIR}/kf6/kirigami)

