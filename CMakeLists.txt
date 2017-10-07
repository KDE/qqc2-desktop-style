project(qqc2-desktop-style)

cmake_minimum_required(VERSION 2.8.12)

set(KF5_VERSION "5.39.0") # handled by release scripts

set(QT_MIN_VERSION "5.7.0")

################# Disallow in-source build #################

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
   message(FATAL_ERROR "qqc2-desktop-style requires an out of source build. Please create a separate build directory and run 'cmake path_to_qqc2-desktop-style [options]' there.")
endif()



# Make CPack available to easy generate binary packages
include(CPack)
include(FeatureSummary)

################# set KDE specific information #################

find_package(ECM 5.39.0 REQUIRED NO_MODULE)

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Qt5 ${QT_MIN_VERSION} REQUIRED NO_MODULE COMPONENTS Core Quick Gui Widgets)

find_package(KF5 ${KF5_DEP_VERSION} REQUIRED COMPONENTS Kirigami2)

find_package(KF5 ${KF5_DEP_VERSION} COMPONENTS
                IconThemes #KIconLoader
                ConfigWidgets #KColorScheme
            )
set_package_properties(IconThemes PROPERTIES DESCRIPTION "KF5 IconThemes framework"
                       TYPE OPTIONAL
                       PURPOSE "Optional integration of Kirigami with KIconLoader icons handling for a better integration with Plasma Desktop"
                      )
set_package_properties(ConfigWidgets PROPERTIES DESCRIPTION "KF5 WidgetAddons framework"
                       TYPE OPTIONAL
                       PURPOSE "Optional integration of Kirigami with KColorScheme for color palettes integration with Plasma Desktop"
                      )

find_package(PkgConfig)

set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/KF5QQC2DeskopStyle")

configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/KF5QQC2DeskopStyleConfig.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2DeskopStyleConfig.cmake"
  INSTALL_DESTINATION  ${CMAKECONFIG_INSTALL_DIR}
  PATH_VARS  KF5_INCLUDE_INSTALL_DIR CMAKE_INSTALL_PREFIX
)

install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2DeskopStyleConfig.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2DeskopStyleConfigVersion.cmake"
  DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
  COMPONENT Devel
)


ecm_setup_version(${KF5_VERSION}
    VARIABLE_PREFIX QQC2DESKTOPSTYLE
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/qqc2desktopstyle_version.h"
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KF5QQC2DeskopStyleConfigVersion.cmake"
    SOVERSION 5)

#########################################################################

add_subdirectory(plugin)

if (KF5IconThemes_FOUND AND KF5WidgetsAddons_FOUND)
add_subdirectory(kirigami-plasmadesktop-integration)
endif(KF5IconThemes_FOUND AND KF5WidgetsAddons_FOUND)

install(DIRECTORY org.kde.desktop DESTINATION ${KDE_INSTALL_QMLDIR}/QtQuick/Controls.2)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)

