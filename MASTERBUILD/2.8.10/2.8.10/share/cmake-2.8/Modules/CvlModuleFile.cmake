SetModuleDescription(ModuleDescription)

ModuleValidation(singleCommand)

SetModuleFile(${ModuleDescription} ${${PROJECT_NAME}_VERSION} ${singleCommand} ModuleBase)

WriteModuleFile(${${PROJECT_NAME}_APPLICATION_NAME} ${ModuleBase} ${${PROJECT_NAME}_VERSION})

SetVersion(${${PROJECT_NAME}_VERSION} ModuleVersion)

file(WRITE ${${PROJECT_NAME}_INSTALL_DIR}/.version ${ModuleVersion})
