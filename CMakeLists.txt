cmake_minimum_required(VERSION 3.16)

set(KF_VERSION "5.105.0") # handled by release scripts
set(KF_DEP_VERSION "5.104.0") # handled by release scripts

project(qqc2-desktop-style VERSION ${KF_VERSION})

set(REQUIRED_QT_VERSION 5.15.2)

################# Disallow in-source build #################

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
   message(FATAL_ERROR "qqc2-desktop-style requires an out of source build. Please create a separate build directory and run 'cmake path_to_qqc2-desktop-style [options]' there.")
endif()



# Make CPack available to easy generate binary packages
include(CPack)
include(FeatureSummary)

################# set KDE specific information #################

find_package(ECM 5.104.0 REQUIRED NO_MODULE)

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(ECMQmlModule)
include(ECMQMLModules)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDEGitCommitHooks)
include(KDEFrameworkCompilerSettings NO_POLICY_SCOPE)
include(ECMDeprecationSettings)

find_package(Qt${QT_MAJOR_VERSION} ${REQUIRED_QT_VERSION} REQUIRED NO_MODULE COMPONENTS Core Quick Gui Widgets QuickControls2 DBus)

find_package(KF5 ${KF_DEP_VERSION} REQUIRED COMPONENTS Config Kirigami2)

# IconThemes and ConfigWidgets are optional
find_package(KF5IconThemes ${KF_DEP_VERSION})
find_package(KF5ConfigWidgets ${KF_DEP_VERSION})

if (NOT APPLE AND NOT WIN32)
    find_package(X11)
endif()

# When building as a static plugin, dependencies may add a -lQt5X11Extras
# to the linker, in that case, it requires to have the proper variables
# to exists.
if(X11_FOUND)
    if (QT_MAJOR_VERSION STREQUAL "5")
        find_package(Qt5X11Extras ${REQUIRED_QT_VERSION} NO_MODULE)
    endif()
endif()

set_package_properties(IconThemes PROPERTIES DESCRIPTION "KF5 IconThemes framework"
                       TYPE OPTIONAL
                       PURPOSE "Optional integration of Kirigami with KIconLoader icons handling for a better integration with Plasma Desktop"
                      )
set_package_properties(ConfigWidgets PROPERTIES DESCRIPTION "KF5 WidgetAddons framework"
                       TYPE OPTIONAL
                       PURPOSE "Optional integration of Kirigami with KColorScheme for color palettes integration with Plasma Desktop"
                      )

find_package(PkgConfig)

set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/KF5QQC2DesktopStyle")

configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/KF5QQC2DesktopStyleConfig.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2DesktopStyleConfig.cmake"
  INSTALL_DESTINATION  ${CMAKECONFIG_INSTALL_DIR}
  PATH_VARS  CMAKE_INSTALL_PREFIX
)

install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2DesktopStyleConfig.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2DesktopStyleConfigVersion.cmake"
  DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
  COMPONENT Devel
)


ecm_setup_version(PROJECT
    VARIABLE_PREFIX QQC2DESKTOPSTYLE
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2DesktopStyleConfigVersion.cmake"
    SOVERSION 5)

# legacy support for CMake Config files with typo KF5QQC2Desk_opStyle TODO: KF6 remove
set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/KF5QQC2DeskopStyle")

configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/KF5QQC2DeskopStyleConfig.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2DeskopStyleConfig.cmake"
  INSTALL_DESTINATION  ${CMAKECONFIG_INSTALL_DIR}
  PATH_VARS  CMAKE_INSTALL_PREFIX
)

ecm_find_qmlmodule(org.kde.sonnet 1.0)

install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2DeskopStyleConfig.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2DeskopStyleConfigVersion.cmake"
  DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
  COMPONENT Devel
)


ecm_setup_version(PROJECT
    VARIABLE_PREFIX QQC2DESKTOPSTYLE
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2DeskopStyleConfigVersion.cmake"
    SOVERSION 5)

#########################################################################
ecm_set_disabled_deprecation_versions(
    QT 5.15.2
    KF 5.95
)

add_subdirectory(plugin)

if (KF5IconThemes_FOUND AND KF5WidgetsAddons_FOUND)
add_subdirectory(kirigami-plasmadesktop-integration)
endif(KF5IconThemes_FOUND AND KF5WidgetsAddons_FOUND)

if (QT_MAJOR_VERSION EQUAL "5")
  install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/org.kde.desktop DESTINATION ${KDE_INSTALL_QMLDIR}/QtQuick/Controls.2)
else()
  ecm_add_qml_module(org_kde_desktop URI "org.kde.desktop" VERSION 1.0 NO_PLUGIN)
  file(GLOB _public_qml "org.kde.desktop/*.qml")
  ecm_target_qml_sources(org_kde_desktop VERSION 1.0 SOURCES ${_public_qml})
  file(GLOB _private_qml "org.kde.desktop/private/*.qml")
  ecm_target_qml_sources(org_kde_desktop VERSION 1.0 PATH private SOURCES ${_private_qml})
  ecm_finalize_qml_module(org_kde_desktop DESTINATION ${KDE_INSTALL_QMLDIR})
endif()

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)

kde_configure_git_pre_commit_hook(CHECKS CLANG_FORMAT)
