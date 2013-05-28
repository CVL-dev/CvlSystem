# Build process
if(${PROJECT_NAME}_REQUEST_BUILD)

    include(CvlExternalProject)

    # Package process
    if(${PROJECT_NAME}_REQUEST_PACKAGE)
        include(CvlCPack)
    endif(${PROJECT_NAME}_REQUEST_PACKAGE)
endif(${PROJECT_NAME}_REQUEST_BUILD)

