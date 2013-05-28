# Set up building modules

CurrentDirectoryName(ApplicationName)
ListDirectory("." LocalDirectoryList)

# Define the version of the source to be built.
set(BuildVersionList ${LocalDirectoryList})

foreach(version ${BuildVersionList})

    if(Module_${ModuleDirectory}_${version})
        set(ProjectName ${ApplicationName}${version})
        project(${ProjectName})
        string(TOLOWER ${ApplicationName} ${PROJECT_NAME}_APPLICATION_NAME)
        set(${PROJECT_NAME}_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
        set(${PROJECT_NAME}_BINARY_DIR "${${PROJECT_NAME}_DESTINATION}")
        add_subdirectory(${version})
    endif()

endforeach(version)
