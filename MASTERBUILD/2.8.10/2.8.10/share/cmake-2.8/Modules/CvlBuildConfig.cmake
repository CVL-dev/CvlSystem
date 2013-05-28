
AddTest(${CMAKE_CURRENT_SOURCE_DIR}/Test ${PROJECT_NAME}_Test)

GetConfigParameter(ConfigFileName BuildInSource ${PROJECT_NAME}_PACKAGE_RELEASE ${PROJECT_NAME}_REQUEST_BUILD ${PROJECT_NAME}_REQUEST_PACKAGE)

GetSourceBuildFlag(isSourceBuild)

# Install binary directories
GetInstallDirectory(source destination)

if(NOT source)
    set(${PROJECT_NAME}_DESTINATION ${${PROJECT_NAME}_APPLICATION_NAME})
    set(${PROJECT_NAME}_INSTALL_DIR "${CVL_INSTALLATION_PREFIX}/${${PROJECT_NAME}_APPLICATION_NAME}/${${PROJECT_NAME}_VERSION}")

else()
    set(${PROJECT_NAME}_DESTINATION ${destination})
    set(${PROJECT_NAME}_INSTALL_DIR "${CVL_INSTALLATION_PREFIX}/${source}")

endif()

if(isSourceBuild)
    if(${PROJECT_NAME}_REQUEST_BUILD)
        include(CvlSourceConfig)
    endif()
else()
    if(${PROJECT_NAME}_REQUEST_PACKAGE)
        include(CvlBinaryConfig)
    endif()
endif()
