set(Cvl_SOURCE_DIR ${CMAKE_SOURCE_DIR})
set(Cvl_BINARY_DIR ${CMAKE_BINARY_DIR})

foreach(ModuleDirectory ${BuildModuleList})
    if(CVL_MANUAL_BUILD_FLAG)
        add_subdirectory(${ModuleDirectory})
            AddTest(${CMAKE_CURRENT_SOURCE_DIR}/${ModuleDirectory}/Test ${PROJECT_NAME}_${ModuleDirectory}_Test)
    else()
        if(NOT ${ModuleDirectory} STREQUAL "CmakeModule")
            IsModuleEnabled(IsModuleSelect ${ModuleDirectory})
            if(IsModuleSelect)
                add_subdirectory(${ModuleDirectory})
                AddTest(${CMAKE_CURRENT_SOURCE_DIR}/${ModuleDirectory}/Test ${PROJECT_NAME}_${ModuleDirectory}_Test)
            endif()
        endif()
    endif()
endforeach(ModuleDirectory)
