
add_library(org.kde.desktop MODULE)

target_sources(org.kde.desktop PRIVATE
    animationspeedprovider.cpp
    plasmadesktoptheme.cpp
    kirigamiplasmafactory.cpp
    plasmadesktopunits.cpp
)

target_link_libraries(org.kde.desktop
    PUBLIC
        Qt6::Core
        KF6::KirigamiPlatform
    PRIVATE
        Qt6::DBus
        Qt6::Qml
        Qt6::Quick
        KF6::ConfigCore
        KF6::ColorScheme
        KF6::IconThemes
)

if(WIN32)
    target_link_libraries(org.kde.desktop PRIVATE user32)
endif()

install(TARGETS org.kde.desktop DESTINATION ${KDE_INSTALL_PLUGINDIR}/kf6/kirigami/platform)
