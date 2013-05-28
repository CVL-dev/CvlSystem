include(CvlCommon)
include(CvlDashTest)

AddTest(${CMAKE_CURRENT_SOURCE_DIR}/Test ${PROJECT_NAME}_Test)

set(CvlEnableComponentPackage OFF)

if(NOT CVL_DEFAULT_PREFIX)
    set(CVL_DEFAULT_PREFIX "/usr/local")
endif()

if(CvlEnableComponentPackage)
    set(CPACK_RPM_COMPONENT_INSTALL ON)
    set(CPACK_PACKAGE_FILE_NAME "cvl")
endif()

GetDistribution(distribution)
set(CPACK_SYSTEM_NAME "${distribution}.${CMAKE_SYSTEM_PROCESSOR}")

if(CVL_MANUAL_BUILD_FLAG)
    set(CVL_INSTALLATION_PREFIX "${CVL_DEFAULT_PREFIX}")
else()
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel." FORCE)

    unset(CMAKE_INSTALL_PREFIX CACHE)

    set(CVL_INSTALLATION_PREFIX "${CVL_DEFAULT_PREFIX}" CACHE STRING "Installation path")

    ListDirectory("." ModuleList)

    foreach(module ${ModuleList})
        if(NOT module STREQUAL "CmakeModule")
            ListDirectory(${module} VersionList)
            foreach(version ${VersionList})
                option(Module_${module}_${version} "Application ${module} ${version}")
            endforeach()
        endif()
    endforeach()

    # Define module list 
    set(BuildModuleList ${ModuleList})

endif()

set(CPACK_PACKAGING_INSTALL_PREFIX "${CVL_INSTALLATION_PREFIX}")

include(Cvl)

