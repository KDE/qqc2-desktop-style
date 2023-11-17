
add_library(DesktopStyleImpl)
ecm_add_qml_module(DesktopStyleImpl URI org.kde.desktop.impl GENERATE_PLUGIN_SOURCE)

target_sources(DesktopStyleImpl PRIVATE
    kquickstyleitem.cpp
    itembranchindicators.cpp
)

target_link_libraries(DesktopStyleImpl PRIVATE
    Qt6::Core
    Qt6::Qml
    Qt6::Quick
    Qt6::Gui
    Qt6::Widgets
    KF6::ConfigCore
    KF6::KirigamiPlatform
)

set_target_properties(DesktopStyleImpl PROPERTIES
    VERSION     ${PROJECT_VERSION}
    SOVERSION   6
)

ecm_finalize_qml_module(DesktopStyleImpl)
install(TARGETS DesktopStyleImpl ${KF_INSTALL_DEFAULT_ARGS})
