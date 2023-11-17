
add_subdirectory(private)

add_library(DesktopStyle)
ecm_add_qml_module(DesktopStyle URI "org.kde.desktop"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
    "QtQuick.Templates"
    "org.kde.desktop.private"
    "org.kde.desktop.impl"
)

ecm_target_qml_sources(DesktopStyle SOURCES
    BusyIndicator.qml
    Button.qml
    CheckBox.qml
    CheckDelegate.qml
    CheckIndicator.qml
    ComboBox.qml
    Container.qml
    Control.qml
    DelayButton.qml
    Dial.qml
    Dialog.qml
    DialogButtonBox.qml
    Drawer.qml
    Frame.qml
    GroupBox.qml
    HorizontalHeaderView.qml
    ItemDelegate.qml
    Label.qml
    Menu.qml
    MenuBar.qml
    MenuBarItem.qml
    MenuItem.qml
    MenuSeparator.qml
    Page.qml
    PageIndicator.qml
    Pane.qml
    Popup.qml
    ProgressBar.qml
    RadioButton.qml
    RadioDelegate.qml
    RangeSlider.qml
    RoundButton.qml
    ScrollBar.qml
    ScrollView.qml
    StackView.qml
    Switch.qml
    SwitchDelegate.qml
    SwitchIndicator.qml
    TabBar.qml
    TabButton.qml
    TextArea.qml
    TextField.qml
    ToolBar.qml
    ToolButton.qml
    ToolSeparator.qml
    ToolTip.qml
    VerticalHeaderView.qml
)

set_target_properties(DesktopStyle PROPERTIES
    VERSION     ${PROJECT_VERSION}
    SOVERSION   6
)

target_link_libraries(DesktopStyle PRIVATE DesktopStylePrivate DesktopStyleImpl)

ecm_finalize_qml_module(DesktopStyle)
install(TARGETS DesktopStyle EXPORT DesktopStyleTargets ${KF_INSTALL_DEFAULT_ARGS})
