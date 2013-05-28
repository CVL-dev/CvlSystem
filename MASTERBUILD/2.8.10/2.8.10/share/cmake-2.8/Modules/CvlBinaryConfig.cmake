message("########## run binary config")
ConfigBinaryBuild(${CMAKE_CURRENT_SOURCE_DIR} ${${PROJECT_NAME}_INSTALL_DIR})

include(CvlSetPackageProperty)
include(CvlInstallation)

# Package process
if(${PROJECT_NAME}_REQUEST_PACKAGE)
    include(CvlCPack)
endif(${PROJECT_NAME}_REQUEST_PACKAGE)
