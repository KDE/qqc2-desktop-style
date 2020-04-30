

set(org.kde.desktop_SRCS
    plasmadesktoptheme.cpp
    kirigamiplasmafactory.cpp
)


add_library(org.kde.desktop MODULE ${org.kde.desktop_SRCS})

target_link_libraries(org.kde.desktop
    PUBLIC
        Qt5::Core
        KF5::Kirigami2
    PRIVATE
        Qt5::DBus
        Qt5::Qml
        Qt5::Quick
        KF5::ConfigWidgets
        KF5::IconThemes
)

install(TARGETS org.kde.desktop DESTINATION ${KDE_INSTALL_PLUGINDIR}/kf5/kirigami)

