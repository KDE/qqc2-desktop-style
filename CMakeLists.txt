project(climbinggrades)

cmake_minimum_required(VERSION 2.8.12)
set(KF5_MIN_VERSION "5.18.0")
set(QT_MIN_VERSION "5.7.0")

################# Disallow in-source build #################

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
   message(FATAL_ERROR "climbinggrades requires an out of source build. Please create a separate build directory and run 'cmake path_to_kirigami [options]' there.")
endif()



# Make CPack available to easy generate binary packages
include(CPack)
include(FeatureSummary)

################# set KDE specific information #################

find_package(ECM 0.0.8 REQUIRED NO_MODULE)

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)

set(KF5_VERSION "5.22.0")

find_package(Qt5 ${QT_MIN_VERSION} REQUIRED NO_MODULE COMPONENTS Core Quick)

find_package(PkgConfig)
#########################################################################

install(DIRECTORY Desktop DESTINATION ${KDE_INSTALL_QMLDIR}/QtQuick/Controls.2)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)

