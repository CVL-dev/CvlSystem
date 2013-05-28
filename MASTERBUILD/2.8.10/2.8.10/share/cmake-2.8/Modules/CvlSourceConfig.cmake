set(${PROJECT_NAME}_BUILD_STATUS ON)

GetTarball(${PROJECT_NAME}_TARBALL_NAME)

if(${PROJECT_NAME}_TARBALL_NAME MATCHES ".gz$" OR ${PROJECT_NAME}_TARBALL_NAME MATCHES ".tgz$")
    set(${PROJECT_NAME}_TARBALL_COMPRESSION "z")
elseif(${PROJECT_NAME}_TARBALL_NAME MATCHES ".bz2$")

    set(${PROJECT_NAME}_TARBALL_COMPRESSION "j")
else()
    message("Debug: Unknow compression")
endif()

GetSourceDirectory(ConfigDirectory ${${PROJECT_NAME}_TARBALL_NAME} ${${PROJECT_NAME}_TARBALL_COMPRESSION} ${ConfigFileName})

if(NOT ${PROJECT_NAME}_LOCAL_CONFIG) 

    # Configure command
    set(${PROJECT_NAME}_CONFIGURE_COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/config --config ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-prefix/src/${ConfigDirectory} <INSTALL_DIR>)

endif()

# Build in source tree
if(BuildInSource)

    set(${PROJECT_NAME}_BUILD_OPTION BUILD_IN_SOURCE 1)
    set(${PROJECT_NAME}_BUILD_SOURCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-prefix/src/${ConfigDirectory}")

endif()

if(${PROJECT_NAME}_BUILD_STATUS)

    # Patch command
    set(${PROJECT_NAME}_PATCH_COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/config --patch-command ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-prefix/src/${ConfigDirectory} <INSTALL_DIR>)

    # Build command
    set(${PROJECT_NAME}_BUILD_COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/config --make-command)
    
    # Install command
    set(${PROJECT_NAME}_INSTALL_COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/config --install-command)

    message(STATUS "Building ${PROJECT_NAME} in process...")

    # Download command
    set(${PROJECT_NAME}_DOWNLOAD_COMMAND tar ${${PROJECT_NAME}_TARBALL_COMPRESSION}xvf ${CMAKE_CURRENT_SOURCE_DIR}/${${PROJECT_NAME}_TARBALL_NAME})

    # Post installation test and configuration command
    if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/check)
        set(${PROJECT_NAME}_TEST_COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/check ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-prefix/src/${ConfigDirectory} <INSTALL_DIR>)
    else()
        set(${PROJECT_NAME}_TEST_COMMAND echo)
    endif()

    include(CvlSetPackageProperty)

    if(${PROJECT_NAME}_REQUEST_PACKAGE)
        include(CvlInstallation)
    endif()

    include(CvlBuild)
    
    message(STATUS "Building ${PROJECT_NAME} has been completed.")

else()
    message(STATUS "Error to skip building ${PROJECT_NAME}")

endif()
