# Private module goes separately, beacuse a type in qmldir can not be both internal and singleton
add_library(DesktopStylePrivate)
ecm_add_qml_module(DesktopStylePrivate URI "org.kde.desktop.private" VERSION 1.0 GENERATE_PLUGIN_SOURCE)

set_source_files_properties(
    GlobalSonnetSettings.qml
    MobileTextActionsToolBar.qml
    TextFieldContextMenu.qml

    PROPERTIES
        QT_QML_SINGLETON_TYPE TRUE
)

ecm_target_qml_sources(DesktopStylePrivate SOURCES
    DefaultListItemBackground.qml
    DefaultSliderHandle.qml
    DefaultToolBarBackground.qml
    FocusRect.qml
    GlobalSonnetSettings.qml
    MobileCursor.qml
    MobileTextActionsToolBar.qml
    MobileTextActionsToolBarImpl.qml
    TextFieldContextMenu.qml
)

set_target_properties(DesktopStylePrivate PROPERTIES
    VERSION     ${PROJECT_VERSION}
    SOVERSION   6
)

ecm_finalize_qml_module(DesktopStylePrivate)
install(TARGETS DesktopStylePrivate ${KF_INSTALL_DEFAULT_ARGS})
