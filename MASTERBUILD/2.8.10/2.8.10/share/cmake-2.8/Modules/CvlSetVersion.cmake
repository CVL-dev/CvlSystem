set(SkipBuild echo)

CurrentDirectoryName(MyDirectoryName)

set(${PROJECT_NAME}_VERSION ${MyDirectoryName})

string(REPLACE "." ";" VersionNumberList ${MyDirectoryName})

list(LENGTH VersionNumberList VersionNumberListLength)

include(CvlCommon)

if(VersionNumberListLength GREATER 1)
    ListIndex(${PROJECT_NAME}_VERSION_MAJOR 1 ${VersionNumberList})
    ListIndex(${PROJECT_NAME}_VERSION_MINOR 2 ${VersionNumberList})
    
    if(VersionNumberListLength GREATER 2)
        ListIndex(${PROJECT_NAME}_VERSION_PATCH 3 ${VersionNumberList})
    elseif(VersionNumberListLength GREATER 3)
        ListIndex(${PROJECT_NAME}_VERSION_TWEAK 4 ${VersionNumberList})
    endif()
endif()
