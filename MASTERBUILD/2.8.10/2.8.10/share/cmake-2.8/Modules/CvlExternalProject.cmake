include(ExternalProject)

# External project
ExternalProject_Add(
    ${PROJECT_NAME} 
    PATCH_COMMAND ${${PROJECT_NAME}_PATCH_COMMAND}
    SOURCE_DIR ${${PROJECT_NAME}_BUILD_SOURCE_DIR}
    DOWNLOAD_COMMAND ${${PROJECT_NAME}_DOWNLOAD_COMMAND}
    INSTALL_DIR ${${PROJECT_NAME}_INSTALL_DIR}
    CONFIGURE_COMMAND ${${PROJECT_NAME}_CONFIGURE_COMMAND} 
    BUILD_COMMAND ${${PROJECT_NAME}_BUILD_COMMAND} 
    ${${PROJECT_NAME}_BUILD_OPTION}
    INSTALL_COMMAND ${${PROJECT_NAME}_INSTALL_COMMAND}
    TEST_AFTER_INSTALL 1
    TEST_COMMAND ${${PROJECT_NAME}_TEST_COMMAND}
)