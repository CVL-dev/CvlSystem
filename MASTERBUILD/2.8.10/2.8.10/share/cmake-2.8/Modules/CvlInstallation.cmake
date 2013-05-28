# Set up package installation.

if(CvlEnableComponentPackage)
    set(ModuleName "${${PROJECT_NAME}_APPLICATION_NAME}-${${PROJECT_NAME}_VERSION}-${${PROJECT_NAME}_PACKAGE_RELEASE}.${CPACK_SYSTEM_NAME}")
endif()

# Install binary directories
# GetInstallDirectory(source destination)

# if(NOT source)
#    set(${PROJECT_NAME}_DESTINATION ${${PROJECT_NAME}_APPLICATION_NAME})
#    set(${PROJECT_NAME}_INSTALL_DIR "${CVL_INSTALLATION_PREFIX}/${${PROJECT_NAME}_APPLICATION_NAME}/${${PROJECT_NAME}_VERSION}")

# else()
#    set(${PROJECT_NAME}_DESTINATION ${destination})
#    set(${PROJECT_NAME}_INSTALL_DIR "${CVL_INSTALLATION_PREFIX}/${source}")

#endif()

if(CvlEnableComponentPackage)
    install(DIRECTORY ${${PROJECT_NAME}_INSTALL_DIR} DESTINATION ${${PROJECT_NAME}_DESTINATION} USE_SOURCE_PERMISSIONS COMPONENT ${ModuleName})
else()
    install(DIRECTORY ${${PROJECT_NAME}_INSTALL_DIR} DESTINATION ${${PROJECT_NAME}_DESTINATION} USE_SOURCE_PERMISSIONS)
endif()

#
# Install modules files.
#
GetModuleFileInstallationFlag(InstallModuleFileFlag)
if(InstallModuleFileFlag)
    include(CvlModuleFile)
    # Install module file directory
    if(CvlEnableComponentPackage)
        install(DIRECTORY ${CMAKE_BINARY_DIR}/modulefiles/${${PROJECT_NAME}_APPLICATION_NAME} DESTINATION /usr/local/Modules/modulefiles USE_SOURCE_PERMISSIONS COMPONENT ${ModuleName})
    else()
#        install(CODE "execute_process(COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/config -m ${CMAKE_BINARY_DIR}/modulefiles/${${PROJECT_NAME}_APPLICATION_NAME} ${ModuleBase} ${ModuleVersion} ${${PROJECT_NAME}_VERSION})")
        install(FILES ${CMAKE_BINARY_DIR}/modulefiles/${${PROJECT_NAME}_APPLICATION_NAME}/${${PROJECT_NAME}_VERSION} DESTINATION /usr/local/Modules/modulefiles/${${PROJECT_NAME}_APPLICATION_NAME})
#        install(FILES ${CMAKE_BINARY_DIR}/modulefiles/${${PROJECT_NAME}_APPLICATION_NAME}/.base DESTINATION /usr/local/Modules/modulefiles/${${PROJECT_NAME}_APPLICATION_NAME})
#        install(FILES ${CMAKE_BINARY_DIR}/modulefiles/${${PROJECT_NAME}_APPLICATION_NAME}/.desc DESTINATION /usr/local/Modules/modulefiles/${${PROJECT_NAME}_APPLICATION_NAME})
#        install(FILES ${CMAKE_BINARY_DIR}/modulefiles/${${PROJECT_NAME}_APPLICATION_NAME}/.version DESTINATION /usr/local/Modules/modulefiles/${${PROJECT_NAME}_APPLICATION_NAME})
        install(DIRECTORY ${CMAKE_BINARY_DIR}/modulefiles/${${PROJECT_NAME}_APPLICATION_NAME} DESTINATION /usr/local/Modules/modulefiles USE_SOURCE_PERMISSIONS)
    endif()
else()
    message("NOT to install module files")
endif()

#
# Install extra configuration file list
#
set(type "FILES")
ExtraInstallation(${type})

#
# Install configuration directory list
#
set(type "DIRECTORY")
ExtraInstallation(${type})

SetPostScriptFile(${${PROJECT_NAME}_APPLICATION_NAME} ${${PROJECT_NAME}_INSTALL_DIR} internalModuleScript)

PreInstallScript(${PROJECT_NAME}_PRE_SCRIPT_FILE)

PostInstallScript("${internalModuleScript}" ${PROJECT_NAME}_POST_SCRIPT_FILE)

AutoDependencyCheck(${PROJECT_NAME}_DEPENDENCY_CHECK)

include(CvlMenu)

#include(CvlCPack)

